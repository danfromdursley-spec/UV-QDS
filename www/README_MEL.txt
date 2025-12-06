Stinchcombe HER field hub – Mel Barge edition
=============================================

What this is
------------

A small, self-contained set of Python tools I put together on my phone
to make the Stinchcombe / Taits Hill data easier to explore:

1) Ω-DASHBOARD (omega_dashboard.py)
   - Flask web app that runs on localhost.
   - Shows:
     * Drakestone hillfort bubble (800 m radius)
     * Taits Hill 2025 bubble (600 m radius)
     * Interactive OpenStreetMap + HER overlays
     * Compression lab (shows which text/code files compress best as a
       rough proxy for "hidden structure" or high repetition).

2) HER survey packs (her_survey_pack.py)
   - Command-line tool that takes centre easting/northing + radius
     and prints a neat summary:
       • counts by layer (General / Event / LB / etc.)
       • counts by period (Prehistoric / Medieval / etc., guessed from
         the description text)
       • nearest entries with TAG + distance
   - Used to build the Drakestone + Taits Hill bubble summaries that
     appear in the dashboard.

3) Map builder (stinchcombe_make_map.py + stinchcombe_map.html)
   - Generates an HTML map with:
       • OpenStreetMap basemap
       • HER polygons from "HER polygons.geojson"
       • radius circles for Drakestone and Taits Hill
   - The dashboard simply points at this file instead of calling any
     external tiles/services.

4) Ω-MASTER compression lab (omega_master_bundle.py – optional)
   - Scans a folder of .py / .txt files and reports compression ratios
     (zlib/bz2/lzma).
   - Not essential for HER work, but handy for spotting highly
     structured files or duplicated content.

How to run (desktop / laptop)
-----------------------------

Requirements:

- Python 3.10+ installed.
- A terminal / command prompt.
- The following Python packages:
    pip install flask plotly jinja2

Steps:

1) Unzip this folder somewhere, e.g.:
   C:\HER_TOOLS\Stinchcombe  or  ~/HER_TOOLS/Stinchcombe

2) Open a terminal in that folder and run:

   python omega_dashboard.py

3) The app will say something like:

   [Ω-DASHBOARD] Running on http://127.0.0.1:5000/

4) Open that address in your web browser. You should see:

   - "Drakestone hillfort bubble"
   - "Taits Hill 2025 bubble"
   - "Interactive map"
   - "Ω-Master compression lab"

5) Use the navigation bar (Home / Map / Drakestone / Taits Hill /
   TAG inspector / Compression lab) to move between views.

Notes / caveats
---------------

- This is a personal prototype built to help explore the HER export
  for Stinchcombe / Taits Hill. It’s not official GCC software and
  comes with no guarantees.

- All spatial and attribute data in "HER polygons.geojson" is exactly
  as provided by the HER. No third-party sources have been merged in.

- The period groupings are auto-guessed from the description text,
  so they will occasionally misclassify things – the TAG is always
  the definitive reference.

- Everything runs locally; nothing is uploaded anywhere.

If this is useful and you’d like a version tuned for other casework
areas (or a stripped-down desktop-only variant), I’m happy to help.

– Dan Williams
