import zipfile
from pathlib import Path
import sys

base = Path(__file__).parent
out = base / "lambda_ir_reporter.zip"

files = [
    "handler.py",
    "claude.py",   # remove if not used
]

missing = [f for f in files if not (base / f).exists()]
if missing:
    print("Missing files:", missing)
    sys.exit(1)

with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    for f in files:
        z.write(base / f, arcname=f)

print("ZIP created:", out)
