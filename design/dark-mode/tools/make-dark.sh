#!/usr/bin/env bash
# Builds dark-mode copies of every Rivjuuu batch into ../<batch>/  (re-runnable)
set -e
R="$(cd "$(dirname "$0")/../.." && pwd)"
D="$R/dark-mode"
BATCHES="batch-02-entry-authentication batch-03-customer-discovery batch-04-rewards-social-profile batch-05-restaurant-app"

# Light colour -> dark colour (used in CSS and inline HTML/SVG)
MAP_COMMON=(
  "#f1ece2:#26262a" "#e9e3d8:#2a2a2e" "#fdf0d9:#33261a" "#ffe8e0:#3a1d15" "#f6f1e8:#202023"
  "#eceee9:#1c1d20" "#ece4d6:#2a2a2e" "#e6f4ea:#15301f" "#e5f4ea:#15301f" "#ddd3c2:#3a3a40"
  "#d8cfbf:#3a3a40" "#fffaf7:#2a1a14" "#fff4ef:#2a1a14" "#fff3ee:#2a1a14" "#fff1dc:#33261a"
  "#eef0ee:#1c1d20" "#eef0ef:#1c1d20" "#eceef1:#0b0b0c" "#e4ddd0:#3f3f46" "#e3dacb:#34343a" "#e2e2e2:#2a2a2e"
  "#d9d2c6:#2c2c31" "#d8d3cc:#3a3a40" "#cfcbc5:#52525b" "#c9c3b8:#52525b" "#b5b0a6:#71717a" "#b5ad9f:#71717a"
  "#1f7a45:#5fd38d" "#8a5300:#f0b35a" "#7a4a00:#f0b35a" "#b06b00:#f0b35a" "#c2380f:#ff8a6b" "#b8330f:#ff8a6b"
  "#b8322a:#ff8a6b" "#3f3f46:#d4d4d8" "#52525b:#a1a1aa" "#8b8b93:#8b8b93" "#fef9ef:#121214" "#fdfdfc:#121214"
  "#d3e8d4:#1e3326" "#cde8d3:#1e3326" "#d4e6f3:#16283a" "#e3e3dd:#26272b" "#dfe3ea:#2a2d33" "#f8d9cf:#5a2a1d"
  "#ebf2fe:#16233a" "#fcebeb:#3a1d1d" "#fdf2e2:#33261a" "#e7f5ee:#15301f" "#f7f7f7:#1c1c1f" "#fafafa:#1c1c1f"
  "#ededed:#2a2a2e" "#d9d9d9:#3a3a40" "#f1edfe:#241d3d" "#fdecec:#3a1d15"
)
sed_map() { local args=() p; for p in "${MAP_COMMON[@]}"; do args+=(-e "s/${p%%:*}/${p##*:}/gI"); done; sed -i "${args[@]}" "$@"; }

for b in $BATCHES; do
  src="$R/$b/html"; dst="$D/$b"
  rm -rf "$dst"; mkdir -p "$dst"; cp -r "$src/." "$dst/"
  cp "$R/brand/rivjuuu-logo-dark.png" "$dst/assets/img/logo.png"

  # ---- CSS ----
  for css in "$dst"/assets/*.css; do
    sed -i -E \
      -e 's/background(-color)?: ?#ffffff/background\1: #1c1c1f/g' \
      -e 's/(0 0 0 [0-9.]+px) #ffffff/\1 #121214/g' \
      -e 's/(border(-[a-z]+)?: ?[0-9.]+px (solid|dashed) )#ffffff/\1#1c1c1f/g' \
      -e 's/rgba\(255, ?255, ?255, ?\.9[0-9]?\)/rgba(28, 28, 31, .9)/g' \
      "$css"
    sed_map "$css"
  done

  # dark tokens + component fixes, loaded last
  cat > "$dst/assets/dark.css" <<'EOF'
/* Rivjuuu dark mode — token overrides and components that used Dark (#18181b) as a fill */
:root {
  color-scheme: dark;
  --coral: #fe552e; --coral-press: #ff6a46; --coral-soft: #3a1d15; --peach: #33261a;
  --cream: #121214; --navy: #f4f4f5; --text: #a1a1aa; --muted: #71717a; --line: #2a2a2e;
  --green: #4cc27f; --green-soft: #15301f; --amber: #f0b35a; --amber-soft: #33261a; --blue: #6e9bff;
  /* batch-2 structure pages */
  --bg: #121214; --surface: #1c1c1f; --surface-soft: #1c1c1f; --ink: #f4f4f5; --ink-secondary: #a1a1aa; --ink-tertiary: #71717a;
  --line-strong: #3a3a40; --brand-soft: #3a1d15; --brand-text: #ff7a5c; --success-soft: #15301f; --warning-soft: #33261a; --info-soft: #16233a; --error-soft: #3a1d1d;
}
body, body.pg, .pv { background: #0b0b0c; color: #f4f4f5; }
.phone { background: var(--cream); box-shadow: 0 0 0 11px #2a2a2e, 0 0 0 12px #3f3f46, 0 40px 80px rgba(0, 0, 0, .6); }
.home-ind { background: #f4f4f5; }
.splash-bg { background: #121214; }

/* Elevated dark surfaces (were Dark fills) */
.loy, .kpi--hero, .toast-ok, .tk--dark .tk__val, .mc__val--dark, .offer--dark, .pin__label, .av-d, .toast { background: #2c2c31; color: #ffffff; }
.pin--sel { background: #f4f4f5; }
.pin--sel .ic { color: #18181b; }

/* Selected controls become light-on-dark */
.chip2.is-on, .seg a.is-on, .billing span.is-on, .days span.is-on, .fsec__title span, .thumb button, .filterbtn, .rbar i span, .dots span.is-on, .tabs a.is-on::after { background: #f4f4f5; color: #18181b; border-color: #f4f4f5; }
.tabs a.is-on::after { background: var(--coral); }
.thumb button { border-color: var(--cream); }
.st--orange, .offer, .promo__tag, .ready, .plan__badge, .count, .row .count, .chip2 .n { color: #ffffff; }

/* Cards, inputs and sheets */
.input, .search, .round, .lang, .vis, .stepper, .type, .icon-btn, .chip2, .seg, .billing, .days span, .upload, .addphoto, .area, .file, .reward, .gw, .gi, .gc, .rv, .rsum, .lc, .plan, .kpi, .qa a, .feed, .sec-card, .fsec, .stat2, .chart, .card-plain, .menu-group, .cd-list, .res__rows, .summary, .note, .rows, .ctx, .visit, .mc, .gm, .complete, .tk, .bsheet, .mapcard, .nav, .rnav, .qr-box, .timer, .fact, .score-pill { border-color: var(--line); }
.input--ro, .stepper button, .stepbtn, .row__icon, .fi__icon, .tabrow__icon, .mm-item__img--none, .gallery button { background: #26262a; }
.btn--ghost { background: #1c1c1f; color: #f4f4f5; box-shadow: inset 0 0 0 1px #3a3a40; }
.btn--outline { background: transparent; }
.btn--locked, .btn[disabled], .btn.is-disabled { background: #26262a; color: #8b8b93; }
.btn { box-shadow: none; }
.search__clear { background: #2a2a2e; }
.scrim { background: rgba(0, 0, 0, .6); }
.hint { background: #33261a; }
.private, .intro-strip { background: #1c1c1f; border: 1px solid var(--line); }
.nt.is-new { background: #1f1714; }
.qr-box { background: #ffffff; }
.qr-box__logo { background: #ffffff; box-shadow: 0 0 0 4px #ffffff; }
.rnav a.scan span { box-shadow: 0 8px 18px rgba(254, 85, 46, .35), 0 0 0 5px #1c1c1f; }
.cd-card::before, .cd-card::after, .tk__val::before, .tk__val::after { background: var(--cream); border-color: var(--line); }
.cd-card--muted { background: #2c2c31; color: #f4f4f5; }
.cd-card--muted .cd-card__rest span.l { background: #2e4a3a; }
.tk--muted .tk__val, .mc__val--muted { background: #26262a; color: #8b8b93; }
.flag { box-shadow: 0 0 0 1px rgba(255, 255, 255, .12); }
.av-a { background: #3a1d15; color: #ffad96; } .av-b { background: #33261a; color: #f0c27a; } .av-c { background: #2a2a2e; color: #d4d4d8; }
.radio { border-color: #52525b; }
.switch--off { background: #3f3f46; }
.gm__img .st, .gc__img .st, .gfeat .st { box-shadow: 0 2px 6px rgba(0, 0, 0, .3); }
.cd-card__rest span.l { background: #ffffff; color: #2e4a3a; }
EOF

  # ---- HTML ----
  for f in "$dst"/*.html; do
    sed -i -E \
      -e 's/background(-color)?: ?#ffffff/background\1: #1c1c1f/g' \
      -e 's/stroke="#ffffff"( stroke-linecap="round")?>/stroke="#34353a"\1>/g' \
      -e 's/<g stroke="#ffffff"/<g stroke="#34353a"/g' \
      -e 's/rgba\(255, ?255, ?255, ?\.9[0-9]?\)/rgba(28, 28, 31, .9)/g' \
      -e 's/fill: ?#18181b/fill: #f4f4f5/g' \
      "$f"
    sed_map "$f"
    # load dark.css last (after the final stylesheet link in <head>)
    perl -0pi -e 's|(</head>)|<link rel="stylesheet" href="assets/dark.css">\n$1|' "$f"
  done
  echo "dark: $b"
done

# ---- Top-level index ----
cat > "$D/index.html" <<'EOF'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Rivjuuu Dark Mode</title>
<link rel="stylesheet" href="batch-02-entry-authentication/assets/rv2.css">
<link rel="stylesheet" href="batch-02-entry-authentication/assets/dark.css">
</head>
<body class="pg">
<main class="ix">
<img class="brand-logo" src="batch-02-entry-authentication/assets/img/logo.png" alt="Rivjuuu" style="width: 130px">
<section><h2>Dark mode</h2><div class="ix-grid">
<a class="ix-card" href="batch-02-entry-authentication/index.html">Entry &amp; authentication</a>
<a class="ix-card" href="batch-03-customer-discovery/index.html">Customer discovery &amp; restaurant</a>
<a class="ix-card" href="batch-04-rewards-social-profile/index.html">Rewards, social &amp; profile</a>
<a class="ix-card" href="batch-05-restaurant-app/index.html">Restaurant app</a>
</div></section>
</main>
</body>
</html>
EOF
echo done
