#!/usr/bin/env python3
import json, time, platform, os
from pathlib import Path

def now():
    return time.strftime("%Y-%m-%d %H:%M:%S")

def main():
    out = Path("./QDS_FIELDKIT_LOGS")
    out.mkdir(exist_ok=True)

    payload = {
        "ts": now(),
        "epoch": time.time(),
        "device": platform.platform(),
        "python": platform.python_version(),
        "cwd": os.getcwd(),
        "note": "QDS 5-Wedge Field Kit micro-log",
        "checks": {
            "battery_ar1_demo": "ok-placeholder",
            "compression_demo": "ok-placeholder",
            "noise_demo": "ok-placeholder",
        }
    }

    fname = out / f"fieldkit_{int(time.time())}.json"
    fname.write_text(json.dumps(payload, indent=2))
    print("✅ Wrote:", fname)

if __name__ == "__main__":
    main()
