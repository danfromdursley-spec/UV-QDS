// qds_stroud_widget_v1.js
(function () {
  // === CONFIG ===
  const TARGET_PAGE = "growthhub_stroud_demo.html";
  const BUTTON_TEXT = "🚀 Stroud District Council Demo";
  // ==============

  function injectStyles() {
    const css = `
      #stroud-demo-cta {
        margin: 2.5rem auto;
        max-width: 640px;
        text-align: center;
        padding: 1.8rem 1.2rem;
        border-radius: 18px;
        background: radial-gradient(circle at top left, #12333a 0, #05060a 55%, #000 100%);
        border: 1px solid rgba(0, 255, 170, 0.35);
        font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      }
      #stroud-demo-cta h2 {
        margin: 0 0 0.4rem 0;
        font-size: 1.6rem;
        letter-spacing: 0.05em;
        text-transform: uppercase;
      }
      #stroud-demo-cta p {
        margin: 0 0 1.4rem 0;
        font-size: 0.95rem;
        opacity: 0.8;
      }
      #stroud-demo-cta .stroud-demo-button {
        display: inline-block;
        padding: 0.85rem 1.8rem;
        border-radius: 999px;
        text-decoration: none;
        font-weight: 600;
        letter-spacing: 0.06em;
        text-transform: uppercase;
        border: 1px solid rgba(0, 255, 200, 0.7);
        background: linear-gradient(135deg, #00ffbf, #00a2ff);
        color: #051014;
        box-shadow: 0 0 14px rgba(0, 255, 190, 0.5);
        cursor: pointer;
        transition: transform 0.12s ease, box-shadow 0.12s ease, filter 0.12s ease;
      }
      #stroud-demo-cta .stroud-demo-button:hover {
        transform: translateY(-1px) scale(1.02);
        box-shadow: 0 0 22px rgba(0, 255, 220, 0.75);
        filter: brightness(1.06);
      }
      #stroud-demo-cta .stroud-demo-button:active {
        transform: translateY(1px) scale(0.99);
        box-shadow: 0 0 10px rgba(0, 255, 200, 0.4);
        filter: brightness(0.95);
      }
    `;
    const styleEl = document.createElement("style");
    styleEl.appendChild(document.createTextNode(css));
    document.head.appendChild(styleEl);
  }

  function createBlock() {
    const container = document.createElement("section");
    container.id = "stroud-demo-cta";

    const h2 = document.createElement("h2");
    h2.textContent = "Stroud District Council";

    const p = document.createElement("p");
    p.textContent = "Local heritage, risk and opportunity — live demo preview.";

    const btn = document.createElement("button");
    btn.className = "stroud-demo-button";
    btn.textContent = BUTTON_TEXT;

    btn.addEventListener("click", () => {
      // same tab:
      window.location.href = TARGET_PAGE;
      // or new tab: window.open(TARGET_PAGE, "_blank");
    });

    container.appendChild(h2);
    container.appendChild(p);
    container.appendChild(btn);

    const mount = document.getElementById("stroud-demo-mount") || document.body;
    mount.appendChild(container);
  }

  function init() {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", () => {
        injectStyles();
        createBlock();
      });
    } else {
      injectStyles();
      createBlock();
    }
  }

  init();
})();
