(function() {
  // Default configuration
  const DEFAULTS = {
    emojis: [],
    duration: 6000,
    fallSpeed: 1.5,
    enableSpin: false,
    spinSpeed: 3,
    particleCount: 15,
    burstCount: 8,
    imageSize: 32,
    trigger: "app_load",
    zIndex: 9999,
    opacity: 1,
    minSize: 20,
    maxSize: 35,
    wind: 0 // Horizontal drift bias
  };

  let CONFIG = { ...DEFAULTS };
  let particles = [];
  let animationId = null;

  function isImageUrl(str) {
    // Check if it's a web URL (http/https) or data URI, or ends with image extension
    return /^https?:\/\//i.test(str) || 
           /^data:image/i.test(str) || 
           /\.(jpg|jpeg|png|gif|webp|svg)$/i.test(str);
  }

  function Particle(x, y, content, velocityX, velocityY, range, enableSpin, spinSpeed, imageSize, opacity, minSize, maxSize) {
    this.x = x;
    this.y = y;
    this.content = content;
    this.velocityX = velocityX;
    this.velocityY = velocityY;
    this.range = range;
    this.rotation = 0;
    this.enableSpin = enableSpin;
    this.spinSpeed = spinSpeed || 3;
    this.element = document.createElement("div");
    this.element.className = "emoji-rain-particle";
    this.element.style.position = "fixed";
    this.element.style.opacity = opacity;
    this.element.style.pointerEvents = "none";
    this.element.style.userSelect = "none";
    this.element.style.willChange = "transform";
    
    if (isImageUrl(content)) {
      var img = document.createElement("img");
      img.src = content;
      img.style.width = imageSize + "px";
      img.style.height = imageSize + "px";
      img.style.objectFit = "contain";
      img.style.display = "block";
      img.style.pointerEvents = "none";
      this.element.appendChild(img);
      this.element.style.width = imageSize + "px";
      this.element.style.height = imageSize + "px";
      this.element.style.display = "flex";
      this.element.style.alignItems = "center";
      this.element.style.justifyContent = "center";
    } else {
      // Random size between minSize and maxSize
      var size = minSize + Math.random() * (maxSize - minSize);
      this.element.style.fontSize = size + "px";
      this.element.style.lineHeight = "1";
      this.element.style.display = "inline-block";
      this.element.textContent = content;
    }
    
    var container = document.getElementById("emoji-shower-container");
    if (container) {
        container.appendChild(this.element);
    } else {
        // Fallback if container doesn't exist yet (shouldn't happen if properly initialized)
        document.body.appendChild(this.element);
    }
    
    this.update();
  }

  Particle.prototype.update = function() {
    this.y += this.velocityY;
    this.x += this.velocityX;
    if (this.enableSpin) {
      this.rotation = (this.rotation + this.spinSpeed) % 360;
    }
    
    // Respawn if out of view
    if (this.y > window.innerHeight + 100) {
      this.y = -50;
      this.x = this.range[0] + Math.random() * this.range[1];
    }
    
    var transform = "translate3d(" + this.x + "px, " + this.y + "px, 0)";
    if (this.enableSpin) {
      transform += " rotate(" + this.rotation + "deg)";
    }
    this.element.style.transform = transform;
  };

  function startShower(customConfig) {
    // Reset CONFIG to defaults first
    CONFIG = { ...DEFAULTS };
    
    // Then merge in window.EmojiRainConfig if it exists
    if (window.EmojiRainConfig) {
        CONFIG = { ...CONFIG, ...window.EmojiRainConfig };
    }
    
    // Finally merge custom config if provided (takes priority)
    if (customConfig && typeof customConfig === 'object') {
        CONFIG = { ...CONFIG, ...customConfig };
    }

    // Validate that we have emojis
    if (!CONFIG.emojis || !Array.isArray(CONFIG.emojis) || CONFIG.emojis.length === 0) {
        console.warn("No emojis configured for emoji shower");
        return;
    }

    // Update container style
    var container = document.getElementById("emoji-shower-container");
    if (!container) {
        container = document.createElement("div");
        container.id = "emoji-shower-container";
        container.style.position = "fixed";
        container.style.top = "0";
        container.style.left = "0";
        container.style.width = "100%";
        container.style.height = "100%";
        container.style.pointerEvents = "none";
        container.style.overflow = "hidden";
        document.body.appendChild(container);
    }
    container.style.zIndex = CONFIG.zIndex;

    if (particles.length > 0) {
      particles.forEach(function(p) { if(p.element.parentNode) p.element.parentNode.removeChild(p.element); });
      particles = [];
    }
    
    var contentList = CONFIG.emojis;
    var range = [0, window.innerWidth];
    
    for (var burst = 0; burst < CONFIG.burstCount; burst++) {
      setTimeout((function(b) {
        return function() {
          for (var i = 0; i < CONFIG.particleCount; i++) {
            var content = contentList[Math.floor(Math.random() * contentList.length)];
            var x = range[0] + Math.random() * range[1];
            // Add wind factor to velocityX
            var velocityX = -0.3 + Math.random() * 0.6 + CONFIG.wind; 
            var velocityY = CONFIG.fallSpeed + Math.random() * CONFIG.fallSpeed * 0.5;
            
            particles.push(new Particle(
                x, -50, content, velocityX, velocityY, range, 
                CONFIG.enableSpin, CONFIG.spinSpeed, CONFIG.imageSize, 
                CONFIG.opacity, CONFIG.minSize, CONFIG.maxSize
            ));
          }
        };
      })(burst), burst * 200);
    }
    
    function animate() {
      particles.forEach(function(p) { p.update(); });
      animationId = requestAnimationFrame(animate);
    }
    
    if (animationId) cancelAnimationFrame(animationId);
    animate();
    
    setTimeout(function() {
      cancelAnimationFrame(animationId);
      particles.forEach(function(p) { if(p.element.parentNode) p.element.parentNode.removeChild(p.element); });
      particles = [];
    }, CONFIG.duration);
  }

  // Expose to global scope
  window.triggerEmojiShower = startShower;

  // Auto-trigger if configured
  document.addEventListener("DOMContentLoaded", function() {
      if (window.EmojiRainConfig && window.EmojiRainConfig.trigger === "app_load") {
          startShower();
      }
  });

})();
