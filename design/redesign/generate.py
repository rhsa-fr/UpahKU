#!/usr/bin/env python3
"""
UpahKu — redesign board generator (v3, feature parity).

Menghasilkan `index.html`: prototipe live 5 layar + parity table + panel spesifikasi.
Jalankan:  python generate.py
Live:      python -m http.server 4173 --directory .
"""

from __future__ import annotations

import json
from pathlib import Path

OUT = Path(__file__).resolve().parent


def rp(value: float | int) -> str:
    return "Rp " + f"{int(round(value)):,}".replace(",", ".")


def num(value: float | int) -> str:
    return f"{value:g}".replace(".", ",")


# ── Ikon (stroke, 24×24) ─────────────────────────────────────────────────────
ICONS = {
    "grid": '<rect x="4" y="4" width="7" height="7" rx="1.5"/><rect x="13" y="4" width="7" height="7" rx="1.5"/><rect x="4" y="13" width="7" height="7" rx="1.5"/><rect x="13" y="13" width="7" height="7" rx="1.5"/>',
    "users": '<circle cx="9" cy="8" r="3"/><path d="M3 20c0-3 3-5 6-5s6 2 6 5"/><path d="M16 6a3 3 0 0 1 0 5M18 20c0-2-1-3.5-2.5-4.5"/>',
    "check": '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M8 3v4M16 3v4M3 10h18M9 15l2 2 4-4"/>',
    "clock": '<circle cx="12" cy="12" r="8"/><path d="M12 8v4l3 2"/>',
    "wallet": '<path d="M4 7a2 2 0 0 1 2-2h12v4"/><rect x="4" y="7" width="16" height="12" rx="2"/><path d="M16 13h2"/>',
    "file": '<path d="M6 3h8l4 4v14H6z"/><path d="M14 3v5h5M9 13h6M9 17h4"/>',
    "history": '<path d="M4 12a8 8 0 1 0 3-6"/><path d="M4 4v5h5"/><path d="M12 8v4l3 2"/>',
    "database": '<ellipse cx="12" cy="6" rx="7" ry="3"/><path d="M5 6v6c0 1.7 3.1 3 7 3s7-1.3 7-3V6"/><path d="M5 12v6c0 1.7 3.1 3 7 3s7-1.3 7-3v-6"/>',
    "upload": '<path d="M12 16V4M7 9l5-5 5 5"/><path d="M4 16v3a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-3"/>',
    "palette": '<path d="M12 3a9 9 0 1 0 0 18h1.5a2 2 0 0 0 0-4H13a2 2 0 0 1 0-4h4a4 4 0 0 0 4-4c0-3.3-4-6-9-6z"/><circle cx="8" cy="10" r="1"/><circle cx="12" cy="7" r="1"/>',
    "user": '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3.5-6 8-6s8 2 8 6"/>',
    "info": '<circle cx="12" cy="12" r="9"/><path d="M12 11v6M12 7h.01"/>',
    "search": '<circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>',
    "plus": '<path d="M12 5v14M5 12h14"/>',
    "chev": '<path d="M9 6l6 6-6 6"/>',
    "arrow": '<path d="M5 12h14M13 6l6 6-6 6"/>',
    "receipt": '<path d="M6 3h12v18l-3-2-3 2-3-2-3 2V3z"/><path d="M9 8h6M9 12h6"/>',
    "shield": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M9 12l2 2 4-4"/>',
    "download": '<path d="M12 4v12M7 11l5 5 5-5"/><path d="M4 20h16"/>',
    "trash": '<path d="M4 7h16M9 7V5h6v2M7 7l1 13h8l1-13"/>',
    "edit": '<path d="M4 20h4l11-11-4-4L4 16z"/><path d="M14 5l4 4"/>',
    "trend": '<path d="M3 17l6-6 4 4 8-8"/><path d="M15 7h6v6"/>',
    "alert": '<path d="M12 4l9 16H3z"/><path d="M12 10v4M12 17h.01"/>',
    "bolt": '<path d="M13 3L5 14h6l-1 7 8-11h-6z"/>',
    "filter": '<path d="M4 5h16l-6 7v6l-4 2v-8z"/>',
    "refresh": '<path d="M20 12a8 8 0 1 1-2.3-5.7"/><path d="M20 4v5h-5"/>',
    "lock": '<rect x="5" y="10" width="14" height="10" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/>',
    "calculator": '<rect x="5" y="3" width="14" height="18" rx="2"/><path d="M8 7h8M8 11h2M12 11h2M16 11h.01M8 15h2M12 15h2M16 15h.01M8 19h6"/>',
    "activity": '<path d="M3 12h4l2-7 4 14 2-7h6"/>',
    "list": '<path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/>',
    "gear": '<circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M4.2 4.2l2.1 2.1M17.7 17.7l2.1 2.1M2 12h3M19 12h3M4.2 19.8l2.1-2.1M17.7 6.3l2.1-2.1"/>',
    "wifi-off": '<path d="M3 3l18 18"/><path d="M8.5 15.5a5 5 0 0 1 7 0"/><path d="M5 12a10 10 0 0 1 3-2M19 12a10 10 0 0 0-3-2"/><path d="M12 19h.01"/>',
    "calendar": '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M8 3v4M16 3v4M3 10h18"/>',
    "x": '<path d="M6 6l12 12M18 6L6 18"/>',
    "medical": '<path d="M12 5v14M5 12h14"/>',
}


def icon(name: str, cls: str = "") -> str:
    return f'<svg class="{cls}" viewBox="0 0 24 24" aria-hidden="true">{ICONS[name]}</svg>'


# ── Data contoh ───────────────────────────────────────────────────────────────
WORKERS = [
    {"id": 1, "nama": "Joko Prasetyo",  "jabatan": "Mandor",      "rate": 225000, "status": "H", "lembur": 1.0, "kasbon": 250000, "bonus": 150000, "potongan": 0,      "hadir15": 13, "lembur15": 9, "aktif": True},
    {"id": 2, "nama": "Slamet Riyadi",  "jabatan": "Tukang Batu", "rate": 160000, "status": "H", "lembur": 0.5, "kasbon": 0,      "bonus": 0,      "potongan": 0,      "hadir15": 12, "lembur15": 6, "aktif": True},
    {"id": 3, "nama": "Asep Saepudin",  "jabatan": "Tukang Kayu", "rate": 160000, "status": "H", "lembur": 0.0, "kasbon": 100000, "bonus": 0,      "potongan": 0,      "hadir15": 13, "lembur15": 4, "aktif": True},
    {"id": 4, "nama": "Dedi Kurniawan", "jabatan": "Kenek",       "rate": 125000, "status": "H", "lembur": 1.0, "kasbon": 0,      "bonus": 0,      "potongan": 0,      "hadir15": 11, "lembur15": 7, "aktif": True},
    {"id": 5, "nama": "Yusuf Maulana",  "jabatan": "Operator",    "rate": 180000, "status": "H", "lembur": 0.5, "kasbon": 0,      "bonus": 100000, "potongan": 0,      "hadir15": 12, "lembur15": 5, "aktif": True},
    {"id": 6, "nama": "Rudi Hartono",   "jabatan": "Tukang Besi", "rate": 155000, "status": "I", "lembur": 0.0, "kasbon": 0,      "bonus": 0,      "potongan": 0,      "hadir15": 11, "lembur15": 3, "aktif": True},
    {"id": 7, "nama": "Wawan Setiawan", "jabatan": "Kenek",       "rate": 125000, "status": "S", "lembur": 0.0, "kasbon": 50000,  "bonus": 0,      "potongan": 0,      "hadir15": 10, "lembur15": 2, "aktif": True},
    {"id": 8, "nama": "Agus Salim",     "jabatan": "Tukang Batu", "rate": 160000, "status": None, "lembur": 0.0, "kasbon": 0,     "bonus": 0,      "potongan": 0,      "hadir15": 11, "lembur15": 3, "aktif": True},
    {"id": 9, "nama": "Bayu Nugroho",   "jabatan": "Kenek",       "rate": 125000, "status": "H", "lembur": 0.5, "kasbon": 0,     "bonus": 0,      "potongan": 0,      "hadir15": 12, "lembur15": 4, "aktif": True},
    {"id": 10, "nama": "Tono Wijaya",   "jabatan": "Tukang Kayu", "rate": 160000, "status": None, "lembur": 0.0, "kasbon": 75000, "bonus": 0,     "potongan": 0,      "hadir15": 13, "lembur15": 5, "aktif": True},
    {"id": 11, "nama": "Iwan Setiadi",  "jabatan": "Tukang Besi", "rate": 155000, "status": "H", "lembur": 0.0, "kasbon": 0,     "bonus": 0,      "potongan": 25000,  "hadir15": 12, "lembur15": 2, "aktif": True},
    {"id": 12, "nama": "H. Suryana",    "jabatan": "Pengawas",    "rate": 200000, "status": "H", "lembur": 0.0, "kasbon": 0,     "bonus": 200000, "potongan": 0,      "hadir15": 13, "lembur15": 8, "aktif": True},
]

STATUS_META = {
    "H": {"label": "Hadir", "class": "ok"},
    "I": {"label": "Izin", "class": "info"},
    "S": {"label": "Sakit", "class": "warn"},
    "A": {"label": "Alfa", "class": "bad"},
    None: {"label": "Belum", "class": "neutral"},
}


def tarif_lembur(rate: float) -> float:
    return round(rate / 8 * 1.5 / 500) * 500


for w in WORKERS:
    w["tarifLembur"] = tarif_lembur(w["rate"])

ACTIVE = [w for w in WORKERS if w["aktif"]]
COUNTS = {k: sum(1 for w in WORKERS if w["status"] == k) for k in ["H", "I", "S", "A", None]}
TODAY_HADIR = [w for w in WORKERS if w["status"] == "H"]
TODAY_LEMBUR = sum(w["lembur"] for w in TODAY_HADIR)
TODAY_LEMBUR_RP = sum(w["lembur"] * w["tarifLembur"] for w in TODAY_HADIR)
TODAY_UPAH = sum(w["rate"] for w in TODAY_HADIR) + TODAY_LEMBUR_RP
AVG_RATE = sum(w["rate"] for w in ACTIVE) / len(ACTIVE)
EST_BULAN = sum(w["rate"] * w["hadir15"] + w["tarifLembur"] * w["lembur15"] for w in ACTIVE)

PAYROLL = []
for w in WORKERS:
    gross = w["rate"] * w["hadir15"] + w["tarifLembur"] * w["lembur15"] + w["bonus"]
    net = gross - w["kasbon"] - w["potongan"]
    PAYROLL.append({**w, "gross": gross, "net": net})

TOTAL_GROSS = sum(p["gross"] for p in PAYROLL)
TOTAL_LEMBUR = sum(p["tarifLembur"] * p["lembur15"] for p in PAYROLL)
TOTAL_KASBON = sum(p["kasbon"] for p in PAYROLL)
TOTAL_BONUS = sum(p["bonus"] for p in PAYROLL)
TOTAL_POTONGAN = sum(p["potongan"] for p in PAYROLL)
TOTAL_NET = sum(p["net"] for p in PAYROLL)

TRANSACTIONS = [
    {"tipe": "Bonus",    "nama": "Joko Prasetyo",  "nominal": 150000, "ket": "Bonus lembur proyek"},
    {"tipe": "Kasbon",   "nama": "Dedi Kurniawan", "nominal": 100000, "ket": "Kasbon harian"},
    {"tipe": "Potongan", "nama": "Iwan Setiadi",   "nominal": 25000,  "ket": "Potongan alat"},
    {"tipe": "Bonus",    "nama": "H. Suryana",     "nominal": 200000, "ket": "Insentif pengawas"},
]
TRX_TOTAL = {
    "Bonus": sum(t["nominal"] for t in TRANSACTIONS if t["tipe"] == "Bonus"),
    "Potongan": sum(t["nominal"] for t in TRANSACTIONS if t["tipe"] == "Potongan"),
    "Kasbon": sum(t["nominal"] for t in TRANSACTIONS if t["tipe"] == "Kasbon"),
}

HISTORY = [
    {"periode": "01 — 15 Okt 2026", "total": 24180000, "kru": 12, "tag": "Final", "tone": "ok"},
    {"periode": "16 — 31 Okt 2026", "total": 26940000, "kru": 12, "tag": "Final", "tone": "ok"},
    {"periode": "01 — 15 Sep 2026", "total": 22650000, "kru": 11, "tag": "Final", "tone": "ok"},
    {"periode": "16 — 31 Sep 2026", "total": 23100000, "kru": 11, "tag": "Arsip", "tone": "neutral"},
]
HIST_TOTAL = sum(h["total"] for h in HISTORY)

MENU = [
    ("slip", "file", "Slip Gaji PDF"),
    ("backup", "database", "Backup .isar"),
    ("restore", "upload", "Impor Data"),
    ("theme", "palette", "Tema"),
    ("profile", "user", "Profil"),
    ("guide", "info", "Panduan"),
    ("about", "shield", "Tentang"),
    ("offline", "clock", "Mode Offline"),
]

PARITY = [
    ("Onboarding 6 fitur", "Lainnya › Panduan"),
    ("Dashboard 5 statistik", "Hari Ini › 6 tile"),
    ("Estimasi pengeluaran", "Hari Ini › kartu estimasi"),
    ("Karyawan: CRUD + 5 stat", "Data › list + form sheet"),
    ("Absensi: 4 status + massal", "Absensi › tab Absensi"),
    ("Lembur: input + biaya", "Absensi › tab Lembur"),
    ("Bonus / potongan / kasbon", "Absensi › tab Bonus"),
    ("Hitung gaji kolektif", "Gaji › Proses"),
    ("Simpan & bayar", "Gaji › sheet konfirmasi"),
    ("Riwayat + hapus + PDF", "Gaji › Riwayat"),
    ("Slip gaji PDF", "Lainnya › Slip Gaji PDF"),
    ("Backup / impor .isar", "Lainnya › Backup & Impor"),
    ("Tema terang/gelap/sistem", "Lainnya › Tema"),
    ("Profil & tentang", "Lainnya › Profil & Tentang"),
]

DATES = [("Sen", "10"), ("Sel", "11"), ("Rab", "12"), ("Kam", "13"), ("Jum", "14"), ("Sab", "15"), ("Min", "16")]


def avatar(name: str) -> str:
    parts = [p for p in name.replace("H. ", "").split() if p]
    return (parts[0][0] + parts[-1][0]).upper() if len(parts) > 1 else name[:2].upper()


# ── Komponen HTML ────────────────────────────────────────────────────────────
def stat(label: str, value: str, unit: str = "", accent: bool = False, ic: str = "") -> str:
    cls = "stat accent" if accent else "stat"
    u = f"<small>{unit}</small>" if unit else ""
    ico = icon(ic, "ic") if ic else ""
    return f'<div class="{cls}">{ico}<p class="k">{label}</p><p class="v">{value} {u}</p></div>'


def shead(title: str, ic: str = "", right: str = "") -> str:
    ico = icon(ic, "sec-ic") if ic else ""
    return f'<div class="section-head"><h3>{ico}{title}</h3>{right}</div>'


def search_box(placeholder: str, aria: str) -> str:
    return f'<div class="search-wrap">{icon("search", "search-ic")}<input class="search" type="search" placeholder="{placeholder}" aria-label="{aria}"></div>'


def pill(w: dict) -> str:
    meta = STATUS_META[w["status"]]
    return f'<span class="pill {meta["class"]}" data-pill="{w["id"]}">{meta["label"]}</span>'


def crew_row(w: dict) -> str:
    return f"""
    <button class="crew-row" data-id="{w['id']}" aria-label="Atur {w['nama']}">
      <span class="avatar">{avatar(w['nama'])}</span>
      <span class="crew-main">
        <span class="crew-name">{w['nama']}</span>
        <span class="crew-meta">{w['jabatan']} · {rp(w['rate'])}/hari</span>
      </span>
      {pill(w)}
      {icon('chev', 'chev')}
    </button>"""


def pay_row(p: dict) -> str:
    return f"""
    <div class="pay-row">
      <span class="avatar sm">{avatar(p['nama'])}</span>
      <span class="crew-main">
        <span class="crew-name">{p['nama']}</span>
        <span class="crew-meta">{p['hadir15']} hadir · {p['lembur15']:g} jam · kasbon {rp(p['kasbon'])}</span>
      </span>
      <span class="pay-net">{rp(p['net'])}</span>
    </div>"""


def data_row(w: dict) -> str:
    kasbon = f"Kasbon {rp(w['kasbon'])}" if w["kasbon"] else "Tanpa kasbon"
    return f"""
    <button class="crew-row" data-id="{w['id']}" aria-label="Kelola {w['nama']}">
      <span class="avatar">{avatar(w['nama'])}</span>
      <span class="crew-main">
        <span class="crew-name">{w['nama']}</span>
        <span class="crew-meta">{w['jabatan']} · {kasbon}</span>
      </span>
      <span class="pay-net sm">{rp(w['rate'])}</span>
      {icon('chev', 'chev')}
    </button>"""


def lembur_row(w: dict) -> str:
    return f"""
    <div class="crew-row static" data-lembur="{w['id']}">
      <span class="avatar">{avatar(w['nama'])}</span>
      <span class="crew-main">
        <span class="crew-name">{w['nama']}</span>
        <span class="crew-meta">{rp(w['tarifLembur'])}/jam</span>
      </span>
      <span class="stepper">
        <button type="button" data-lmb="-1" aria-label="Kurangi lembur {w['nama']}">−</button>
        <b data-lmbval="{w['id']}">{num(w['lembur'])}</b>
        <button type="button" data-lmb="1" aria-label="Tambah lembur {w['nama']}">+</button>
      </span>
    </div>"""


def trx_row(t: dict) -> str:
    cls = {"Bonus": "ok", "Potongan": "bad", "Kasbon": "warn"}[t["tipe"]]
    sign = "+" if t["tipe"] == "Bonus" else "−"
    return f"""
    <div class="crew-row static">
      <span class="avatar sm">{avatar(t['nama'])}</span>
      <span class="crew-main">
        <span class="crew-name">{t['nama']}</span>
        <span class="crew-meta">{t['ket']}</span>
      </span>
      <span class="trx-amt {cls}">{sign} {rp(t['nominal'])}</span>
    </div>"""


def hist_row(h: dict) -> str:
    return f"""
    <button class="run-row" type="button">
      <span class="run-icon">{icon('receipt')}</span>
      <span class="crew-main">
        <span class="crew-name">{h['periode']}</span>
        <span class="crew-meta">{h['kru']} kru · {rp(h['total'])}</span>
      </span>
      <span class="pill {h['tone']}">{h['tag']}</span>
      {icon('chev', 'chev')}
    </button>"""


def menu_item(key: str, ic: str, label: str) -> str:
    return f'<button class="menu-item" type="button" data-menu="{key}">{icon(ic)}<span>{label}</span></button>'


# ── CSS ──────────────────────────────────────────────────────────────────────
CSS = r"""
:root{
  --paper:#F6F3EC; --card:#FFFFFF; --card-2:#FBF9F4;
  --ink:#101826; --ink-2:#2A3444; --muted:#6E6656;
  --line:#E3DCCC; --line-strong:#CFC5B0;
  --accent:#E3A72F; --accent-soft:#FBEFD2; --accent-ink:#241A04;
  --ok:#1F7A5A; --ok-soft:#DFF1E9;
  --warn:#A9701A; --warn-soft:#FBEBD2;
  --bad:#B23A2E; --bad-soft:#F7E1DE;
  --info:#2C5C8A; --info-soft:#E1ECF7;
  --shadow:0 1px 0 rgba(16,24,38,.04), 0 18px 40px -18px rgba(16,24,38,.35);
  --r:14px;
  --panel:#101826; --on-panel:#F6F3EC;
  --btn-bg:var(--ink); --btn-fg:var(--paper); --btn-arrow:var(--accent);
  --nav-bg:var(--ink); --nav-fg:var(--paper);
}
body.dark{
  --paper:#0D131C; --card:#151D28; --card-2:#111823;
  --ink:#EFE9DC; --ink-2:#C9D0DB; --muted:#98A1B0;
  --line:#28323F; --line-strong:#3A4553;
  --accent:#F2B93B; --accent-soft:#3A2E12; --accent-ink:#1A1204;
  --ok:#57C79B; --ok-soft:#122E25;
  --warn:#E0A64B; --warn-soft:#33270F;
  --bad:#EE7A6C; --bad-soft:#361714;
  --info:#8FBCEA; --info-soft:#132538;
  --shadow:0 1px 0 rgba(0,0,0,.4), 0 24px 60px -24px rgba(0,0,0,.8);
  --panel:#151D28; --on-panel:#EFE9DC;
  --btn-bg:var(--accent); --btn-fg:var(--accent-ink); --btn-arrow:var(--accent-ink);
  --nav-bg:var(--accent); --nav-fg:var(--accent-ink);
}
*{box-sizing:border-box}
html,body{margin:0;padding:0}
body{
  font-family:"IBM Plex Sans",system-ui,-apple-system,"Segoe UI",sans-serif;
  background:
    radial-gradient(1200px 600px at 15% -10%, rgba(227,167,47,.14), transparent 60%),
    radial-gradient(900px 500px at 90% 0%, rgba(44,92,138,.16), transparent 55%),
    #0A0E14;
  color:#E9E4D8; min-height:100vh;
}
h1,h2,h3,h4{font-family:"Space Grotesk","IBM Plex Sans",sans-serif;margin:0}
button{font:inherit;color:inherit;background:none;border:0;cursor:pointer}
.board-head{
  max-width:1320px;margin:0 auto;padding:40px 32px 8px;
  display:flex;justify-content:space-between;align-items:flex-end;gap:24px;flex-wrap:wrap;
}
.eyebrow{font:600 11px/1 "IBM Plex Mono",monospace;letter-spacing:.18em;color:var(--accent);margin:0 0 10px}
.board-head h1{font-size:38px;line-height:1.05;letter-spacing:-.02em;color:#F6F1E4}
.board-head h1 span{display:block;font-size:15px;letter-spacing:.16em;text-transform:uppercase;color:#8E97A6;margin-top:8px;font-weight:500}
.lede{margin:10px 0 0;color:#A7AFBC;font-size:14px}
.head-actions{display:flex;gap:10px;align-items:center}
.ghost{border:1px solid #2C3644;border-radius:999px;padding:10px 16px;color:#D7DEE8;font-size:13px;transition:border-color .18s,background .18s}
.ghost:hover{border-color:#4A5768;background:#141B25}
.chip{border-radius:999px;padding:9px 14px;font:600 11px/1 "IBM Plex Mono",monospace;letter-spacing:.1em;background:rgba(227,167,47,.14);color:var(--accent);border:1px solid rgba(227,167,47,.3)}
.board{max-width:1320px;margin:0 auto;padding:24px 32px 64px;display:grid;grid-template-columns:minmax(0,430px) minmax(0,1fr);gap:48px;align-items:start}
.stage{display:flex;flex-direction:column;align-items:center;gap:14px;position:sticky;top:24px}
.stage-caption{font-size:12px;color:#8B94A2;text-align:center;max-width:360px;line-height:1.5}
.device{
  width:390px;height:844px;border-radius:48px;position:relative;overflow:hidden;
  background:var(--paper);color:var(--ink);
  border:1px solid rgba(255,255,255,.16);
  box-shadow:0 0 0 8px #1A212B,0 0 0 10px #10161E,0 50px 100px -30px rgba(0,0,0,.9);
  transition:background .25s,color .25s;
}
.statusbar{height:44px;display:flex;align-items:center;justify-content:space-between;padding:0 26px;font:600 12px/1 "IBM Plex Mono",monospace;color:var(--ink)}
.statusbar .dots{display:flex;gap:5px;align-items:center}
.statusbar .dots i{display:block;width:5px;height:5px;border-radius:50%;background:currentColor;opacity:.75}
.status-ic{width:12px;height:12px;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;opacity:.8}
.screens{position:absolute;inset:44px 0 0 0}
.screen{position:absolute;inset:0;overflow-y:auto;padding:4px 18px 210px;opacity:0;transform:translateY(8px);pointer-events:none;transition:opacity .18s ease,transform .18s ease;scrollbar-width:none}
.screen::-webkit-scrollbar{display:none}
.screen.active{opacity:1;transform:none;pointer-events:auto}
.app-head{display:flex;align-items:flex-start;justify-content:space-between;gap:10px;padding:6px 0 12px}
.kicker{font:600 10px/1 "IBM Plex Mono",monospace;letter-spacing:.16em;text-transform:uppercase;color:var(--muted);margin:0 0 6px}
.app-head h2{font-size:26px;letter-spacing:-.02em;line-height:1}
.head-tools{display:flex;gap:8px;align-items:center}
.icon-btn{width:40px;height:40px;border-radius:12px;border:1px solid var(--line);background:var(--card);display:grid;place-items:center;flex:none;transition:border-color .16s,background .16s}
.icon-btn:hover{border-color:var(--line-strong)}
.icon-btn svg{width:19px;height:19px;fill:none;stroke:var(--ink);stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round}
.avatar{width:40px;height:40px;border-radius:12px;display:grid;place-items:center;background:var(--accent-soft);color:var(--accent-ink);font:700 13px/1 "Space Grotesk",sans-serif;flex:none;border:1px solid color-mix(in srgb,var(--accent) 35%,transparent)}
.avatar.sm{width:34px;height:34px;border-radius:10px;font-size:11px}
.datestrip{display:grid;grid-template-columns:repeat(7,1fr);gap:4px;margin:2px 0 14px}
.date{height:56px;border-radius:11px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:4px;color:var(--muted);border:1px solid transparent;transition:background .16s,border-color .16s,color .16s}
.date b{font:600 9px/1 "IBM Plex Mono",monospace;letter-spacing:.06em;text-transform:uppercase}
.date span{font:600 16px/1 "Space Grotesk",sans-serif;color:var(--ink)}
.date.active{background:var(--accent);color:var(--accent-ink);border-color:var(--accent)}
.date.active span{color:var(--accent-ink)}
.date:hover{border-color:var(--line-strong)}
.hero-card{position:relative;background:var(--panel);color:var(--on-panel);border-radius:20px;padding:18px;overflow:hidden}
.hero-card:after{content:"";position:absolute;right:-40px;top:-40px;width:150px;height:150px;border-radius:50%;background:radial-gradient(circle,rgba(227,167,47,.35),transparent 65%)}
.hero-label{margin:0 0 7px;font:600 10px/1 "IBM Plex Mono",monospace;letter-spacing:.16em;text-transform:uppercase;color:color-mix(in srgb,var(--on-panel) 62%,transparent)}
.hero-value{margin:0;font:600 36px/1 "IBM Plex Mono",monospace;letter-spacing:-.03em;color:var(--accent);font-variant-numeric:tabular-nums}
.hero-meta{display:flex;gap:12px;margin:11px 0 14px;font-size:11px;color:color-mix(in srgb,var(--on-panel) 74%,transparent);flex-wrap:wrap}
.hero-meta span{display:flex;align-items:center;gap:5px}
.hero-meta span:before{content:"";width:4px;height:4px;border-radius:50%;background:var(--accent)}
.bar{display:flex;height:8px;border-radius:999px;overflow:hidden;background:rgba(255,255,255,.12);gap:2px}
.bar i{display:block;height:100%}
.legend{display:flex;gap:10px;margin-top:9px;font-size:10px;color:color-mix(in srgb,var(--on-panel) 74%,transparent);flex-wrap:wrap}
.legend b{color:var(--on-panel);font-family:"IBM Plex Mono",monospace}
.legend span{display:inline-flex;align-items:center;gap:4px}
.legend i{width:7px;height:7px;border-radius:2px;display:inline-block}
.stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:7px;margin-top:12px}
.stat{position:relative;background:var(--card);border:1px solid var(--line);border-radius:12px;padding:10px 9px;min-height:64px}
.stat .ic{position:absolute;top:8px;right:8px;width:14px;height:14px;fill:none;stroke:var(--muted);stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;opacity:.85}
.stat.accent .ic{stroke:var(--accent-ink);opacity:.9}
.stat .k{font:600 8.5px/1.25 "IBM Plex Mono",monospace;letter-spacing:.08em;text-transform:uppercase;color:var(--muted);margin:0;padding-right:14px}
.stat .v{font:600 15px/1 "IBM Plex Mono",monospace;margin:8px 0 0;color:var(--ink);font-variant-numeric:tabular-nums;white-space:nowrap}
.stat .v small{font-size:8.5px;color:var(--muted);font-weight:500}
.stat.accent{background:var(--accent-soft);border-color:color-mix(in srgb,var(--accent) 45%,transparent)}
.section-head{display:flex;align-items:center;justify-content:space-between;gap:10px;margin:18px 0 9px}
.section-head h3{font-size:14.5px;letter-spacing:-.01em;display:flex;align-items:center;gap:6px}
.sec-ic{width:14px;height:14px;fill:none;stroke:var(--muted);stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex:none}
.section-head .count{font:600 9.5px/1 "IBM Plex Mono",monospace;letter-spacing:.08em;color:var(--muted)}
.link{display:inline-flex;align-items:center;gap:4px;font-size:11px;font-weight:600;color:var(--ink-2);border-bottom:1px solid var(--line-strong);padding-bottom:1px}
.link-ic{width:11px;height:11px;fill:none;stroke:currentColor;stroke-width:2.2;stroke-linecap:round;stroke-linejoin:round}
.btn-ic{width:14px;height:14px;fill:none;stroke:currentColor;stroke-width:1.9;stroke-linecap:round;stroke-linejoin:round;flex:none}
.link:hover{color:var(--accent-ink);border-color:var(--accent)}
.crew-list{display:flex;flex-direction:column;gap:7px}
.crew-row{display:flex;align-items:center;gap:11px;width:100%;text-align:left;background:var(--card);border:1px solid var(--line);border-radius:var(--r);padding:10px 11px;min-height:62px;transition:border-color .16s,transform .12s,background .16s}
.crew-row.static{cursor:default}
.crew-row:hover{border-color:var(--line-strong)}
.crew-row:active{transform:scale(.995)}
.crew-row:focus-visible{outline:2px solid var(--accent);outline-offset:2px}
.crew-main{flex:1;min-width:0;display:flex;flex-direction:column;gap:3px}
.crew-name{font-weight:600;font-size:13px;letter-spacing:-.01em;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.crew-meta{font-size:10.5px;color:var(--muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.chev{width:15px;height:15px;fill:none;stroke:var(--line-strong);stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex:none}
.pill{display:inline-flex;align-items:center;gap:5px;font:600 9.5px/1 "IBM Plex Mono",monospace;letter-spacing:.05em;text-transform:uppercase;padding:7px 8px;border-radius:999px;flex:none}
.pill:before{content:"";width:5px;height:5px;border-radius:50%;background:currentColor;opacity:.85}
.pill.ok{background:var(--ok-soft);color:var(--ok)}
.pill.info{background:var(--info-soft);color:var(--info)}
.pill.warn{background:var(--warn-soft);color:var(--warn)}
.pill.bad{background:var(--bad-soft);color:var(--bad)}
.pill.neutral{background:var(--card-2);color:var(--muted);border:1px solid var(--line)}
.primary{width:auto;height:46px;padding:0 20px;border-radius:999px;background:var(--btn-bg);color:var(--btn-fg);font-weight:600;font-size:12.5px;display:inline-flex;align-items:center;justify-content:center;gap:7px;transition:transform .12s,opacity .16s}
.primary:hover{opacity:.94}
.primary:active{transform:scale(.99)}
.primary:focus-visible{outline:2px solid var(--accent);outline-offset:2px}
.primary .arrow{width:17px;height:17px;fill:none;stroke:var(--btn-arrow);stroke-width:2.2;stroke-linecap:round;stroke-linejoin:round}
.primary.small{height:44px;font-size:12px}
.secondary{width:auto;height:40px;padding:0 14px;border-radius:999px;border:1px solid var(--line-strong);background:var(--card);color:var(--ink);font-weight:600;font-size:12px;display:inline-flex;align-items:center;justify-content:center;gap:5px}
.secondary:hover{border-color:var(--ink-2)}
.screen-cta{position:absolute;left:0;right:0;bottom:82px;z-index:12;display:none;justify-content:center;padding:26px 14px 6px;background:var(--paper);pointer-events:none}
.screen-cta:before{content:"";position:absolute;left:0;right:0;top:-26px;height:26px;background:linear-gradient(180deg,transparent,var(--paper));pointer-events:none}
.screen-cta.show{display:flex}
.screen-cta .primary{box-shadow:0 18px 34px -16px rgba(16,24,38,.6);pointer-events:auto}
.period{display:flex;align-items:center;justify-content:space-between;gap:10px;background:var(--card);border:1px solid var(--line);border-radius:12px;padding:10px 12px;margin:2px 0 12px}
.period b{font:600 11.5px/1 "IBM Plex Mono",monospace}
.period small{display:block;color:var(--muted);font-size:10px;margin-top:4px}
.period .dates{display:flex;align-items:center;gap:8px}
.period .dates span{font:600 11px/1 "IBM Plex Mono",monospace;color:var(--ink)}
.period .dates i{color:var(--muted);font-style:normal}
.ico-sm{width:30px;height:30px;border-radius:9px;background:var(--card-2);border:1px solid var(--line);display:grid;place-items:center;flex:none}
.ico-sm svg{width:15px;height:15px;fill:none;stroke:var(--muted);stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.total-card{background:var(--card);border:1px solid var(--line);border-radius:16px;padding:15px;box-shadow:var(--shadow)}
.total-row{display:flex;justify-content:space-between;align-items:baseline;padding:6px 0;font-size:12px;color:var(--muted)}
.total-row b{font-family:"IBM Plex Mono",monospace;color:var(--ink);font-weight:600;font-variant-numeric:tabular-nums}
.total-row.grand{border-top:1px dashed var(--line-strong);margin-top:7px;padding-top:10px;color:var(--ink);font-weight:600}
.total-row.grand b{font-size:18px;color:var(--accent-ink);background:var(--accent-soft);padding:5px 8px;border-radius:7px}
body.dark .total-row.grand b{color:var(--accent);background:transparent;padding:5px 0}
.pay-row{display:flex;align-items:center;gap:11px;padding:10px 11px;background:var(--card);border:1px solid var(--line);border-radius:12px}
.pay-list{display:flex;flex-direction:column;gap:7px;margin-top:8px}
.pay-net{font:600 12px/1 "IBM Plex Mono",monospace;font-variant-numeric:tabular-nums;color:var(--ink);white-space:nowrap}
.pay-net.sm{font-size:11px}
.run-row{display:flex;align-items:center;gap:11px;width:100%;text-align:left;background:var(--card);border:1px solid var(--line);border-radius:13px;padding:12px 11px;margin-bottom:7px}
.run-row:hover{border-color:var(--line-strong)}
.run-icon{width:38px;height:38px;border-radius:11px;background:var(--card-2);border:1px solid var(--line);display:grid;place-items:center;flex:none}
.run-icon svg{width:17px;height:17px;fill:none;stroke:var(--ink-2);stroke-width:1.7;stroke-linejoin:round}
.search{width:100%;height:42px;border-radius:11px;border:1px solid var(--line);background:var(--card);padding:0 13px 0 34px;font:400 12.5px/1 "IBM Plex Sans",sans-serif;color:var(--ink);margin-bottom:10px}
.search-wrap{position:relative}
.search-ic{position:absolute;left:11px;top:14px;width:15px;height:15px;fill:none;stroke:var(--muted);stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;pointer-events:none}
.search::placeholder{color:var(--muted)}
.search:focus{outline:2px solid var(--accent);outline-offset:1px;border-color:transparent}
.chips{display:flex;gap:7px;margin-bottom:12px;overflow-x:auto;scrollbar-width:none}
.chips::-webkit-scrollbar{display:none}
.chip-btn{padding:7px 11px;border-radius:999px;border:1px solid var(--line);font-size:11px;font-weight:600;color:var(--muted);background:var(--card);white-space:nowrap}
.chip-btn.active{background:var(--ink);color:var(--paper);border-color:var(--ink)}
body.dark .chip-btn.active{color:var(--paper)}
.tabbar{display:grid;grid-template-columns:repeat(3,1fr);gap:4px;background:var(--card-2);border:1px solid var(--line);border-radius:12px;padding:4px;margin:2px 0 12px}
.tabbar.two{grid-template-columns:repeat(2,1fr)}
.tabbar button{height:36px;border-radius:9px;font-size:11.5px;font-weight:600;color:var(--muted);display:flex;align-items:center;justify-content:center;gap:5px}
.tabbar button svg{width:13px;height:13px;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.tabbar button.active{background:var(--card);color:var(--ink);box-shadow:0 1px 2px rgba(0,0,0,.08)}
.panel{display:none}
.panel.active{display:block}
.stepper{display:flex;align-items:center;gap:5px}
.stepper button{width:30px;height:30px;border-radius:8px;border:1px solid var(--line);background:var(--card);font-size:15px;line-height:1;color:var(--ink-2)}
.stepper button:hover{border-color:var(--line-strong)}
.stepper b{font:600 12px/1 "IBM Plex Mono",monospace;min-width:20px;text-align:center;font-variant-numeric:tabular-nums}
.trx-amt{font:600 11.5px/1 "IBM Plex Mono",monospace;white-space:nowrap;font-variant-numeric:tabular-nums}
.trx-amt.ok{color:var(--ok)}
.trx-amt.bad{color:var(--bad)}
.trx-amt.warn{color:var(--warn)}
.menu-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:7px}
.menu-item{background:var(--card);border:1px solid var(--line);border-radius:13px;padding:12px 5px;display:flex;flex-direction:column;align-items:center;gap:7px;font-size:9.5px;font-weight:600;text-align:center;color:var(--ink-2);line-height:1.2}
.menu-item svg{width:20px;height:20px;fill:none;stroke:var(--ink);stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round}
.menu-item:hover{border-color:var(--line-strong)}
.menu-item:active{transform:scale(.98)}
.profile-card{display:flex;align-items:center;gap:12px;background:var(--panel);color:var(--on-panel);border-radius:16px;padding:14px;margin-bottom:14px}
.profile-card .avatar{width:46px;height:46px;border-radius:14px;background:var(--accent);color:var(--accent-ink)}
.profile-card h3{font-size:15px}
.profile-card p{margin:3px 0 0;font-size:10.5px;color:color-mix(in srgb,var(--on-panel) 70%,transparent)}
.profile-card .badge{margin-left:auto;font:600 9px/1 "IBM Plex Mono",monospace;letter-spacing:.08em;padding:7px 9px;border-radius:999px;background:rgba(227,167,47,.16);color:var(--accent);border:1px solid rgba(227,167,47,.3)}
.setting-row{display:flex;align-items:center;gap:11px;width:100%;text-align:left;padding:12px 2px;border-bottom:1px solid var(--line)}
.setting-row:last-child{border-bottom:0}
.setting-row .ico{width:34px;height:34px;border-radius:10px;background:var(--card-2);border:1px solid var(--line);display:grid;place-items:center;flex:none}
.setting-row .ico svg{width:17px;height:17px;fill:none;stroke:var(--ink-2);stroke-width:1.7;stroke-linecap:round;stroke-linejoin:round}
.setting-row .txt{flex:1;min-width:0}
.setting-row .txt b{display:block;font-size:12.5px;font-weight:600}
.setting-row .txt span{display:block;font-size:10.5px;color:var(--muted);margin-top:2px}
.seg3{display:grid;grid-template-columns:repeat(3,1fr);gap:4px;background:var(--card-2);border:1px solid var(--line);border-radius:10px;padding:3px;width:172px}
.seg3 button{height:30px;border-radius:7px;font-size:10.5px;font-weight:600;color:var(--muted)}
.seg3 button.active{background:var(--ink);color:var(--paper);box-shadow:none}
.bottomnav{position:absolute;left:14px;right:14px;bottom:14px;height:68px;padding:6px;background:color-mix(in srgb,var(--card) 82%,transparent);backdrop-filter:blur(18px) saturate(1.15);-webkit-backdrop-filter:blur(18px) saturate(1.15);border:1px solid var(--line);border-radius:22px;box-shadow:0 20px 40px -22px rgba(16,24,38,.55),0 2px 6px rgba(16,24,38,.06);display:grid;grid-template-columns:repeat(5,1fr);gap:2px;z-index:16}
body.dark .bottomnav{box-shadow:0 22px 44px -22px rgba(0,0,0,.9),0 2px 6px rgba(0,0,0,.4)}
.nav-item{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:3px;color:var(--muted);font-size:8.5px;font-weight:600;border-radius:16px;min-height:54px;transition:background .16s,color .16s}
.nav-item svg{width:19px;height:19px;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.nav-item.active{background:var(--nav-bg);color:var(--nav-fg)}
.nav-item.active:after{display:none}
.nav-item:hover{color:var(--ink-2)}
.nav-item.active:hover{color:var(--nav-fg)}
.backdrop{position:absolute;inset:0;background:rgba(10,14,20,.5);opacity:0;pointer-events:none;transition:opacity .2s;z-index:20}
.backdrop.show{opacity:1;pointer-events:auto}
.sheet{position:absolute;left:0;right:0;bottom:0;z-index:21;background:var(--card);border-radius:24px 24px 0 0;padding:10px 18px 24px;transform:translateY(102%);transition:transform .24s cubic-bezier(.2,.8,.2,1);max-height:90%;overflow-y:auto;border-top:1px solid var(--line)}
.sheet.open{transform:none}
.grab{width:38px;height:4px;border-radius:2px;background:var(--line-strong);margin:0 auto 13px}
.sheet-head{display:flex;align-items:center;gap:11px;margin-bottom:15px}
.sheet-head h3{font-size:16px;letter-spacing:-.02em}
.sheet-head p{margin:3px 0 0;font-size:11px;color:var(--muted)}
.sheet-close{margin-left:auto;width:34px;height:34px;border-radius:10px;background:var(--card-2);border:1px solid var(--line);font-size:18px;line-height:1;color:var(--muted)}
.sheet-close:hover{color:var(--ink)}
.field-label{font:600 9px/1 "IBM Plex Mono",monospace;letter-spacing:.13em;text-transform:uppercase;color:var(--muted);margin:0 0 7px}
.sheet .primary{width:auto;min-width:190px;margin:0 auto;display:flex}
.sheet .secondary{display:flex;margin:0 auto}
.seg{display:grid;grid-template-columns:repeat(4,1fr);gap:5px;margin-bottom:15px}
.seg button{display:flex;align-items:center;justify-content:center;gap:5px}
.seg button svg{width:13px;height:13px;fill:none;stroke:currentColor;stroke-width:1.9;stroke-linecap:round;stroke-linejoin:round}
.seg button{height:46px;border-radius:11px;border:1px solid var(--line);font-size:11.5px;font-weight:600;color:var(--muted);background:var(--card);transition:background .14s,color .14s,border-color .14s}
.seg button.sel{color:#fff;border-color:transparent}
.seg button.sel[data-status="H"]{background:var(--ok)}
.seg button.sel[data-status="I"]{background:var(--info)}
.seg button.sel[data-status="S"]{background:var(--warn)}
.seg button.sel[data-status="A"]{background:var(--bad)}
.duo{display:grid;grid-template-columns:1fr 1fr;gap:9px;margin-bottom:14px}
.field{background:var(--card-2);border:1px solid var(--line);border-radius:13px;padding:9px 11px}
.field .val{display:flex;align-items:center;justify-content:space-between;gap:6px;margin-top:5px}
.field .val b{font:600 14px/1 "IBM Plex Mono",monospace;font-variant-numeric:tabular-nums}
.sheet-total{display:flex;align-items:center;justify-content:space-between;padding:13px 0 15px;border-top:1px dashed var(--line-strong)}
.sheet-total span{font-size:11.5px;color:var(--muted)}
.sheet-total b{font:600 20px/1 "IBM Plex Mono",monospace;color:var(--ink);font-variant-numeric:tabular-nums}
.toast{position:absolute;left:50%;bottom:168px;transform:translate(-50%,12px);z-index:30;background:var(--ink);color:var(--paper);border-radius:999px;padding:10px 15px;font-size:11.5px;font-weight:600;opacity:0;pointer-events:none;transition:opacity .2s,transform .2s;white-space:nowrap;max-width:330px;overflow:hidden;text-overflow:ellipsis}
.toast.show{opacity:1;transform:translate(-50%,0)}
.spec{display:flex;flex-direction:column;gap:16px;padding-top:4px}
.spec-card{background:#111823;border:1px solid #232D3A;border-radius:18px;padding:20px}
.spec-card h3{font-size:14px;letter-spacing:.02em;color:#F1ECDF;margin-bottom:12px}
.spec-card p{font-size:12.5px;line-height:1.65;color:#9AA3B1;margin:0}
.spec-list{display:flex;flex-direction:column;gap:10px;margin:0;padding:0;list-style:none}
.spec-list li{display:grid;grid-template-columns:22px 1fr;gap:9px;font-size:12px;line-height:1.55;color:#AEB6C3}
.spec-list b{color:#EDE7DA;font-weight:600}
.num{font:600 10px/20px "IBM Plex Mono",monospace;color:var(--accent);text-align:center;border:1px solid rgba(227,167,47,.3);border-radius:7px;height:20px}
.swatches{display:grid;grid-template-columns:repeat(4,1fr);gap:7px}
.sw{border-radius:9px;border:1px solid #2A3442;overflow:hidden}
.sw i{display:block;height:30px}
.sw span{display:block;padding:5px 6px;font:500 9px/1.3 "IBM Plex Mono",monospace;color:#98A1B0;background:#0E151E}
.type-row{display:flex;justify-content:space-between;align-items:baseline;padding:8px 0;border-bottom:1px solid #232D3A;font-size:12px;color:#98A1B0}
.type-row:last-child{border:0}
.type-row b{color:#EDE7DA;font-family:"Space Grotesk",sans-serif}
.type-row .mono{font-family:"IBM Plex Mono",monospace;color:var(--accent);font-size:10.5px}
.flow{display:flex;gap:5px;align-items:center;flex-wrap:wrap}
.flow span{font:600 10px/1 "IBM Plex Mono",monospace;letter-spacing:.05em;padding:7px 9px;border-radius:7px;background:#182130;color:#C9D2DF;border:1px solid #28323F}
.flow i{color:var(--accent);font-style:normal;font-size:11px}
table.parity{width:100%;border-collapse:collapse;font-size:11.5px}
table.parity th{text-align:left;font:600 9px/1 "IBM Plex Mono",monospace;letter-spacing:.1em;text-transform:uppercase;color:#7F8997;padding:0 0 8px;border-bottom:1px solid #232D3A}
table.parity td{padding:7px 0;border-bottom:1px solid #1C2532;color:#AEB6C3;vertical-align:top}
table.parity td:first-child{color:#EDE7DA;width:52%}
table.parity tr:last-child td{border-bottom:0}
@media (max-width:1080px){.board{grid-template-columns:1fr;gap:32px}.stage{position:static}.spec{max-width:720px;margin:0 auto;width:100%}}
@media (max-width:520px){.board-head{padding:28px 18px 0}.board{padding:16px 12px 48px}.device{transform:scale(.86);transform-origin:top center;margin-bottom:-110px}}
@media (prefers-reduced-motion:reduce){*{transition:none!important;animation:none!important}}
"""


# ── Layar ────────────────────────────────────────────────────────────────────
def screen_hari() -> str:
    dates = "".join(
        f'<button class="date{" active" if i == 2 else ""}" type="button"><b>{d}</b><span>{n}</span></button>'
        for i, (d, n) in enumerate(DATES)
    )
    pending = [w for w in WORKERS if w["status"] is None]
    pct = {k: round(COUNTS[k] / len(WORKERS) * 100) for k in ["H", "I", "S", "A"]}
    return f"""
    <section class="screen active" id="screen-hari" aria-label="Hari Ini">
      <div class="app-head">
        <div><p class="kicker">Selasa · 12 November</p><h2>Hari Ini</h2></div>
        <div class="head-tools">
          <button class="icon-btn" type="button" id="openMenu" aria-label="Buka semua menu">{icon('grid')}</button>
          <button class="avatar" type="button" id="openProfile" aria-label="Profil">SR</button>
        </div>
      </div>
      <div class="datestrip" role="group" aria-label="Pilih tanggal">{dates}</div>

      <div class="hero-card">
        <p class="hero-label">Upah hari ini</p>
        <p class="hero-value" id="heroValue">{rp(TODAY_UPAH)}</p>
        <div class="hero-meta">
          <span id="heroCrew">{COUNTS['H']} kru hadir</span>
          <span id="heroLembur">{num(TODAY_LEMBUR)} jam lembur</span>
          <span>{COUNTS[None]} belum ditandai</span>
        </div>
        <div class="bar" aria-hidden="true">
          <i class="h" style="width:{pct['H']}%"></i><i class="i" style="width:{pct['I']}%"></i>
          <i class="s" style="width:{pct['S']}%"></i><i class="a" style="width:{pct['A']}%"></i>
        </div>
        <div class="legend">
          <span><i style="background:var(--ok)"></i>Hadir <b>{COUNTS['H']}</b></span>
          <span><i style="background:var(--info)"></i>Izin <b>{COUNTS['I']}</b></span>
          <span><i style="background:var(--warn)"></i>Sakit <b>{COUNTS['S']}</b></span>
          <span><i style="background:var(--bad)"></i>Alfa <b>{COUNTS['A']}</b></span>
        </div>
      </div>

      <div class="stats-grid">
        {stat('Tim', str(len(WORKERS)), 'org', ic='users')}
        {stat('Hadir', str(COUNTS['H']), 'org', ic='check')}
        {stat('Absen', str(COUNTS['I'] + COUNTS['S'] + COUNTS['A']), 'org', ic='alert')}
        {stat('Lembur', num(TODAY_LEMBUR), 'jam', ic='clock')}
        {stat('Rata-rata', f"{AVG_RATE/1000:.1f}".replace('.', ',') + ' rb', 'upah/hari', ic='trend')}
        {stat('Estimasi', f"{EST_BULAN/1_000_000:.1f}".replace('.', ',') + ' jt', 'bulan ini', accent=True, ic='wallet')}
      </div>

      {shead('Belum ditandai', 'alert', f'<span class="count">{len(pending)} ORANG</span>')}
      <div class="crew-list" id="pendingList">
        {''.join(crew_row(w) for w in pending) if pending else '<p class="crew-meta">Semua kru sudah tercatat.</p>'}
      </div>

      {shead('Aktivitas hari ini', 'activity', f'<button class="link" type="button" id="addTrx">{icon("plus", "link-ic")} Transaksi</button>')}
      <div class="crew-list">{''.join(trx_row(t) for t in TRANSACTIONS[:3])}</div>

      {shead('Aksi cepat', 'bolt')}
      <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:6px">
        <button class="icon-btn" type="button" style="width:100%;height:54px;flex-direction:column;gap:4px;display:flex" data-go="absensi">{icon('check')}<span style="font-size:8.5px;font-weight:600">Absensi</span></button>
        <button class="icon-btn" type="button" style="width:100%;height:54px;flex-direction:column;gap:4px;display:flex" data-go="absensi" data-tab="lembur">{icon('clock')}<span style="font-size:8.5px;font-weight:600">Lembur</span></button>
        <button class="icon-btn" type="button" style="width:100%;height:54px;flex-direction:column;gap:4px;display:flex" data-go="absensi" data-tab="bonus">{icon('wallet')}<span style="font-size:8.5px;font-weight:600">Bonus</span></button>
        <button class="icon-btn" type="button" style="width:100%;height:54px;flex-direction:column;gap:4px;display:flex" data-go="gaji">{icon('receipt')}<span style="font-size:8.5px;font-weight:600">Gaji</span></button>
      </div>
    </section>"""


def screen_absensi() -> str:
    rows = "".join(crew_row(w) for w in WORKERS)
    lmb = "".join(lembur_row(w) for w in WORKERS)
    trx = "".join(trx_row(t) for t in TRANSACTIONS)
    return f"""
    <section class="screen" id="screen-absensi" aria-label="Absensi">
      <div class="app-head">
        <div><p class="kicker">Pencatatan harian</p><h2>Absensi</h2></div>
        <span class="pill neutral" id="recordedPill">{len(WORKERS) - COUNTS[None]}/{len(WORKERS)} tercatat</span>
      </div>
      <div class="tabbar" role="tablist" aria-label="Jenis pencatatan">
        <button class="active" type="button" data-tab="absensi" role="tab">{icon('check')}Absensi</button>
        <button type="button" data-tab="lembur" role="tab">{icon('clock')}Lembur</button>
        <button type="button" data-tab="bonus" role="tab">{icon('wallet')}Bonus</button>
      </div>

      <div class="panel active" id="panel-absensi">
        {search_box('Cari nama atau jabatan', 'Cari kru')}
        <div class="chips">
          <button class="chip-btn active" type="button">Semua</button>
          <button class="chip-btn" type="button">Belum</button>
          <button class="chip-btn" type="button">Hadir</button>
          <button class="chip-btn" type="button">Alfa</button>
        </div>
        <button class="secondary" type="button" id="massalBtn" style="margin-bottom:10px">{icon('users', 'btn-ic')} Tandai massal · semua kru</button>
        <div class="crew-list">{rows}</div>
      </div>

      <div class="panel" id="panel-lembur">
        <div class="stats-grid" style="grid-template-columns:1fr 1fr;margin-bottom:12px">
          <div class="stat">{icon('clock', 'ic')}<p class="k">Total Jam</p><p class="v"><span id="totalJam">{num(TODAY_LEMBUR)}</span> <small>jam</small></p></div>
          <div class="stat accent">{icon('wallet', 'ic')}<p class="k">Biaya Lembur</p><p class="v"><span id="totalBiaya">{rp(TODAY_LEMBUR_RP)}</span> <small>hari ini</small></p></div>
        </div>
        <div class="crew-list">{lmb}</div>
      </div>

      <div class="panel" id="panel-bonus">
        <div class="stats-grid" style="margin-bottom:12px">
          {stat('Bonus', rp(TRX_TOTAL['Bonus']), '', accent=True, ic='trend')}
          {stat('Potongan', rp(TRX_TOTAL['Potongan']), '', ic='alert')}
          {stat('Kasbon', rp(TRX_TOTAL['Kasbon']), '', ic='wallet')}
        </div>
        <button class="secondary" type="button" id="addTrx2" style="margin-bottom:10px">{icon('plus', 'btn-ic')} Tambah transaksi</button>
        <div class="crew-list">{trx}</div>
      </div>
    </section>"""


def screen_gaji() -> str:
    payrows = "".join(pay_row(p) for p in PAYROLL)
    hist = "".join(hist_row(h) for h in HISTORY)
    return f"""
    <section class="screen" id="screen-gaji" aria-label="Gaji">
      <div class="app-head">
        <div><p class="kicker">Payroll</p><h2>Gaji</h2></div>
        <span class="pill neutral">Draft</span>
      </div>
      <div class="tabbar two" role="tablist" aria-label="Payroll">
        <button class="active" type="button" data-gtab="proses" role="tab">{icon('calculator')}Proses</button>
        <button type="button" data-gtab="riwayat" role="tab">{icon('history')}Riwayat</button>
      </div>

      <div class="panel active" id="panel-proses">
        <div class="period">
          <div style="display:flex;align-items:center;gap:9px">
            <span class="ico-sm">{icon('calendar')}</span>
            <div><b>01 — 15 Nov 2026</b><small>13 hari kerja · {len(WORKERS)} kru</small></div>
          </div>
          <div class="dates"><span>01</span><i>→</i><span>15</span></div>
        </div>
        <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:12px">
          {stat('Hari Kerja', '13', 'hari', ic='calendar')}
          {stat('Lembur', rp(TOTAL_LEMBUR), '', ic='clock')}
          {stat('Bonus', rp(TOTAL_BONUS), '', ic='trend')}
        </div>
        <div class="total-card">
          <div class="total-row"><span>Upah kerja</span><b>{rp(TOTAL_GROSS - TOTAL_LEMBUR - TOTAL_BONUS)}</b></div>
          <div class="total-row"><span>Lembur</span><b>{rp(TOTAL_LEMBUR)}</b></div>
          <div class="total-row"><span>Bonus</span><b>{rp(TOTAL_BONUS)}</b></div>
          <div class="total-row"><span>Kasbon</span><b>− {rp(TOTAL_KASBON)}</b></div>
          <div class="total-row"><span>Potongan</span><b>− {rp(TOTAL_POTONGAN)}</b></div>
          <div class="total-row grand"><span>Total bersih</span><b>{rp(TOTAL_NET)}</b></div>
        </div>
        {shead('Rincian per kru', 'list', f'<span class="count">{len(WORKERS)} SLIP</span>')}
        <div class="pay-list">{payrows}</div>
        <button class="secondary" type="button" id="calcBtn" style="margin-top:10px">{icon('refresh', 'btn-ic')} Hitung ulang kolektif</button>
      </div>

      <div class="panel" id="panel-riwayat">
        <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:12px">
          {stat('Total Dibayar', rp(HIST_TOTAL), '', ic='wallet')}
          {stat('Total Lembur', '128', 'jam', ic='clock')}
          {stat('Rata-rata', rp(HIST_TOTAL / 4), '', ic='trend')}
        </div>
        {shead('Arsip slip', 'history', f'<span class="count">{len(HISTORY)} FILE</span>')}
        {hist}
      </div>
    </section>"""


def screen_data() -> str:
    rows = "".join(data_row(w) for w in WORKERS)
    return f"""
    <section class="screen" id="screen-data" aria-label="Data Karyawan">
      <div class="app-head">
        <div><p class="kicker">Master data</p><h2>Karyawan</h2></div>
        <button class="icon-btn" type="button" id="addWorker" aria-label="Tambah karyawan">{icon('plus')}</button>
      </div>
      <div class="stats-grid" style="grid-template-columns:1fr 1fr;margin-bottom:12px">
        {stat('Total Tim', str(len(ACTIVE)), 'aktif', ic='users')}
        {stat('Rata-rata Upah', rp(AVG_RATE), '', accent=True, ic='trend')}
      </div>
      {search_box('Cari nama atau jabatan', 'Cari karyawan')}
      <div class="chips">
        <button class="chip-btn active" type="button">Aktif</button>
        <button class="chip-btn" type="button">Nonaktif</button>
        <button class="chip-btn" type="button">Punya kasbon</button>
      </div>
      <div class="crew-list">{rows}</div>
    </section>"""


def screen_lainnya() -> str:
    menu = "".join(menu_item(k, i, label) for k, i, label in MENU)
    return f"""
    <section class="screen" id="screen-lainnya" aria-label="Lainnya">
      <div class="app-head">
        <div><p class="kicker">Menu & pengaturan</p><h2>Lainnya</h2></div>
        <span class="pill ok">Offline</span>
      </div>

      <div class="profile-card">
        <span class="avatar">SR</span>
        <div><h3>Slamet Riyadi</h3><p>Admin · CV Karya Pantura</p></div>
        <span class="badge">OWNER</span>
      </div>

      {shead('Semua fitur', 'grid', f'<span class="count">{len(MENU)} MENU</span>')}
      <div class="menu-grid">{menu}</div>

      {shead('Pengaturan', 'gear')}
      <div class="card-box" style="background:var(--card);border:1px solid var(--line);border-radius:14px;padding:2px 12px">
        <div class="setting-row" style="border-bottom:0;padding-bottom:8px">
          <span class="ico">{icon('palette')}</span>
          <span class="txt"><b>Tema</b><span>Pilih tampilan aplikasi</span></span>
        </div>
        <div class="seg3" id="themeSeg" style="width:100%;margin:0 0 10px;padding:4px">
          <button class="active" type="button" data-theme="light">Terang</button>
          <button type="button" data-theme="dark">Gelap</button>
          <button type="button" data-theme="system">Sistem</button>
        </div>
        <button class="setting-row" type="button" data-menu="backup">
          <span class="ico">{icon('database')}</span>
          <span class="txt"><b>Ekspor database</b><span>Simpan atau kirim file .isar</span></span>
          {icon('chev', 'chev')}
        </button>
        <button class="setting-row" type="button" data-menu="restore">
          <span class="ico">{icon('upload')}</span>
          <span class="txt"><b>Impor database</b><span>Pulihkan data dari file backup</span></span>
          {icon('chev', 'chev')}
        </button>
        <button class="setting-row" type="button" data-menu="guide">
          <span class="ico">{icon('info')}</span>
          <span class="txt"><b>Panduan</b><span>6 fitur utama UpahKu</span></span>
          {icon('chev', 'chev')}
        </button>
        <button class="setting-row" type="button" data-menu="about">
          <span class="ico">{icon('shield')}</span>
          <span class="txt"><b>Tentang</b><span>UpahKu v1.0.0 · data lokal</span></span>
          {icon('chev', 'chev')}
        </button>
      </div>
      <p class="crew-meta" style="text-align:center;margin-top:14px">Semua data tersimpan di perangkat · tanpa server</p>
    </section>"""


def parity_rows() -> str:
    return "".join(f"<tr><td>{a}</td><td>{b}</td></tr>" for a, b in PARITY)


# ── HTML ─────────────────────────────────────────────────────────────────────
HTML = f"""<!doctype html>
<html lang="id">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UpahKu — Redesign Board v3</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=IBM+Plex+Sans:wght@400;500;600;700&family=Space+Grotesk:wght@500;600;700&display=swap" rel="stylesheet">
<style>{CSS}</style>
</head>
<body>

<header class="board-head">
  <div>
    <p class="eyebrow">REDESIGN BOARD · UPAHKU V3</p>
    <h1>Ledger Lapangan<span>Absen → kunci hari → bayar</span></h1>
    <p class="lede">Prototipe live. 5 layar, 14 fitur lama, plus menu penuh.</p>
  </div>
  <div class="head-actions">
    <button class="ghost" id="themeBtn" type="button">Mode gelap</button>
    <span class="chip">LIVE PROTOTYPE</span>
  </div>
</header>

<main class="board">
  <section class="stage">
    <div class="device" id="device">
      <div class="statusbar">
        <span>9:41</span>
        <span class="dots" aria-hidden="true">{icon('wifi-off', 'status-ic')}<span style="font-size:10px;letter-spacing:.06em">OFFLINE</span></span>
      </div>

      <div class="screens">
        {screen_hari()}
        {screen_absensi()}
        {screen_gaji()}
        {screen_data()}
        {screen_lainnya()}
      </div>

      <div class="screen-cta show" id="cta-hari">
        <button class="primary" type="button" id="closeDay">{icon('lock', 'btn-ic')} Tutup Hari · {len(WORKERS)} kru</button>
      </div>
      <div class="screen-cta" id="cta-gaji">
        <button class="primary" type="button" id="payBtn">{icon('wallet', 'btn-ic')} Simpan &amp; bayar</button>
      </div>

      <nav class="bottomnav" aria-label="Navigasi utama">
        <button class="nav-item active" data-screen="hari" type="button">{icon('check')}Hari Ini</button>
        <button class="nav-item" data-screen="absensi" type="button">{icon('users')}Absensi</button>
        <button class="nav-item" data-screen="gaji" type="button">{icon('receipt')}Gaji</button>
        <button class="nav-item" data-screen="data" type="button">{icon('database')}Data</button>
        <button class="nav-item" data-screen="lainnya" type="button">{icon('grid')}Lainnya</button>
      </nav>

      <div class="backdrop" id="backdrop"></div>

      <section class="sheet" id="sheet" role="dialog" aria-modal="true" aria-labelledby="sheetName">
        <div class="grab"></div>
        <div class="sheet-head">
          <span class="avatar" id="sheetAvatar">SR</span>
          <div><h3 id="sheetName">Slamet Riyadi</h3><p id="sheetRole">Tukang Batu · Rp 160.000/hari</p></div>
          <button class="sheet-close" id="sheetClose" type="button" aria-label="Tutup">×</button>
        </div>
        <p class="field-label">Status hari ini</p>
        <div class="seg" id="statusSeg" role="group" aria-label="Status kehadiran">
          <button type="button" data-status="H">{icon('check')}Hadir</button>
          <button type="button" data-status="I">{icon('calendar')}Izin</button>
          <button type="button" data-status="S">{icon('medical')}Sakit</button>
          <button type="button" data-status="A">{icon('x')}Alfa</button>
        </div>
        <div class="duo">
          <div class="field"><p class="field-label" style="margin:0">Lembur</p>
            <div class="val"><b id="lemburVal">0 jam</b><div class="stepper">
              <button type="button" id="lemburMinus" aria-label="Kurangi lembur">−</button>
              <button type="button" id="lemburPlus" aria-label="Tambah lembur">+</button>
            </div></div>
          </div>
          <div class="field"><p class="field-label" style="margin:0">Kasbon</p>
            <div class="val"><b id="kasbonVal">Rp 0</b><div class="stepper">
              <button type="button" id="kasbonMinus" aria-label="Kurangi kasbon">−</button>
              <button type="button" id="kasbonPlus" aria-label="Tambah kasbon">+</button>
            </div></div>
          </div>
        </div>
        <div class="duo">
          <div class="field"><p class="field-label" style="margin:0">Bonus</p>
            <div class="val"><b id="bonusVal">Rp 0</b><div class="stepper">
              <button type="button" id="bonusMinus" aria-label="Kurangi bonus">−</button>
              <button type="button" id="bonusPlus" aria-label="Tambah bonus">+</button>
            </div></div>
          </div>
          <div class="field"><p class="field-label" style="margin:0">Potongan</p>
            <div class="val"><b id="potonganVal">Rp 0</b><div class="stepper">
              <button type="button" id="potonganMinus" aria-label="Kurangi potongan">−</button>
              <button type="button" id="potonganPlus" aria-label="Tambah potongan">+</button>
            </div></div>
          </div>
        </div>
        <div class="sheet-total"><span>Upah hari ini</span><b id="sheetTotal">Rp 0</b></div>
        <button class="primary" id="saveWorker" type="button">{icon('check', 'btn-ic')} Simpan perubahan</button>
      </section>

      <section class="sheet" id="menuSheet" role="dialog" aria-modal="true" aria-labelledby="menuTitle">
        <div class="grab"></div>
        <div class="sheet-head">
          <span class="avatar" style="background:var(--accent);color:var(--accent-ink)">{icon('grid')}</span>
          <div><h3 id="menuTitle">Semua menu</h3><p>12 fitur · satu tempat</p></div>
          <button class="sheet-close" id="menuClose" type="button" aria-label="Tutup">×</button>
        </div>
        <div class="menu-grid">{''.join(menu_item(k, i, label) for k, i, label in MENU)}</div>
        <div style="height:8px"></div>
        <button class="secondary" type="button" data-menu="guide">{icon('info', 'btn-ic')} Buka panduan 6 fitur</button>
      </section>

      <section class="sheet" id="paySheet" role="dialog" aria-modal="true" aria-labelledby="payTitle">
        <div class="grab"></div>
        <div class="sheet-head">
          <span class="avatar" style="background:var(--accent);color:var(--accent-ink)">{icon('receipt')}</span>
          <div><h3 id="payTitle">Simpan & bayar</h3><p>01 — 15 Nov 2026 · {len(WORKERS)} slip</p></div>
          <button class="sheet-close" id="payClose" type="button" aria-label="Tutup">×</button>
        </div>
        <div class="total-card" style="margin-bottom:14px">
          <div class="total-row"><span>Total bersih</span><b>{rp(TOTAL_NET)}</b></div>
          <div class="total-row"><span>Slip dibuat</span><b>{len(WORKERS)} PDF</b></div>
          <div class="total-row"><span>Metode</span><b>Tunai / transfer</b></div>
        </div>
        <p class="crew-meta" style="margin-bottom:12px">Setelah disimpan, periode dikunci dan masuk ke Riwayat.</p>
        <button class="primary" type="button" id="confirmPay">{icon('lock', 'btn-ic')} Konfirmasi &amp; kunci periode</button>
      </section>

      <section class="sheet" id="massalSheet" role="dialog" aria-modal="true" aria-labelledby="massalTitle">
        <div class="grab"></div>
        <div class="sheet-head">
          <span class="avatar" style="background:var(--accent);color:var(--accent-ink)">{icon('users')}</span>
          <div><h3 id="massalTitle">Tandai massal</h3><p>Berlaku untuk {len(WORKERS)} kru aktif</p></div>
          <button class="sheet-close" id="massalClose" type="button" aria-label="Tutup">×</button>
        </div>
        <div class="seg" style="grid-template-columns:repeat(2,1fr);margin-bottom:10px" id="massalSeg">
          <button type="button" data-massal="H">{icon('check')}Semua Hadir</button>
          <button type="button" data-massal="A">{icon('x')}Semua Alfa</button>
          <button type="button" data-massal="I">{icon('calendar')}Semua Izin</button>
          <button type="button" data-massal="S">{icon('medical')}Semua Sakit</button>
        </div>
      </section>

      <div class="toast" id="toast" role="status" aria-live="polite"></div>
    </div>
    <p class="stage-caption">390 × 844 · target sentuh ≥44dp · angka tabular · kontras teks ≥4.5:1</p>
  </section>

  <aside class="spec">
    <div class="spec-card">
      <h3>Parity check — 14 fitur lama</h3>
      <table class="parity">
        <thead><tr><th>Fitur di app lama</th><th>Lokasi di desain baru</th></tr></thead>
        <tbody>{parity_rows()}</tbody>
      </table>
    </div>

    <div class="spec-card">
      <h3>Kenapa 5 tab</h3>
      <ul class="spec-list">
        <li><span class="num">01</span><div><b>Hari Ini</b> — ringkasan + yang belum ditandai + aktivitas + aksi cepat. Ini dashboard yang benar-benar dipakai tiap pagi.</div></li>
        <li><span class="num">02</span><div><b>Absensi</b> — menampung 3 pekerjaan lama (absensi, lembur, bonus) sebagai segmented control, bukan tiga tab tersembunyi.</div></li>
        <li><span class="num">03</span><div><b>Gaji</b> — proses dan riwayat dalam satu rumah. Tab “Penggajian” yang dulu membuka Riwayat sudah tidak ada.</div></li>
        <li><span class="num">04</span><div><b>Data</b> — master karyawan + 5 statistik + form tambah/edit.</div></li>
        <li><span class="num">05</span><div><b>Lainnya</b> — menu penuh: slip PDF, backup, impor, tema, profil, panduan, tentang, status offline.</div></li>
      </ul>
    </div>

    <div class="spec-card">
      <h3>Alur baru</h3>
      <div class="flow">
        <span>Tandai kru</span><i>→</i><span>Tutup hari</span><i>→</i><span>Hitung</span><i>→</i><span>Simpan & bayar</span>
      </div>
      <p style="margin-top:12px">Kasbon, bonus, dan potongan sekarang terlihat sebagai transaksi hari ini — bukan field yang baru muncul di slip. Itu menghilangkan sumber sengketa paling umum.</p>
    </div>

    <div class="spec-card">
      <h3>Token visual</h3>
      <div class="swatches">
        <div class="sw"><i style="background:#101826"></i><span>ink<br>#101826</span></div>
        <div class="sw"><i style="background:#F6F3EC"></i><span>paper<br>#F6F3EC</span></div>
        <div class="sw"><i style="background:#E3A72F"></i><span>accent<br>#E3A72F</span></div>
        <div class="sw"><i style="background:#1F7A5A"></i><span>ok<br>#1F7A5A</span></div>
      </div>
      <div style="margin-top:14px">
        <div class="type-row"><b style="font-size:26px">Hari Ini</b><span class="mono">Space Grotesk 26/600</span></div>
        <div class="type-row"><b style="font-size:13px">Slamet Riyadi</b><span class="mono">Plex Sans 13/600</span></div>
        <div class="type-row"><b style="font-size:13px">Rp 1.599.250</b><span class="mono">Plex Mono 36/600</span></div>
        <div class="type-row"><b style="font-size:10px">HADIR</b><span class="mono">Plex Mono 9.5/600</span></div>
      </div>
    </div>
  </aside>
</main>

<script>
const WORKERS = {json.dumps(WORKERS, ensure_ascii=False)};
const RATE_LEMBUR = (rate) => Math.round(rate / 8 * 1.5 / 500) * 500;
const rp = (n) => 'Rp ' + Math.round(n).toLocaleString('id-ID');
const shortRp = (n) => n >= 1000000
  ? 'Rp ' + (n / 1000000).toFixed(1).replace('.', ',').replace(',0', '') + ' jt'
  : n >= 1000
    ? 'Rp ' + Math.round(n / 1000) + ' rb'
    : 'Rp ' + n;
const $ = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));

let activeId = null, draft = null, toastTimer = null;

function toast(msg) {{
  const el = $('#toast');
  el.textContent = msg;
  el.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => el.classList.remove('show'), 2400);
}}

function showScreen(name) {{
  $$('.screen').forEach(s => s.classList.toggle('active', s.id === 'screen-' + name));
  $$('.nav-item').forEach(b => b.classList.toggle('active', b.dataset.screen === name));
  $('#cta-hari').classList.toggle('show', name === 'hari');
  $('#cta-gaji').classList.toggle('show', name === 'gaji');
}}

$$('.nav-item').forEach(b => b.addEventListener('click', () => showScreen(b.dataset.screen)));

function showTab(group, name) {{
  if (group === 'absensi') {{
    $$('#screen-absensi .tabbar button').forEach(b => b.classList.toggle('active', b.dataset.tab === name));
    $$('#screen-absensi .panel').forEach(p => p.classList.toggle('active', p.id === 'panel-' + name));
  }} else {{
    $$('#screen-gaji .tabbar button').forEach(b => b.classList.toggle('active', b.dataset.gtab === name));
    $('#panel-proses').classList.toggle('active', name === 'proses');
    $('#panel-riwayat').classList.toggle('active', name === 'riwayat');
    $('#cta-gaji').classList.toggle('show', name === 'proses');
  }}
}}

$$('#screen-absensi .tabbar button').forEach(b => b.addEventListener('click', () => showTab('absensi', b.dataset.tab)));
$$('#screen-gaji .tabbar button').forEach(b => b.addEventListener('click', () => showTab('gaji', b.dataset.gtab)));

function summary() {{
  const hadir = WORKERS.filter(w => w.status === 'H');
  const lembur = hadir.reduce((a, w) => a + w.lembur, 0);
  const upah = hadir.reduce((a, w) => a + w.rate + w.lembur * RATE_LEMBUR(w.rate), 0);
  return {{ hadir: hadir.length, lembur, upah }};
}}

function paintSummary() {{
  const s = summary();
  $('#heroValue').textContent = rp(s.upah);
  $('#heroCrew').textContent = s.hadir + ' kru hadir';
  $('#heroLembur').textContent = s.lembur.toFixed(1).replace('.0', '').replace('.', ',') + ' jam lembur';
  const recorded = WORKERS.filter(w => w.status).length;
  if ($('#recordedPill')) $('#recordedPill').textContent = recorded + '/' + WORKERS.length + ' tercatat';
  paintLembur();
  WORKERS.forEach(w => {{
    const el = document.querySelector('[data-pill="' + w.id + '"]');
    if (!el) return;
    const meta = {{ H: ['Hadir', 'ok'], I: ['Izin', 'info'], S: ['Sakit', 'warn'], A: ['Alfa', 'bad'] }}[w.status] || ['Belum', 'neutral'];
    el.textContent = meta[0];
    el.className = 'pill ' + meta[1];
  }});
}}

function openSheet(id) {{
  const w = WORKERS.find(x => x.id === Number(id));
  if (!w) return;
  activeId = w.id;
  draft = {{ status: w.status, lembur: w.lembur, kasbon: w.kasbon, bonus: w.bonus, potongan: w.potongan }};
  $('#sheetName').textContent = w.nama;
  $('#sheetRole').textContent = w.jabatan + ' · ' + rp(w.rate) + '/hari';
  $('#sheetAvatar').textContent = w.nama.replace('H. ', '').split(' ').map(p => p[0]).slice(0, 2).join('').toUpperCase();
  paintSheet();
  openModal('#sheet');
}}

function paintSheet() {{
  if (!draft) return;
  const w = WORKERS.find(x => x.id === activeId);
  $$('#statusSeg button').forEach(b => b.classList.toggle('sel', b.dataset.status === draft.status));
  $('#lemburVal').textContent = draft.lembur.toFixed(1).replace('.0', '').replace('.', ',') + ' jam';
  $('#kasbonVal').textContent = shortRp(draft.kasbon);
  $('#bonusVal').textContent = shortRp(draft.bonus);
  $('#potonganVal').textContent = shortRp(draft.potongan);
  const base = draft.status === 'H' ? w.rate : 0;
  $('#sheetTotal').textContent = rp(base + draft.lembur * RATE_LEMBUR(w.rate) + draft.bonus - draft.potongan);
}}

$$('#statusSeg button').forEach(b => b.addEventListener('click', () => {{
  draft.status = b.dataset.status;
  if (draft.status !== 'H') draft.lembur = 0;
  paintSheet();
}}));

$('#lemburPlus').addEventListener('click', () => {{ draft.lembur = Math.min(8, draft.lembur + 0.5); paintSheet(); }});
$('#lemburMinus').addEventListener('click', () => {{ draft.lembur = Math.max(0, draft.lembur - 0.5); paintSheet(); }});
$('#kasbonPlus').addEventListener('click', () => {{ draft.kasbon = Math.min(2000000, draft.kasbon + 50000); paintSheet(); }});
$('#kasbonMinus').addEventListener('click', () => {{ draft.kasbon = Math.max(0, draft.kasbon - 50000); paintSheet(); }});
$('#bonusPlus').addEventListener('click', () => {{ draft.bonus = Math.min(2000000, draft.bonus + 50000); paintSheet(); }});
$('#bonusMinus').addEventListener('click', () => {{ draft.bonus = Math.max(0, draft.bonus - 50000); paintSheet(); }});
$('#potonganPlus').addEventListener('click', () => {{ draft.potongan = Math.min(2000000, draft.potongan + 25000); paintSheet(); }});
$('#potonganMinus').addEventListener('click', () => {{ draft.potongan = Math.max(0, draft.potongan - 25000); paintSheet(); }});

$('#saveWorker').addEventListener('click', () => {{
  const w = WORKERS.find(x => x.id === activeId);
  Object.assign(w, draft);
  paintSummary();
  closeModal();
  toast(w.nama + ' diperbarui');
}});

function openModal(sel) {{
  $('#backdrop').classList.add('show');
  $(sel).classList.add('open');
}}
function closeModal() {{
  $('#backdrop').classList.remove('show');
  $$('.sheet').forEach(s => s.classList.remove('open'));
}}

$('#sheetClose').addEventListener('click', closeModal);
$('#menuClose').addEventListener('click', closeModal);
$('#payClose').addEventListener('click', closeModal);
$('#massalClose').addEventListener('click', closeModal);
$('#backdrop').addEventListener('click', closeModal);
document.addEventListener('keydown', e => {{ if (e.key === 'Escape') closeModal(); }});

document.addEventListener('click', e => {{
  const row = e.target.closest('.crew-row[data-id]');
  if (row) openSheet(row.dataset.id);
}});

document.addEventListener('click', e => {{
  const btn = e.target.closest('[data-lmb]');
  if (!btn) return;
  const row = btn.closest('[data-lembur]');
  if (!row) return;
  const w = WORKERS.find(x => x.id === Number(row.dataset.lembur));
  if (!w) return;
  w.lembur = Math.max(0, Math.min(8, w.lembur + Number(btn.dataset.lmb) * 0.5));
  row.querySelector('[data-lmbval]').textContent = String(w.lembur).replace('.', ',');
  paintSummary();
}});

function paintLembur() {{
  const hadir = WORKERS.filter(w => w.status === 'H');
  const jam = hadir.reduce((a, w) => a + w.lembur, 0);
  const biaya = hadir.reduce((a, w) => a + w.lembur * RATE_LEMBUR(w.rate), 0);
  if ($('#totalJam')) $('#totalJam').textContent = String(jam).replace('.', ',');
  if ($('#totalBiaya')) $('#totalBiaya').textContent = rp(biaya);
}}

$('#openMenu').addEventListener('click', () => openModal('#menuSheet'));
$('#openProfile').addEventListener('click', () => {{ showScreen('lainnya'); }});
$('#addWorker').addEventListener('click', () => toast('Form karyawan baru'));
$('#addTrx').addEventListener('click', () => toast('Form transaksi baru'));
$('#addTrx2').addEventListener('click', () => toast('Form transaksi baru'));
$('#calcBtn').addEventListener('click', () => toast('Gaji kolektif dihitung ulang'));
$('#markAll') && $('#markAll').addEventListener('click', () => {{ WORKERS.forEach(w => w.status = 'H'); paintSummary(); toast('Semua kru ditandai hadir'); }});

$('#closeDay').addEventListener('click', () => {{
  const s = summary();
  toast('Hari dikunci · ' + s.hadir + ' kru · ' + rp(s.upah));
}});

$('#massalBtn').addEventListener('click', () => openModal('#massalSheet'));
$$('#massalSeg button').forEach(b => b.addEventListener('click', () => {{
  WORKERS.forEach(w => {{ w.status = b.dataset.massal; if (w.status !== 'H') w.lembur = 0; }});
  paintSummary();
  closeModal();
  toast('Semua kru ditandai ' + b.textContent.toLowerCase());
}}));

$('#payBtn').addEventListener('click', () => openModal('#paySheet'));
$('#confirmPay').addEventListener('click', () => {{
  closeModal();
  toast('Periode dikunci · ' + {len(WORKERS)} + ' slip masuk Riwayat');
}});

$$('[data-go]').forEach(b => b.addEventListener('click', () => {{
  showScreen(b.dataset.go);
  if (b.dataset.tab) showTab('absensi', b.dataset.tab);
}}));

$$('[data-menu]').forEach(b => b.addEventListener('click', () => {{
  const label = b.textContent.trim().replace(/\\s+/g, ' ');
  closeModal();
  toast(label + ' dibuka');
}}));

$$('#themeSeg button').forEach(b => b.addEventListener('click', () => {{
  const mode = b.dataset.theme;
  $$('#themeSeg button').forEach(x => x.classList.toggle('active', x === b));
  document.body.classList.toggle('dark', mode === 'dark');
  $('#themeBtn').textContent = mode === 'dark' ? 'Mode terang' : 'Mode gelap';
  toast('Tema: ' + b.textContent);
}}));

$('#themeBtn').addEventListener('click', e => {{
  document.body.classList.toggle('dark');
  e.currentTarget.textContent = document.body.classList.contains('dark') ? 'Mode terang' : 'Mode gelap';
}});

const params = new URLSearchParams(location.search);
if (location.hash === '#dark' || params.get('theme') === 'dark') {{
  document.body.classList.add('dark');
  $('#themeBtn').textContent = 'Mode terang';
}}

paintSummary();

const startScreen = params.get('screen');
if (startScreen && document.getElementById('screen-' + startScreen)) showScreen(startScreen);
const startTab = params.get('tab');
if (startTab) showTab('absensi', startTab);
const startGtab = params.get('gtab');
if (startGtab) showTab('gaji', startGtab);
if (params.get('sheet') === 'worker') openSheet(1);
if (params.get('sheet') === 'menu') openModal('#menuSheet');
if (params.get('sheet') === 'pay') openModal('#paySheet');
</script>
</body>
</html>
"""


if __name__ == "__main__":
    target = OUT / "index.html"
    target.write_text(HTML, encoding="utf-8")
    print(f"wrote {target} ({target.stat().st_size:,} bytes)")
    print(f"workers={len(WORKERS)} fitur_lama={len(PARITY)} net={rp(TOTAL_NET)}")
