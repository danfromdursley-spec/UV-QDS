#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "QDS GrowthHub Revenue Predictor (honest-mode)"
echo

read -p "Leads per month (L_m) [e.g., 6]: " Lm
read -p "Qualified rate q (0-1) [e.g., 0.5]: " q
read -p "Sprint close c_s (0-1) [e.g., 0.4]: " cs
read -p "Pilot-from-sprint k_p (0-1) [e.g., 0.5]: " kp
read -p "Retainer-from-pilot k_r (0-1) [e.g., 0.4]: " kr

echo
read -p "Sprint price S [e.g., 1000]: " S
read -p "Pilot price P [e.g., 8000]: " P
read -p "Monthly retainer R [e.g., 1500]: " R

calc () { python - <<'PY'
Lm=float("$Lm"); q=float("$q"); cs=float("$cs"); kp=float("$kp"); kr=float("$kr")
S=float("$S"); P=float("$P"); R=float("$R")

Ns = Lm*q*cs
Np = Ns*kp
Nr = Np*kr

rev_m = Ns*S + Np*P + Nr*R
rev_y = 12*rev_m

print(f"Expected sprints/mo:   {Ns:.2f}")
print(f"Expected pilots/mo:    {Np:.2f}")
print(f"Expected retainers/mo: {Nr:.2f}")
print()
print(f"Estimated revenue/mo:  £{rev_m:,.0f}")
print(f"Estimated revenue/yr:  £{rev_y:,.0f}")
PY
}
calc
