#!/usr/bin/env python3
# Simple AR(1) stress toy (no deps)
import random, math

def simulate(n=120, phi=0.92, sigma=0.08, seed=42):
    random.seed(seed)
    x=0.0
    series=[]
    for _ in range(n):
        eps = random.gauss(0, sigma)
        x = phi*x + eps
        series.append(x)
    return series

def rms(xs):
    return math.sqrt(sum(x*x for x in xs)/len(xs))

def main():
    s = simulate()
    print("=== QDS Battery AR(1) micro-toy ===")
    print("n=120  phi=0.92  sigma=0.08")
    print("RMS stress:", round(rms(s), 6))
    print("Last 10:", [round(x, 4) for x in s[-10:]])
    print("(Toy only — used to show reproducible pipeline.)")

if __name__ == "__main__":
    main()
