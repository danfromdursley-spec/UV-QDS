# Phone + ChatGPT Dev Lab · Case Study

A real-world story of how a non-developer used **ChatGPT**, **Termux** and a mid-range **Android phone** to build a working mini R&D environment:

- 1,700+ small **Python scripts**  
- 250+ **HTML tools & dashboards**  
- 24,000+ files touched across the project  
- All created on-device, in spare time, with no prior web or Bash experience

This repo is a lightweight snapshot of that experiment.

---

## 01 · Starting point

I’m **not** a professional developer. Before this experiment I had:

- No experience with web development or JavaScript.  
- No experience writing Bash scripts or using Linux day to day.  
- No large-scale Python projects.

My “starting kit” was:

- A single **Android phone**.  
- **Termux** for a Linux-like shell.  
- A mobile browser.  
- **ChatGPT** as the main teacher, pair-programmer and debugger.

Everything else — HTML layouts, Python utilities, Bash tooling, and file-organisation tricks — was learned inside real tasks, with ChatGPT guiding each step.

---

## 02 · What got built

Since **20 October 2025**, the phone + ChatGPT combo produced a small but very real “lab OS”:

- **1,700+ Python scripts** for simulations, data tools and helpers.  
- **250+ HTML files** forming dashboards and microsites: physics toys, business tools, local heritage demos, and more.  
- A growing set of Bash scripts for scanning, stats, and project housekeeping.  

Most of it runs locally via:

```bash
python -m http.server 8000
