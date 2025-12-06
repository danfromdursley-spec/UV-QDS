#!/usr/bin/env python3
import zlib, bz2, lzma, os, random

def make_payload(n=200_000, seed=7):
    random.seed(seed)
    # semi-structured text-ish payload
    chunks=[]
    words = ["qds","kernel","tau","lambda","sigma","noise","coherence","fieldkit"]
    for i in range(n//40):
        line = " ".join(random.choice(words) for _ in range(10)) + "\n"
        chunks.append(line)
    return "".join(chunks).encode()

def ratio(raw, comp):
    return len(comp)/len(raw)

def main():
    raw = make_payload()
    z = zlib.compress(raw, 9)
    b = bz2.compress(raw, 9)
    l = lzma.compress(raw)

    print("=== QDS Compression micro-toy ===")
    print("Raw bytes:", len(raw))
    print("zlib:", len(z), "ratio", round(ratio(raw,z), 3))
    print("bz2 :", len(b), "ratio", round(ratio(raw,b), 3))
    print("xz  :", len(l), "ratio", round(ratio(raw,l), 3))
    print("(Synthetic sanity check only.)")

if __name__ == "__main__":
    main()
