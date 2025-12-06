
# === EMBEDDED QDSX ENGINE v1.2 ===
import os, io, sys, json, struct, time, hashlib, random
import zlib, bz2, lzma
from pathlib import Path

LOG_DIR = Path("./QDSX_logs")
LOG_DIR.mkdir(parents=True, exist_ok=True)

MAGIC=b"QDSX"
VERSION=1

def sha256_bytes(b): h=hashlib.sha256(); h.update(b); return h.hexdigest()

def qdsx_pack(path):
    with open(path,"rb") as f: raw=f.read()
    orig_sha=sha256_bytes(raw)
    TRANS={"none":lambda d:d,
           "delta":lambda d:bytes([(d[i]-d[i-1])&0xFF if i>0 else d[0] for i in range(len(d))]),
           "rle":None}
    best=None; best_key=None
    # Fast mode: just zlib + lzma for speed
    for cname,enc in [("zlib",lambda b:zlib.compress(b,9)),
                      ("lzma",lambda b:lzma.compress(b,preset=9|lzma.PRESET_EXTREME))]:
        try:
            c = enc(raw)
            if best is None or len(c)<best:
                best=len(c); best_key=(cname,c)
        except:
            pass
    cname,cdata=best_key
    header={"version":1,"orig_name":os.path.basename(path),"orig_size":len(raw),
            "orig_sha256":orig_sha,"codec":cname}
    hdr=json.dumps(header).encode()
    out=path+".qdsx"
    with open(out,"wb") as f:
        f.write(b"QDSX"+len(hdr).to_bytes(4,"big")+hdr+cdata)
    return out

def qdsx_unpack(path,return_bytes=False):
    with open(path,"rb") as f: blob=f.read()
    assert blob[:4]==b"QDSX"
    off=4
    hlen=int.from_bytes(blob[off:off+4],"big"); off+=4
    hdr=json.loads(blob[off:off+hlen].decode()); off+=hlen
    cdata=blob[off:]
    codec=hdr["codec"]
    dec = zlib.decompress if codec=="zlib" else lzma.decompress
    raw=dec(cdata)
    if sha256_bytes(raw)!=hdr["orig_sha256"]:
        raise RuntimeError("Integrity fail")
    if return_bytes: return raw
    out=str(Path(path).with_suffix(""))
    with open(out,"wb") as f: f.write(raw)
    return out
