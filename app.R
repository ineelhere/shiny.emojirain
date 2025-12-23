library(shiny)
if (!require("shiny.emojirain")) {
  devtools::install_github("ineelhere/shiny.emojirain")
}
library(shiny.emojirain)

ui <- fluidPage(
  tags$head(
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap",
      rel = "stylesheet"
    ),
    tags$style(HTML("
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        overflow-x: hidden;
      }

      /* Animated background stars */
      body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-image:
          radial-gradient(2px 2px at 20px 30px, rgba(255,255,255,0.3), transparent),
          radial-gradient(2px 2px at 40px 70px, rgba(255,255,255,0.2), transparent),
          radial-gradient(1px 1px at 90px 40px, rgba(255,255,255,0.4), transparent),
          radial-gradient(2px 2px at 160px 120px, rgba(255,255,255,0.3), transparent),
          radial-gradient(1px 1px at 230px 80px, rgba(255,255,255,0.2), transparent),
          radial-gradient(2px 2px at 300px 150px, rgba(255,255,255,0.4), transparent),
          radial-gradient(1px 1px at 400px 60px, rgba(255,255,255,0.3), transparent),
          radial-gradient(2px 2px at 500px 200px, rgba(255,255,255,0.2), transparent);
        background-size: 550px 550px;
        animation: twinkle 4s ease-in-out infinite alternate;
        pointer-events: none;
        z-index: 0;
      }

      @keyframes twinkle {
        0% { opacity: 0.5; }
        100% { opacity: 1; }
      }

      .main-content {
        flex: 1;
        padding: 50px 20px;
        position: relative;
        z-index: 1;
      }

      .header-section {
        text-align: center;
        color: white;
        margin-bottom: 40px;
      }

      .header-section h1 {
        font-size: 56px;
        font-weight: 700;
        letter-spacing: -2px;
        margin-bottom: 12px;
        background: linear-gradient(135deg, #fff 0%, #a78bfa 50%, #fcd34d 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: none;
        animation: glow 3s ease-in-out infinite alternate;
      }

      @keyframes glow {
        0% { filter: drop-shadow(0 0 10px rgba(167, 139, 250, 0.3)); }
        100% { filter: drop-shadow(0 0 20px rgba(167, 139, 250, 0.6)); }
      }

      .header-section .tagline {
        font-size: 18px;
        opacity: 0.9;
        font-weight: 400;
        color: #c4b5fd;
        margin-bottom: 8px;
      }

      .header-section .subtitle {
        font-size: 14px;
        opacity: 0.7;
        font-weight: 300;
        color: #a5b4fc;
      }

      .button-grid {
        max-width: 900px;
        margin: 0 auto 40px auto;
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-radius: 24px;
        padding: 40px 35px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        box-shadow:
          0 25px 50px -12px rgba(0, 0, 0, 0.5),
          inset 0 1px 0 rgba(255, 255, 255, 0.1);
      }

      .section-label {
        text-align: center;
        font-size: 13px;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 2px;
        color: #a5b4fc;
        margin-bottom: 25px;
      }

      .button-row {
        display: flex;
        gap: 15px;
        margin-bottom: 15px;
        flex-wrap: wrap;
      }

      .button-row:last-child {
        margin-bottom: 0;
      }

      .button-col {
        flex: 1;
        min-width: 140px;
      }

      .btn-celebration {
        width: 100%;
        padding: 20px 15px !important;
        font-size: 16px !important;
        font-weight: 600 !important;
        font-family: 'Inter', sans-serif !important;
        border: none !important;
        border-radius: 14px !important;
        cursor: pointer;
        transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1) !important;
        box-shadow:
          0 4px 15px rgba(0, 0, 0, 0.2),
          inset 0 1px 0 rgba(255, 255, 255, 0.2) !important;
        height: auto !important;
        position: relative;
        overflow: hidden;
      }

      .btn-celebration::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.5s ease;
      }

      .btn-celebration:hover::before {
        left: 100%;
      }

      .btn-celebration:hover {
        transform: translateY(-4px) scale(1.02);
        box-shadow:
          0 12px 30px rgba(0, 0, 0, 0.3),
          inset 0 1px 0 rgba(255, 255, 255, 0.3) !important;
      }

      .btn-celebration:active {
        transform: translateY(-2px) scale(1.01);
      }

      .btn-xmas { background: linear-gradient(135deg, #22c55e 0%, #15803d 100%); color: white; }
      .btn-xmas:hover { background: linear-gradient(135deg, #16a34a 0%, #166534 100%); }

      .btn-bday { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: white; }
      .btn-bday:hover { background: linear-gradient(135deg, #d97706 0%, #b45309 100%); }

      .btn-halloween { background: linear-gradient(135deg, #f97316 0%, #7c2d12 100%); color: white; }
      .btn-halloween:hover { background: linear-gradient(135deg, #ea580c 0%, #6c2910 100%); }

      .btn-love { background: linear-gradient(135deg, #ec4899 0%, #be185d 100%); color: white; }
      .btn-love:hover { background: linear-gradient(135deg, #db2777 0%, #9d174d 100%); }

      .btn-success { background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); color: white; }
      .btn-success:hover { background: linear-gradient(135deg, #0891b2 0%, #0e7490 100%); }

      .btn-party { background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%); color: white; }
      .btn-party:hover { background: linear-gradient(135deg, #7c3aed 0%, #5b21b6 100%); }

      /* CTA Section */
      .cta-section {
        max-width: 900px;
        margin: 0 auto 40px auto;
        background: linear-gradient(135deg, rgba(139, 92, 246, 0.15) 0%, rgba(236, 72, 153, 0.15) 100%);
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        border-radius: 20px;
        padding: 35px 40px;
        border: 1px solid rgba(167, 139, 250, 0.3);
        text-align: center;
      }

      .cta-title {
        font-size: 26px;
        font-weight: 700;
        color: white;
        margin-bottom: 12px;
      }

      .cta-description {
        font-size: 15px;
        color: #c4b5fd;
        line-height: 1.7;
        margin-bottom: 25px;
        max-width: 600px;
        margin-left: auto;
        margin-right: auto;
      }

      .cta-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        flex-wrap: wrap;
      }

      .cta-btn {
        padding: 14px 28px;
        font-size: 14px;
        font-weight: 600;
        font-family: 'Inter', sans-serif;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }

      .cta-btn-primary {
        background: linear-gradient(135deg, #8b5cf6 0%, #ec4899 100%);
        color: white;
        border: none;
        box-shadow: 0 4px 20px rgba(139, 92, 246, 0.4);
      }

      .cta-btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 30px rgba(139, 92, 246, 0.5);
        color: white;
      }

      .cta-btn-secondary {
        background: rgba(255, 255, 255, 0.1);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.2);
      }

      .cta-btn-secondary:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: translateY(-2px);
        color: white;
      }

      /* Integration Info Box */
      .integration-box {
        max-width: 900px;
        margin: 0 auto 40px auto;
        background: rgba(34, 197, 94, 0.1);
        backdrop-filter: blur(15px);
        -webkit-backdrop-filter: blur(15px);
        border-radius: 16px;
        padding: 25px 30px;
        border: 1px solid rgba(34, 197, 94, 0.3);
        display: flex;
        align-items: center;
        gap: 20px;
        flex-wrap: wrap;
      }

      .integration-icon {
        font-size: 40px;
        flex-shrink: 0;
      }

      .integration-content {
        flex: 1;
        min-width: 250px;
      }

      .integration-title {
        font-size: 16px;
        font-weight: 600;
        color: #86efac;
        margin-bottom: 6px;
      }

      .integration-text {
        font-size: 14px;
        color: rgba(255, 255, 255, 0.8);
        line-height: 1.6;
      }

      .integration-text a {
        color: #86efac;
        text-decoration: none;
        font-weight: 500;
        border-bottom: 1px dashed rgba(134, 239, 172, 0.5);
        transition: all 0.3s ease;
      }

      .integration-text a:hover {
        color: #4ade80;
        border-bottom-color: #4ade80;
      }

      .integration-text code {
        background: rgba(255, 255, 255, 0.15);
        padding: 2px 8px;
        border-radius: 6px;
        font-family: 'SF Mono', Consolas, monospace;
        font-size: 13px;
        color: #fcd34d;
      }

      .footer {
        background: rgba(0, 0, 0, 0.3);
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        padding: 25px;
        text-align: center;
        font-size: 14px;
        color: rgba(255, 255, 255, 0.7);
        position: relative;
        z-index: 1;
      }

      .footer a {
        color: #a78bfa;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s ease;
      }

      .footer a:hover {
        color: #c4b5fd;
      }

      .footer-divider {
        opacity: 0.5;
        margin: 0 10px;
      }

      /* Responsive */
      @media (max-width: 600px) {
        .header-section h1 {
          font-size: 36px;
        }
        .header-section .tagline {
          font-size: 15px;
        }
        .button-grid, .cta-section, .integration-box {
          margin-left: 15px;
          margin-right: 15px;
          padding: 25px 20px;
        }
        .button-col {
          min-width: 100%;
        }
        .cta-title {
          font-size: 22px;
        }
        .integration-box {
          flex-direction: column;
          text-align: center;
        }
      }
    "))
  ),

  div(
    class = "main-content",
    setup_emoji_handler(),
    emoji_shower_ui(trigger = NULL),

    div(
      class = "header-section",
      h1("Emoji Rain"),
      p(class = "tagline", "✨ Make your Shiny apps come alive with stunning emoji animations ✨"),
      p(class = "subtitle", "Click any theme below and watch the magic happen!")
    ),

    div(
      class = "button-grid",
      div(class = "section-label", "Choose a Theme"),
      div(
        class = "button-row",
        div(class = "button-col", actionButton("xmas", "🎄 Christmas", class = "btn btn-celebration btn-xmas btn-block")),
        div(class = "button-col", actionButton("bday", "🎂 Birthday", class = "btn btn-celebration btn-bday btn-block")),
        div(class = "button-col", actionButton("halloween", "🎃 Halloween", class = "btn btn-celebration btn-halloween btn-block"))
      ),
      div(
        class = "button-row",
        div(class = "button-col", actionButton("love", "💖 Love", class = "btn btn-celebration btn-love btn-block")),
        div(class = "button-col", actionButton("success", "🏆 Success", class = "btn btn-celebration btn-success btn-block")),
        div(class = "button-col", actionButton("party", "🥳 Party", class = "btn btn-celebration btn-party btn-block"))
      )
    ),

    # CTA Section
    div(
      class = "cta-section",
      h2(class = "cta-title", "🚀 Add Emoji Rain to Your Shiny App"),
      p(
        class = "cta-description",
        "Transform your Shiny applications with delightful emoji animations. Perfect for celebrations, ",
        "notifications, milestones, or just adding a touch of fun to your data dashboards!"
      ),
      div(
        class = "cta-buttons",
        tags$a(
          class = "cta-btn cta-btn-primary",
          href = "https://ineelhere.github.io/shiny.emojirain/",
          target = "_blank",
          "📖 View Documentation"
        ),
        tags$a(
          class = "cta-btn cta-btn-secondary",
          href = "https://github.com/ineelhere/shiny.emojirain/",
          target = "_blank",
          "⭐ Star on GitHub"
        )
      )
    ),

    # Integration Info Box
    div(
      class = "integration-box",
      span(class = "integration-icon", "📦"),
      div(
        class = "integration-content",
        div(class = "integration-title", "Want to add emoji rain to your own app?"),
        p(
          class = "integration-text",
          "Install the ", tags$code("shiny.emojirain"), " R package and bring delightful animations to your Shiny apps in just a few lines of code! ",
          "Full documentation available at ",
          tags$a(href = "https://ineelhere.github.io/shiny.emojirain", target = "_blank", "ineelhere.github.io/shiny.emojirain"),
          "."
        )
      )
    )
  ),

  div(
    class = "footer",
    "Built with ",
    tags$a("{shiny.emojirain}", href = "https://github.com/ineelhere/shiny.emojirain/", target = "_blank"),
    span(class = "footer-divider", "•"),
    " MIT License ",
    span(class = "footer-divider", "•"),
    tags$a("Indraneel Chakraborty", href = "https://github.com/ineelhere", target = "_blank")
  )
)

server <- function(input, output, session) {
  observeEvent(input$xmas, {
    emit_shower(session, emojis = emoji_presets()$christmas, spin_speed = 2)
  })

  observeEvent(input$bday, {
    emit_shower(session, emojis = emoji_presets()$birthday)
  })

  observeEvent(input$halloween, {
    emit_shower(session, emojis = emoji_presets()$halloween, opacity = 0.8)
  })

  observeEvent(input$love, {
    emit_shower(session, emojis = emoji_presets()$love, fall_speed = 1.2)
  })

  observeEvent(input$success, {
    emit_shower(session, emojis = emoji_presets()$success, spin_speed = 3)
  })

  observeEvent(input$party, {
    emit_shower(session, emojis = emoji_presets()$party, particle_count = 30)
  })
}

shinyApp(ui, server)
