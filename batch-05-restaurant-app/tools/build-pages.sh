#!/usr/bin/env bash
# Builds Rivjuuu Batch 5 (Restaurant app, pages 39–59) into ../html
set -e
H="$(cd "$(dirname "$0")/../html" && pwd)"

SB_ICONS='<span class="sb__icons"><svg width="18" height="12" viewBox="0 0 18 12" fill="currentColor" aria-hidden="true"><rect x="0" y="8" width="3" height="4" rx="1"/><rect x="5" y="5.5" width="3" height="6.5" rx="1"/><rect x="10" y="3" width="3" height="9" rx="1"/><rect x="15" y="0" width="3" height="12" rx="1"/></svg><svg width="16" height="12" viewBox="0 0 16 12" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" aria-hidden="true"><path d="M1.5 4.3a9.5 9.5 0 0 1 13 0M4.2 7.1a5.6 5.6 0 0 1 7.6 0"/><circle cx="8" cy="10" r="1.3" fill="currentColor" stroke="none"/></svg><svg width="26" height="12" viewBox="0 0 26 12" aria-hidden="true"><rect x=".5" y=".5" width="22" height="11" rx="3.2" fill="none" stroke="currentColor" opacity=".45"/><rect x="2" y="2" width="19" height="8" rx="2" fill="currentColor"/><rect x="24" y="4" width="1.6" height="4" rx=".8" fill="currentColor" opacity=".5"/></svg></span>'
SB="<div class=\"sb\"><span>9:41</span><span class=\"sb__island\"></span>$SB_ICONS</div>"
SBW="<div class=\"sb sb--float sb--white\"><span>9:41</span><span class=\"sb__island\"></span>$SB_ICONS</div>"

rnav() {
  local d c a p; d=""; c=""; a=""; p=""
  case "$1" in dash) d=" is-on";; coupons) c=" is-on";; activity) a=" is-on";; profile) p=" is-on";; esac
  echo "<nav class=\"rnav\" aria-label=\"Main\"><a class=\"$d\" href=\"dashboard.html\"><i class=\"ic ic-dashboard\"></i>Dashboard</a><a class=\"$c\" href=\"coupons.html\"><i class=\"ic ic-ticket\"></i>Coupons</a><a class=\"scan\" href=\"scanner.html\" aria-label=\"Scan QR\"><span><i class=\"ic ic-scan\"></i></span>Scan</a><a class=\"$a\" href=\"loyalty-activity.html\"><i class=\"ic ic-activity\"></i>Activity</a><a class=\"$p\" href=\"account.html\"><i class=\"ic ic-user\"></i>Profile</a></nav>"
}

QRGHOST="$(awk 'BEGIN{srand(5);N=21;s="<svg class=\"qrghost\" viewBox=\"0 0 21 21\" aria-hidden=\"true\"><g fill=\"#ffffff\">";
 for(y=0;y<N;y++)for(x=0;x<N;x++){f=((x<7&&y<7)||(x>N-8&&y<7)||(x<7&&y>N-8)); if(!f&&rand()>0.5)s=s "<rect x=\"" x "\" y=\"" y "\" width=\"1\" height=\"1\"/>"}
 split("0 14 0",fx," ");split("0 0 14",fy," ");
 for(i=1;i<=3;i++){s=s "<rect x=\"" fx[i]+0.5 "\" y=\"" fy[i]+0.5 "\" width=\"6\" height=\"6\" rx=\"1.4\" fill=\"none\" stroke=\"#ffffff\" stroke-width=\"1\"/><rect x=\"" fx[i]+2 "\" y=\"" fy[i]+2 "\" width=\"3\" height=\"3\" rx=\".6\"/>"}
 print s "</g></svg>"}')"

page() {
  local body; body="$(cat)"
  body="${body//@@SB@@/$SB}"
  body="${body//@@SBW@@/$SBW}"
  body="${body//@@NAV_DASH@@/$(rnav dash)}"
  body="${body//@@NAV_COUPONS@@/$(rnav coupons)}"
  body="${body//@@NAV_ACTIVITY@@/$(rnav activity)}"
  body="${body//@@NAV_PROFILE@@/$(rnav profile)}"
  body="${body//@@QRGHOST@@/$QRGHOST}"
  body="${body//@@DOT@@/<i class=\"sep\"></i>}"
  cat > "$H/$1" <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Rivjuuu Restaurant · $2</title>
<link rel="stylesheet" href="assets/rv2.css">
<link rel="stylesheet" href="assets/rv3.css">
<link rel="stylesheet" href="assets/rv4.css">
<link rel="stylesheet" href="assets/rv5.css">
</head>
<body class="pg">
<div class="stage"><div class="phone">
$body
</div></div>
<script>(function(){function f(){var s=document.querySelector('.stage');var r=Math.min(1,(document.documentElement.clientWidth-40)/414);s.style.zoom=r<1?String(r):'';}f();addEventListener('resize',f);})();</script>
</body>
</html>
EOF
}
BAR() { echo "<div class=\"bar\" style=\"padding-top: 4px\"><a class=\"round\" href=\"$1\" aria-label=\"Back\"><i class=\"ic ic-arrow-left\"></i></a><span class=\"bar__title\">$2</span>${3:-<span class=\"spacer\"></span>}</div>"; }
TOPTITLE() { echo "<div class=\"bar\" style=\"padding-top: 4px\"><span class=\"bar__title bar__title--left\">$1</span>${2:-}</div>"; }
TABS() { # "label|href|on" ...
  local out="<div class=\"tabs\" role=\"tablist\" style=\"margin-top: 6px\">" t l h o
  for t in "$@"; do IFS='|' read -r l h o <<< "$t"; out="$out<a class=\"${o:+is-on}\" href=\"$h\">$l</a>"; done
  echo "$out</div>"
}

# ======================= 39 REGISTRATION STATUS =======================
status_page() { # file title disc icon heading text chip-class chip extra actions
page "$1" "$2" <<EOF
@@SB@@
<div class="top"><img class="brand-logo" src="assets/img/logo.png" alt="Rivjuuu" style="width: 64px"><a class="link" href="#" style="font-size: 13px; display: inline-flex; gap: 6px; align-items: center; color: var(--navy)"><i class="ic ic-logout ic-18"></i>Log out</a></div>
<div class="content" style="padding-top: 30px">
<div class="hero"><span class="disc $3"><i class="ic $4"></i></span><h1>$5</h1><p>$6</p></div>
<div class="summary" style="margin-top: 26px">
<div style="display: flex; align-items: center; gap: 12px"><span class="rlogo">NR</span><span style="display: flex; flex-direction: column"><b style="font-size: 14px; font-weight: 600">Trattoria Nonna Rosa</b><span style="font-size: 12px; color: var(--text)">Italian · Fő utca 12, Hungary</span></span></div>
<div class="summary__row" style="margin-top: 4px"><span>Submitted</span><span>29 Sep 2026</span></div>
<div class="summary__row" style="align-items: center"><span>Status</span><span class="chip $7">$8</span></div>
</div>
$9
</div>
${10}
EOF
}
status_page status-pending.html "Application under review" "disc--amber" "ic-clock" "Application under review" "We're reviewing your restaurant. You'll get a notification as soon as it's approved." "chip--amber" "Pending review" "" '<div class="bottom"><button class="btn btn--ghost" type="button">View submitted details</button><p class="alt"><a class="link" href="#">Contact support</a></p></div>'
status_page status-approved.html "Restaurant approved" "disc--green" "ic-check-circle" "Your restaurant is approved" "Choose a plan to finish setup and start publishing coupons." "chip--green" "Approved" "" '<div class="bottom"><a class="btn" href="plans.html">Continue</a></div>'
status_page status-rejected.html "Application needs attention" "disc--coral" "ic-info" "Application needs attention" "We couldn't approve your restaurant yet. Please contact support for help." "chip--coral" "Not approved" '<div class="note" style="margin-top: 12px"><b>Message from the review team</b>[Reason appears here when provided.]</div>' '<div class="bottom"><button class="btn" type="button"><i class="ic ic-help ic-20"></i>Contact support</button><p class="alt"><a class="link" href="#">View submitted details</a></p></div>'

# ======================= 40 SUBSCRIPTION PACKAGES =======================
PLANS='<div class="plan"><div class="plan__head"><span><span class="plan__name">Starter</span><br><span class="plan__desc">Get listed and start with coupons</span></span><span class="plan__price"><b>9,990</b><small>HUF / month</small></span></div>
<ul class="feats"><li><i class="ic ic-check"></i>Up to 3 active coupons</li><li><i class="ic ic-check"></i>Loyalty program</li><li><i class="ic ic-check"></i>Basic statistics</li><li class="no"><i class="ic ic-x"></i>Giveaways</li><li class="no"><i class="ic ic-x"></i>Highlighted placement</li></ul>
<a class="btn btn--ghost" href="plan-payment.html">Choose plan</a></div>
<div class="plan plan--pop"><span class="plan__badge">MOST POPULAR</span><div class="plan__head"><span><span class="plan__name">Growth</span><br><span class="plan__desc">More coupons and giveaways</span></span><span class="plan__price"><b>19,990</b><small>HUF / month</small></span></div>
<ul class="feats"><li><i class="ic ic-check"></i>Up to 10 active coupons</li><li><i class="ic ic-check"></i>Loyalty program</li><li><i class="ic ic-check"></i>2 giveaways per month</li><li><i class="ic ic-check"></i>Full statistics</li><li><i class="ic ic-check"></i>Highlighted in your category</li></ul>
<a class="btn" href="plan-payment.html">Choose plan</a></div>
<div class="plan"><div class="plan__head"><span><span class="plan__name">Pro</span><br><span class="plan__desc">Maximum reach for busy venues</span></span><span class="plan__price"><b>34,990</b><small>HUF / month</small></span></div>
<ul class="feats"><li><i class="ic ic-check"></i>Unlimited active coupons</li><li><i class="ic ic-check"></i>Unlimited giveaways</li><li><i class="ic ic-check"></i>Full statistics</li><li><i class="ic ic-check"></i>Featured on customer Home</li><li><i class="ic ic-check"></i>Priority support</li></ul>
<a class="btn btn--ghost" href="plan-payment.html">Choose plan</a></div>'
page plans.html "Choose a plan" <<EOF
@@SB@@
$(BAR status-approved.html "Choose a plan")
<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 18px">
<p class="sub" style="margin: 0; text-align: center">Pick a plan to publish coupons and reach more guests. You can change it any time.</p>
<div class="billing"><span class="is-on">Monthly</span><span>Yearly <small>−15%</small></span></div>
${PLANS}
<p style="margin: 0; text-align: center; font-size: 11.5px; color: var(--text)">Prices include VAT. Billed to your restaurant, not to guests.</p>
</div>
EOF
page plan-payment.html "Confirm plan" <<EOF
@@SB@@
$(BAR status-approved.html "Choose a plan")
<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 18px">${PLANS}</div>
<div class="scrim"></div>
<div class="bsheet" role="dialog" aria-label="Confirm subscription">
<span class="handle"></span>
<div class="bsheet__head"><h2>Confirm your plan</h2></div>
<div class="cd-list" style="padding: 0 14px">
<div class="sheet-pts"><span>Plan</span><b>Growth · Monthly</b></div>
<div class="sheet-pts"><span>Starts</span><b>Today, 14 Oct 2026</b></div>
<div class="sheet-pts"><span>Renews</span><b>14 Nov 2026</b></div>
<div class="sheet-pts"><span>Total today</span><b>19,990 HUF</b></div>
</div>
<button class="input input--select" type="button" style="height: 54px"><span style="display: inline-flex; align-items: center; gap: 10px; color: var(--navy)"><i class="ic ic-card ic-20"></i>Add payment method</span><i class="ic ic-chevron-right"></i></button>
<p style="margin: 0; font-size: 11.5px; line-height: 17px; color: var(--text)">Renews monthly until cancelled. Payment provider to be confirmed.</p>
<a class="btn" href="dashboard.html">Subscribe · 19,990 HUF</a>
</div>
EOF

# ======================= 41 DASHBOARD =======================
page dashboard.html "Dashboard" <<EOF
@@SB@@
<div class="scroll">
<div class="dhead"><span class="dhead__logo">NR</span><span class="dhead__txt"><small>Good evening</small><b>Trattoria Nonna Rosa</b></span><a class="round" href="notifications.html" aria-label="Notifications"><i class="ic ic-bell"></i><span class="dot"></span></a></div>
<div class="pad" style="margin-top: 18px; display: flex; flex-direction: column; gap: 10px">
<div class="kpis">
<a class="kpi kpi--hero" href="loyalty-activity.html"><span><span class="kpi__label"><i class="ic ic-scan"></i>Redemptions today</span><span class="kpi__val" style="font-size: 34px; line-height: 40px">18</span><span class="kpi__sub">+5 vs. last Tuesday</span></span><span class="btn btn--sm" style="background: var(--coral)">Scan QR</span></a>
<a class="kpi" href="coupons.html"><span class="kpi__label"><i class="ic ic-ticket"></i>Active coupons</span><span class="kpi__val">4</span><span class="kpi__sub">1 ends this week</span></a>
<a class="kpi" href="loyalty.html"><span class="kpi__label"><i class="ic ic-award"></i>Points given</span><span class="kpi__val">720</span><span class="kpi__sub up">This week</span></a>
<a class="kpi" href="giveaways.html"><span class="kpi__label"><i class="ic ic-gift"></i>Giveaway entries</span><span class="kpi__val">1,248</span><span class="kpi__sub">Draw on 15 Oct</span></a>
<a class="kpi" href="statistics.html"><span class="kpi__label"><i class="ic ic-eye"></i>Profile views</span><span class="kpi__val">2,310</span><span class="kpi__sub up">+12% this week</span></a>
</div>
</div>
<div class="sec"><div class="sec__head"><h2>Quick actions</h2></div>
<div class="pad"><div class="qa"><a class="is-main" href="scanner.html"><span><i class="ic ic-scan"></i></span>Scan QR</a><a href="coupon-form.html"><span><i class="ic ic-plus"></i></span>Create coupon</a><a href="giveaway-form.html"><span><i class="ic ic-gift"></i></span>Create giveaway</a></div></div></div>
<div class="sec"><div class="sec__head"><h2>Recent activity</h2><a href="loyalty-activity.html">See all</a></div>
<div class="pad"><div class="feed">
<div class="fi"><span class="fi__icon av-a" style="border-radius: 50%; font-size: 12px; font-weight: 600">AK</span><span class="fi__body"><b>Anna K. redeemed 20% off</b><small>19:42 · +40 points</small></span><span class="st st--ok">Redeemed</span></div>
<div class="fi"><span class="fi__icon av-b" style="border-radius: 50%; font-size: 12px; font-weight: 600">BT</span><span class="fi__body"><b>Bence T. used Free espresso</b><small>18:15 · −150 points</small></span><span class="fi__end">Reward</span></div>
<div class="fi"><span class="fi__icon"><i class="ic ic-gift"></i></span><span class="fi__body"><b>36 new giveaway entries</b><small>Win dinner for two · today</small></span><span class="fi__end">+36</span></div>
</div></div></div>
<div class="sec" style="margin-bottom: 24px"><div class="pad"><a class="subcard" href="subscription.html"><i class="ic ic-award"></i><span class="subcard__body"><b>Growth plan</b><small>Renews 14 Nov 2026 · 4 of 10 coupons used</small></span><span class="link">Manage</span></a></div></div>
</div>
@@NAV_DASH@@
EOF

# ======================= 42 PROFILE MANAGEMENT =======================
PM_BODY='<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div><div class="cover" style="background-image: url(assets/img/interior.jpg)"><a class="cover__edit" href="#"><i class="ic ic-camera"></i>Change cover</a></div>
<div class="pm-head"><span class="pm-logo">NR</span><span><b>Trattoria Nonna Rosa</b><small>Italian · Approved</small></span></div></div>
<div class="complete"><div class="complete__top"><span>Profile completeness</span><span>85%</span></div><div class="bar8"><span style="width: 85%"></span></div><small style="font-size: 12px; color: var(--text)">Add 3 more gallery photos to reach 100%.</small></div>
<div class="sec-card"><div class="sec-card__head"><h3>Basic information</h3><a href="profile-edit.html">Edit</a></div>
<div class="kv"><small>Restaurant name</small><span>Trattoria Nonna Rosa</span></div>
<div class="kv"><small>Category</small><span>Italian · Pasta · Pizza</span></div>
<div class="kv"><small>Description</small><span>Hand-made pasta, a wood-fired oven and a quiet courtyard.</span></div></div>
<div class="sec-card"><div class="sec-card__head"><h3>Location</h3><a href="#">Edit</a></div>
<div class="minimap" style="height: 110px"><svg viewBox="0 0 350 110" preserveAspectRatio="xMidYMid slice" aria-hidden="true"><rect width="350" height="110" fill="#eceee9"/><g stroke="#ffffff" stroke-linecap="round"><path d="M-10 60 L 360 44" stroke-width="12"/><path d="M120 -10 L 100 120" stroke-width="10"/><path d="M260 -10 L 250 120" stroke-width="8"/></g><path d="M175 64c-10-13-18-21-18-31a18 18 0 0 1 36 0c0 10-8 18-18 31z" fill="#fe552e"/><circle cx="175" cy="33" r="6.5" fill="#ffffff"/></svg></div>
<div class="kv"><small>Address</small><span>Fő utca 12, Hungary</span></div></div>
<div class="sec-card"><div class="sec-card__head"><h3>Images</h3><a href="#">Manage</a></div>
<div class="gallery"><span style="background-image: url(assets/img/interior.jpg)"></span><span style="background-image: url(assets/img/pasta.jpg)"></span><span style="background-image: url(assets/img/tiramisu.jpg)"></span><span style="background-image: url(assets/img/terrace.jpg)"></span><button type="button" aria-label="Add photo"><i class="ic ic-plus"></i></button></div></div>
<a class="btn btn--ghost" href="#"><i class="ic ic-eye ic-20"></i>View as customer</a>
</div>'
page profile-manage.html "Restaurant profile" <<EOF
@@SB@@
$(BAR account.html "Restaurant profile")
${PM_BODY}
EOF
page profile-edit.html "Edit basic information" <<EOF
@@SB@@
$(BAR account.html "Restaurant profile")
${PM_BODY}
<div class="scrim"></div>
<div class="bsheet" role="dialog" aria-label="Edit basic information">
<span class="handle"></span>
<div class="bsheet__head"><h2>Basic information</h2><a class="round" href="profile-manage.html" aria-label="Close" style="width: 36px; height: 36px"><i class="ic ic-x"></i></a></div>
<label class="field"><span>Restaurant name</span><span class="input"><input id="rn" value="Trattoria Nonna Rosa"></span></label>
<div class="field"><span>Category</span><button class="input input--select" type="button" style="color: var(--navy)">Italian · Pasta · Pizza<i class="ic ic-chevron-down"></i></button></div>
<label class="field"><span>Description</span><span class="input input--area"><textarea id="desc" rows="3">Hand-made pasta, a wood-fired oven and a quiet courtyard.</textarea></span></label>
<a class="btn" href="profile-manage.html">Save changes</a>
</div>
EOF

# ======================= 43 MENU MANAGEMENT =======================
page menu-manage.html "Menu" <<EOF
@@SB@@
$(BAR account.html "Menu" '<a class="round" href="#" aria-label="Add menu item" style="background: var(--coral); border-color: var(--coral); color: #ffffff"><i class="ic ic-plus"></i></a>')
<div class="chips" style="margin-top: 10px"><button class="chip2 is-on" type="button">Menu items</button><button class="chip2" type="button"><i class="ic ic-file"></i>Photos &amp; PDF</button></div>
<div class="scroll" style="padding: 12px 20px 24px; display: flex; flex-direction: column; gap: 8px">
<div class="cat-head"><h3>Main dishes</h3><small>3 items</small></div>
<div class="card-plain">
<div class="mm-item"><span class="mm-item__img" style="background-image: url(assets/img/pasta.jpg)"></span><span class="mm-item__body"><b>Cacio e pepe</b><small>Tonnarelli, pecorino romano, black pepper</small><span>3,900 HUF</span></span><a class="icon-btn" href="#" aria-label="Edit"><i class="ic ic-edit"></i></a><a class="icon-btn" href="#" aria-label="More"><i class="ic ic-more"></i></a></div>
<div class="mm-item"><span class="mm-item__img" style="background-image: url(assets/img/penne.jpg)"></span><span class="mm-item__body"><b>Penne all’arrabbiata</b><small>Tomato, garlic, chilli, parsley</small><span>3,400 HUF</span></span><a class="icon-btn" href="#" aria-label="Edit"><i class="ic ic-edit"></i></a><a class="icon-btn" href="#" aria-label="More"><i class="ic ic-more"></i></a></div>
<div class="mm-item"><span class="mm-item__img" style="background-image: url(assets/img/pizza.jpg)"></span><span class="mm-item__body"><b>Margherita</b><small>San Marzano, fior di latte, basil</small><span>3,600 HUF</span></span><a class="icon-btn" href="#" aria-label="Edit"><i class="ic ic-edit"></i></a><a class="icon-btn" href="#" aria-label="More"><i class="ic ic-more"></i></a></div>
</div>
<div class="cat-head"><h3>Desserts</h3><small>1 item</small></div>
<div class="card-plain">
<div class="mm-item"><span class="mm-item__img" style="background-image: url(assets/img/tiramisu.jpg)"></span><span class="mm-item__body"><b>Tiramisu della Nonna</b><small>Mascarpone, espresso, cocoa</small><span>1,900 HUF</span></span><a class="icon-btn" href="#" aria-label="Edit"><i class="ic ic-edit"></i></a><a class="icon-btn" href="#" aria-label="More"><i class="ic ic-more"></i></a></div>
</div>
<div class="cat-head"><h3>Drinks</h3><small>1 item</small></div>
<div class="card-plain">
<div class="mm-item"><span class="mm-item__img mm-item__img--none"><i class="ic ic-image"></i></span><span class="mm-item__body"><b>House lemonade</b><small>Lemon, mint, soda</small><span>1,200 HUF</span></span><a class="icon-btn" href="#" aria-label="Edit"><i class="ic ic-edit"></i></a><a class="icon-btn" href="#" aria-label="More"><i class="ic ic-more"></i></a></div>
</div>
<button class="btn btn--ghost" type="button" style="margin-top: 6px"><i class="ic ic-plus ic-20"></i>Add category</button>
<div class="cat-head" style="margin-top: 14px"><h3>Menu photos &amp; PDF</h3><small>Optional</small></div>
<div class="file"><span class="file__thumb file__thumb--pdf">PDF</span><span class="file__body"><b>Full menu, autumn 2026</b><small>PDF · 4 pages · uploaded 1 Oct</small></span><span class="file__acts"><a class="icon-btn" href="#" aria-label="Replace"><i class="ic ic-refresh"></i></a><a class="icon-btn" href="#" aria-label="Delete" style="color: #c2380f"><i class="ic ic-trash"></i></a></span></div>
<div class="file"><span class="file__thumb" style="background-image: url(assets/img/pasta.jpg)"></span><span class="file__body"><b>Menu page 1</b><small>JPG · uploaded 1 Oct</small></span><span class="file__acts"><a class="icon-btn" href="#" aria-label="Replace"><i class="ic ic-refresh"></i></a><a class="icon-btn" href="#" aria-label="Delete" style="color: #c2380f"><i class="ic ic-trash"></i></a></span></div>
<button class="upload" type="button" style="cursor: pointer"><i class="ic ic-upload"></i>Upload menu photos or PDF<small>JPG, PNG or PDF</small></button>
</div>
EOF

# ======================= 44 COUPONS =======================
page coupons.html "Coupons" <<EOF
@@SB@@
$(TOPTITLE "Coupons" '<a class="btn btn--sm" href="coupon-form.html"><i class="ic ic-plus ic-16"></i>Create coupon</a>')
$(TABS "Active · 4|coupons.html|1" "Scheduled · 1|#|" "Expired / inactive|coupons-expired.html|")
<div class="scroll" style="padding: 14px 20px 20px; display: flex; flex-direction: column; gap: 10px">
<a class="mc" href="coupon-detail.html"><span class="mc__top"><span class="mc__val">20%</span><span class="mc__body"><small>Percentage discount</small><b>20% off your whole bill</b><span>1 Oct – 31 Oct · Min. 5,000 HUF</span></span><span class="st st--ok">Active</span></span><span class="mc__stats"><span><b>142</b> redeemed</span><span><b>+40</b> pts each</span><span class="grow"></span><i class="ic ic-chevron-right" style="width: 16px; height: 16px"></i></span></a>
<a class="mc" href="coupon-detail.html"><span class="mc__top"><span class="mc__val"><i class="ic ic-gift"></i></span><span class="mc__body"><small>Gift item</small><b>Free tiramisu with any main</b><span>Until 31 Oct · One per table</span></span><span class="st st--ok">Active</span></span><span class="mc__stats"><span><b>88</b> redeemed</span><span><b>+25</b> pts each</span><span class="grow"></span><i class="ic ic-chevron-right" style="width: 16px; height: 16px"></i></span></a>
<a class="mc" href="coupon-detail.html"><span class="mc__top"><span class="mc__val">1+1</span><span class="mc__body"><small>Buy one, get one</small><b>Second Margherita free</b><span>Weekends · Sat–Sun</span></span><span class="st st--ok">Active</span></span><span class="mc__stats"><span><b>51</b> redeemed</span><span><b>+20</b> pts each</span><span class="grow"></span><i class="ic ic-chevron-right" style="width: 16px; height: 16px"></i></span></a>
<a class="mc" href="coupon-detail.html"><span class="mc__top"><span class="mc__val mc__val--dark"><i class="ic ic-clock"></i></span><span class="mc__body"><small>Happy hour</small><b>Aperol spritz for 1,500 HUF</b><span>Mon–Fri, 16:00–18:00</span></span><span class="st st--ok">Active</span></span><span class="mc__stats"><span><b>36</b> redeemed</span><span><b>+10</b> pts each</span><span class="grow"></span><i class="ic ic-chevron-right" style="width: 16px; height: 16px"></i></span></a>
<p style="margin: 4px 0 0; text-align: center; font-size: 12px; color: var(--text)">4 of 10 active coupons on your Growth plan</p>
</div>
@@NAV_COUPONS@@
EOF
page coupons-expired.html "Coupons · Expired" <<EOF
@@SB@@
$(TOPTITLE "Coupons" '<a class="btn btn--sm" href="coupon-form.html"><i class="ic ic-plus ic-16"></i>Create coupon</a>')
$(TABS "Active · 4|coupons.html|" "Scheduled · 1|#|" "Expired / inactive|coupons-expired.html|1")
<div class="scroll" style="padding: 14px 20px 20px; display: flex; flex-direction: column; gap: 10px">
<div class="mc"><span class="mc__top"><span class="mc__val mc__val--muted">15%</span><span class="mc__body"><small>Seasonal</small><b>Truffle week</b><span>Ended 30 Sep 2026</span></span><span class="st st--off">Expired</span></span><span class="mc__stats"><span><b>64</b> redeemed</span><span class="grow"></span><a class="link" href="coupon-form.html" style="font-size: 12.5px">Reuse</a></span></div>
<div class="mc"><span class="mc__top"><span class="mc__val mc__val--muted"><i class="ic ic-lock"></i></span><span class="mc__body"><small>Secret menu</small><b>Nonna’s off-menu lasagne</b><span>Deactivated 12 Sep 2026</span></span><span class="st st--off">Inactive</span></span><span class="mc__stats"><span><b>19</b> redeemed</span><span class="grow"></span><a class="link" href="coupon-form.html" style="font-size: 12.5px">Activate</a></span></div>
</div>
@@NAV_COUPONS@@
EOF

# ======================= 45 CREATE / EDIT COUPON =======================
page coupon-form.html "Create coupon" <<EOF
@@SB@@
$(BAR coupons.html "Create coupon")
<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div class="fsec"><h3 class="fsec__title"><span>1</span>Coupon type</h3>
<div class="types">
<button class="type is-on" type="button"><i class="ic ic-percent"></i>Percentage</button><button class="type" type="button"><i class="ic ic-ticket"></i>Fixed value</button>
<button class="type" type="button"><i class="ic ic-gift"></i>Gift item</button><button class="type" type="button"><i class="ic ic-plus"></i>1+1</button>
<button class="type" type="button"><i class="ic ic-utensils"></i>Menu deal</button><button class="type" type="button"><i class="ic ic-zap"></i>Flash sale</button>
<button class="type" type="button"><i class="ic ic-calendar"></i>Seasonal</button><button class="type" type="button"><i class="ic ic-user"></i>First-time</button>
<button class="type" type="button"><i class="ic ic-clock"></i>Happy hour</button><button class="type" type="button"><i class="ic ic-lock"></i>Secret menu</button>
</div></div>
<div class="fsec"><h3 class="fsec__title"><span>2</span>Details</h3>
<label class="field"><span>Coupon title</span><span class="input"><input id="ct" value="20% off your whole bill"></span></label>
<label class="field"><span>Description</span><span class="input input--area"><textarea id="cd" rows="2">Get 20% off the food on your bill when you dine in.</textarea></span></label>
<label class="field"><span>Discount</span><span class="input"><input id="cv" value="20"><span class="suffix">%</span></span></label>
</div>
<div class="fsec"><h3 class="fsec__title"><span>3</span>Validity</h3>
<div class="two"><div class="field"><span>Start date</span><button class="input input--select" type="button" style="color: var(--navy)">1 Oct 2026<i class="ic ic-calendar"></i></button></div><div class="field"><span>End date</span><button class="input input--select" type="button" style="color: var(--navy)">31 Oct 2026<i class="ic ic-calendar"></i></button></div></div>
<div class="field"><span>Available days</span><div class="days"><span class="is-on">M</span><span class="is-on">T</span><span class="is-on">W</span><span class="is-on">T</span><span class="is-on">F</span><span class="is-on">S</span><span class="is-on">S</span></div></div>
<div class="two"><div class="field"><span>From</span><button class="input input--select" type="button" style="color: var(--navy)">12:00<i class="ic ic-clock"></i></button></div><div class="field"><span>Until</span><button class="input input--select" type="button" style="color: var(--navy)">22:00<i class="ic ic-clock"></i></button></div></div>
</div>
<div class="fsec"><h3 class="fsec__title"><span>4</span>Rules</h3>
<label class="field"><span>Minimum purchase</span><span class="input"><input id="cm" value="5,000"><span class="suffix">HUF</span></span></label>
<div class="toggle-row"><span><b>Uses per customer</b><small>How often one guest can redeem it</small></span><div class="stepper"><button type="button" aria-label="Fewer"><i class="ic ic-minus"></i></button><span>1</span><button type="button" aria-label="More"><i class="ic ic-plus"></i></button></div></div>
<div class="toggle-row"><span><b>Total redemptions</b><small>Leave unlimited or set a cap</small></span><span class="row__value">Unlimited</span></div>
<div class="toggle-row"><span><b>First-time guests only</b></span><span class="switch switch--off" role="switch" aria-checked="false"></span></div>
<label class="field"><span>Terms and conditions</span><span class="input input--area"><textarea id="tc" rows="3">Dine-in only. Cannot be combined with other coupons. Drinks not included.</textarea></span></label>
</div>
<div class="fsec"><h3 class="fsec__title"><span>5</span>Loyalty</h3>
<div class="toggle-row"><span><b>Points after redemption</b><small>Earned at Trattoria Nonna Rosa only</small></span><div class="stepper"><button type="button" aria-label="Fewer points"><i class="ic ic-minus"></i></button><span>40</span><button type="button" aria-label="More points"><i class="ic ic-plus"></i></button></div></div>
</div>
<div class="fsec"><h3 class="fsec__title"><span>6</span>Status &amp; preview</h3>
<div class="toggle-row"><span><b>Publish as active</b><small>Guests can see it right away</small></span><span class="switch" role="switch" aria-checked="true"></span></div>
<span class="preview-label">Customer preview</span>
<div class="tk" style="border-color: var(--line)"><span class="tk__val"><b>20%</b><small>Off</small></span><span class="tk__body"><span class="tk__type">Discount</span><span class="tk__title">20% off your whole bill</span><span class="tk__req">Minimum spend 5,000 HUF</span><span class="tk__foot"><span>Trattoria Nonna Rosa</span><span>Until 31 Oct</span></span></span></div>
</div>
</div>
<div class="stickycta"><a class="btn" href="coupon-detail.html">Publish coupon</a></div>
EOF

# ======================= 46 COUPON DETAILS / PERFORMANCE =======================
page coupon-detail.html "Coupon performance" <<EOF
@@SB@@
$(BAR coupons.html "20% off your bill" '<a class="round" href="coupon-form.html" aria-label="Edit"><i class="ic ic-edit"></i></a>')
<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div class="cd-card" style="padding-bottom: 18px"><span class="cd-card__type"><i class="ic ic-percent"></i>Percentage discount</span><p class="cd-card__val" style="font-size: 44px; line-height: 48px">20% OFF</p><div class="cd-card__perf"></div><h1 class="cd-card__title">20% off your whole bill</h1><div class="cd-card__rest">Active · 1 Oct – 31 Oct 2026</div></div>
<div class="statgrid">
<div class="stat2"><small>Views</small><b>3,480</b><span class="delta up"><i class="ic ic-trend-up"></i>+18%</span></div>
<div class="stat2"><small>Redemptions</small><b>142</b><span class="delta up"><i class="ic ic-trend-up"></i>+9%</span></div>
<div class="stat2"><small>Redemption rate</small><b>4.1%</b><span class="delta" style="color: var(--text)">of views</span></div>
<div class="stat2"><small>Repeat guests</small><b>38</b><span class="delta" style="color: var(--text)">used it twice+</span></div>
</div>
<div class="sec-card"><div class="sec-card__head"><h3>Rules</h3><a href="coupon-form.html">Edit</a></div>
<div class="inforow" style="padding: 4px 0"><i class="ic ic-ticket"></i><span>Minimum spend 5,000 HUF</span></div>
<div class="inforow" style="padding: 4px 0"><i class="ic ic-clock"></i><span>Mon–Sun, 12:00–22:00</span></div>
<div class="inforow" style="padding: 4px 0"><i class="ic ic-user"></i><span>Once per customer</span></div>
<div class="inforow" style="padding: 4px 0; border: 0"><i class="ic ic-award" style="color: var(--coral)"></i><span>+40 loyalty points</span></div></div>
<h3 class="subhead">Recent redemptions</h3>
<div class="feed">
<div class="fi"><span class="fi__icon av-a" style="border-radius: 50%; font-size: 12px; font-weight: 600">AK</span><span class="fi__body"><b>Anna K.</b><small>Today, 19:42</small></span><span class="fi__end" style="color: var(--coral)">+40 pts</span></div>
<div class="fi"><span class="fi__icon av-c" style="border-radius: 50%; font-size: 12px; font-weight: 600">ZS</span><span class="fi__body"><b>Zsófia B.</b><small>Today, 13:05</small></span><span class="fi__end" style="color: var(--coral)">+40 pts</span></div>
<div class="fi"><span class="fi__icon av-d" style="border-radius: 50%; font-size: 12px; font-weight: 600">DM</span><span class="fi__body"><b>Dávid M.</b><small>Yesterday, 20:31</small></span><span class="fi__end" style="color: var(--coral)">+40 pts</span></div>
</div>
<button class="btn btn--ghost" type="button" style="color: #c2380f"><i class="ic ic-pause ic-20"></i>Deactivate coupon</button>
</div>
EOF

# ======================= 47 QR SCANNER =======================
SCANBASE='<span class="cam" style="background-image: url(assets/img/dining.jpg)"></span><span class="cam-dim"></span>
<div class="scan-top"><a class="round round--dark" href="dashboard.html" aria-label="Close"><i class="ic ic-x"></i></a><b>Scan coupon</b><a class="round round--dark" href="#" aria-label="Flash"><i class="ic ic-zap"></i></a></div>'
page scanner.html "QR scanner" <<EOF
@@SBW@@
${SCANBASE}
<div class="sframe"><i class="c c1"></i><i class="c c2"></i><i class="c c3"></i><i class="c c4"></i>@@QRGHOST@@<span class="line"></span></div>
<div class="scan-msg"><b>Scan the customer’s Rivjuuu QR code</b><span>Check the order meets the coupon conditions before scanning.</span></div>
<div class="scan-bottom"><a href="#"><span><i class="ic ic-zap"></i></span>Flash</a><a href="scan-valid.html"><span><i class="ic ic-ticket"></i></span>Enter code</a></div>
EOF
page scanner-validating.html "Validating" <<EOF
@@SBW@@
${SCANBASE}
<div class="sframe"><i class="c c1" style="border-color: #49d17d"></i><i class="c c2" style="border-color: #49d17d"></i><i class="c c3" style="border-color: #49d17d"></i><i class="c c4" style="border-color: #49d17d"></i>@@QRGHOST@@</div>
<span class="validating"><span class="spin2"></span>Checking coupon…</span>
<div class="scan-msg"><b>QR code detected</b><span>Hold still for a moment.</span></div>
EOF

# ======================= 48 QR VALIDATION RESULT =======================
page scan-valid.html "Valid coupon" <<EOF
@@SB@@
$(BAR scanner.html "Scan result")
<div class="scroll" style="padding: 6px 24px 10px; display: flex; flex-direction: column; align-items: center; gap: 14px; text-align: center">
<span class="res__icon" style="background: #e6f4ea; width: 96px; height: 96px; border-radius: 50%; display: grid; place-items: center"><span style="width: 60px; height: 60px; border-radius: 50%; background: #2e9e5b; color: #ffffff; display: grid; place-items: center"><i class="ic ic-check" style="width: 30px; height: 30px"></i></span></span>
<h1 style="margin: 0; font-size: 23px; line-height: 30px">Valid coupon</h1>
<div class="cust"><span class="av-sm av-a">AK</span><span class="person__body"><b>Anna K.</b><small>First visit with this coupon</small></span></div>
<div class="res__rows" style="margin-top: 0">
<div class="res__row"><span>Coupon</span><span>20% off your whole bill</span></div>
<div class="res__row"><span>Minimum spend</span><span>5,000 HUF</span></div>
<div class="res__row"><span>Valid</span><span>Until 31 Oct, 12:00–22:00</span></div>
<div class="res__row"><span>Points to award</span><span class="pts">+40 points</span></div>
</div>
<div class="check-list"><b>Before you confirm</b><div><i class="ic ic-check-circle"></i>The order meets the minimum spend</div><div><i class="ic ic-check-circle"></i>Dine-in only, drinks not included</div></div>
</div>
<div class="bottom"><a class="btn" href="scan-success.html">Confirm redemption</a><a class="btn btn--ghost" href="scanner.html">Cancel</a></div>
EOF
page scan-success.html "Redemption confirmed" <<EOF
@@SB@@
<div class="res res--ok">
<span class="res__icon"><span><i class="ic ic-check"></i></span></span>
<h1>Coupon redeemed</h1>
<p>The guest’s coupon is used and their points are added.</p>
<div class="res__rows">
<div class="res__row"><span>Guest</span><span>Anna K.</span></div>
<div class="res__row"><span>Coupon</span><span>20% off your whole bill</span></div>
<div class="res__row"><span>Time</span><span>14 Oct 2026, 19:42</span></div>
<div class="res__row"><span>Points awarded</span><span class="pts">+40 points</span></div>
</div>
</div>
<div class="bottom"><a class="btn" href="scanner.html"><i class="ic ic-scan ic-20"></i>Scan next</a><a class="btn btn--ghost" href="dashboard.html">Done</a></div>
EOF
page scan-invalid.html "Invalid code" <<EOF
@@SB@@
<div class="res res--bad">
<span class="res__icon"><span><i class="ic ic-error"></i></span></span>
<h1>Code not recognised</h1>
<p>This isn’t a valid Rivjuuu coupon for your restaurant. Nothing was redeemed. Ask the guest to open the coupon again.</p>
</div>
<div class="bottom"><a class="btn" href="scanner.html"><i class="ic ic-scan ic-20"></i>Scan again</a><a class="btn btn--ghost" href="dashboard.html">Close</a></div>
EOF

# ======================= 49 LOYALTY MANAGEMENT =======================
page loyalty.html "Loyalty" <<EOF
@@SB@@
$(BAR account.html "Loyalty" '<a class="round" href="reward-form.html" aria-label="Add reward" style="background: var(--coral); border-color: var(--coral); color: #ffffff"><i class="ic ic-plus"></i></a>')
<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div class="kpis">
<div class="kpi"><span class="kpi__label"><i class="ic ic-award"></i>Points awarded</span><span class="kpi__val">12,480</span><span class="kpi__sub">Last 30 days</span></div>
<div class="kpi"><span class="kpi__label"><i class="ic ic-gift"></i>Points redeemed</span><span class="kpi__val">4,350</span><span class="kpi__sub">29 rewards used</span></div>
</div>
<div class="sec-card"><div class="sec-card__head"><h3>Earning rules</h3><a href="#">Edit</a></div>
<div class="inforow" style="padding: 4px 0"><i class="ic ic-ticket"></i><span>Points are set per coupon<small>e.g. 20% off = +40 points</small></span></div>
<div class="inforow" style="padding: 4px 0; border: 0"><i class="ic ic-store"></i><span>Points can only be used at Trattoria Nonna Rosa</span></div></div>
<div class="cat-head"><h3>Rewards</h3><a class="link" href="reward-form.html" style="font-size: 13px">Add reward</a></div>
<div class="reward"><span class="reward__img" style="background-image: url(assets/img/coffee.jpg)"></span><span class="reward__body"><b>Free espresso</b><small>150 points · 21 redeemed</small></span><span class="st st--ok">Active</span><a class="icon-btn" href="reward-form.html" aria-label="Edit"><i class="ic ic-edit"></i></a></div>
<div class="reward"><span class="reward__img" style="background-image: url(assets/img/tiramisu.jpg)"></span><span class="reward__body"><b>Free dessert</b><small>400 points · 8 redeemed</small></span><span class="st st--ok">Active</span><a class="icon-btn" href="reward-form.html" aria-label="Edit"><i class="ic ic-edit"></i></a></div>
<div class="reward"><span class="reward__img" style="background-image: url(assets/img/table.jpg)"></span><span class="reward__body"><b>10% bonus on your bill</b><small>700 points · 0 redeemed</small></span><span class="st st--off">Paused</span><a class="icon-btn" href="reward-form.html" aria-label="Edit"><i class="ic ic-edit"></i></a></div>
<a class="btn btn--ghost" href="loyalty-activity.html"><i class="ic ic-activity ic-20"></i>View loyalty activity</a>
</div>
EOF

# ======================= 50 ADD / EDIT REWARD =======================
page reward-form.html "Add reward" <<EOF
@@SB@@
$(BAR loyalty.html "Add reward")
<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div class="fsec">
<label class="field"><span>Reward title</span><span class="input"><input id="rt" value="Free dessert"></span></label>
<label class="field"><span>Description</span><span class="input input--area"><textarea id="rd" rows="2">Any dessert from the menu, dine-in only.</textarea></span></label>
<div class="toggle-row"><span><b>Points required</b><small>Guests collect these at your restaurant</small></span><div class="stepper"><button type="button" aria-label="Fewer"><i class="ic ic-minus"></i></button><span>400</span><button type="button" aria-label="More"><i class="ic ic-plus"></i></button></div></div>
<div class="field"><span>Valid until <small style="color: var(--text); font-weight: 400">(optional)</small></span><button class="input input--select" type="button">No end date<i class="ic ic-calendar"></i></button></div>
<div class="toggle-row"><span><b>Active</b><small>Visible to guests in your Loyalty tab</small></span><span class="switch" role="switch" aria-checked="true"></span></div>
</div>
<span class="preview-label">Customer preview</span>
<div class="reward"><span class="reward__img" style="background-image: url(assets/img/tiramisu.jpg)"></span><span class="reward__body"><b>Free dessert</b><small>400 points</small></span><span class="btn btn--sm">Redeem</span></div>
</div>
<div class="stickycta"><a class="btn" href="loyalty.html">Add reward</a></div>
EOF

# ======================= 51 LOYALTY ACTIVITY =======================
page loyalty-activity.html "Loyalty activity" <<EOF
@@SB@@
$(TOPTITLE "Activity")
<div class="scroll" style="padding: 8px 20px 20px; display: flex; flex-direction: column; gap: 12px">
<div class="statgrid" style="grid-template-columns: repeat(3, minmax(0, 1fr))">
<div class="stat2"><small>Earned</small><b style="font-size: 20px">12,480</b></div>
<div class="stat2"><small>Redeemed</small><b style="font-size: 20px">4,350</b></div>
<div class="stat2"><small>Rewards</small><b style="font-size: 20px">29</b></div>
</div>
<div style="display: flex; gap: 8px"><button class="chip2 is-on" type="button">All</button><button class="chip2" type="button">Earned</button><button class="chip2" type="button">Redeemed</button></div>
<div class="feed">
<div class="fi"><span class="fi__icon av-a" style="border-radius: 50%; font-size: 12px; font-weight: 600">AK</span><span class="fi__body"><b>Anna K.</b><small>20% off coupon · Today 19:42</small></span><span class="fi__end" style="color: #1f7a45">+40</span></div>
<div class="fi"><span class="fi__icon av-b" style="border-radius: 50%; font-size: 12px; font-weight: 600">BT</span><span class="fi__body"><b>Bence T.</b><small>Reward · Free espresso · Today 18:15</small></span><span class="fi__end">−150</span></div>
<div class="fi"><span class="fi__icon av-c" style="border-radius: 50%; font-size: 12px; font-weight: 600">ZS</span><span class="fi__body"><b>Zsófia B.</b><small>Free tiramisu coupon · Today 13:05</small></span><span class="fi__end" style="color: #1f7a45">+25</span></div>
<div class="fi"><span class="fi__icon av-d" style="border-radius: 50%; font-size: 12px; font-weight: 600">DM</span><span class="fi__body"><b>Dávid M.</b><small>1+1 pizza coupon · Yesterday</small></span><span class="fi__end" style="color: #1f7a45">+20</span></div>
<div class="fi"><span class="fi__icon av-a" style="border-radius: 50%; font-size: 12px; font-weight: 600">LK</span><span class="fi__body"><b>Lilla K.</b><small>Reward · Free dessert · Yesterday</small></span><span class="fi__end">−400</span></div>
<div class="fi"><span class="fi__icon" style="border-radius: 50%"><i class="ic ic-user"></i></span><span class="fi__body"><b>Guest</b><small>Happy hour coupon · Yesterday</small></span><span class="fi__end" style="color: #1f7a45">+10</span></div>
</div>
</div>
@@NAV_ACTIVITY@@
EOF

# ======================= 52 GIVEAWAYS =======================
page giveaways.html "Giveaways" <<EOF
@@SB@@
$(BAR account.html "Giveaways" '<a class="round" href="giveaway-form.html" aria-label="Create giveaway" style="background: var(--coral); border-color: var(--coral); color: #ffffff"><i class="ic ic-plus"></i></a>')
$(TABS "Active · 1|giveaways.html|1" "Scheduled · 1|#|" "Completed · 4|#|")
<div class="scroll" style="padding: 14px 20px 20px; display: flex; flex-direction: column; gap: 12px">
<a class="gm" href="giveaway-detail.html"><span class="gm__img" style="background-image: url(assets/img/table.jpg)"><span class="st st--orange">Active</span></span><span class="gm__body"><b>Win dinner for two</b><span class="gc__prize"><i class="ic ic-gift"></i>15,000 HUF dinner coupon</span><span class="gm__meta"><span><i class="ic ic-calendar"></i>1–14 Oct</span><span><i class="ic ic-users"></i>1,248 joined</span><span><i class="ic ic-trophy"></i>3 winners</span></span></span></a>
<a class="btn btn--ghost" href="giveaway-form.html"><i class="ic ic-plus ic-20"></i>Create giveaway</a>
</div>
EOF

# ======================= 53 CREATE / EDIT GIVEAWAY =======================
page giveaway-form.html "Create giveaway" <<EOF
@@SB@@
$(BAR giveaways.html "Create giveaway")
<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div class="fsec"><h3 class="fsec__title"><span>1</span>Basics</h3>
<div class="upload-hero" style="background-image: url(assets/img/table.jpg)"><span><i class="ic ic-camera"></i>Change image</span></div>
<label class="field"><span>Giveaway title</span><span class="input"><input id="gt" value="Win dinner for two"></span></label>
<label class="field"><span>Description</span><span class="input input--area"><textarea id="gd" rows="2">Celebrate autumn at Nonna Rosa. Three winners get a dinner for two.</textarea></span></label>
</div>
<div class="fsec"><h3 class="fsec__title"><span>2</span>Prize</h3>
<label class="field"><span>Prize</span><span class="input"><input id="gp" value="15,000 HUF dinner coupon"></span></label>
<div class="field"><span>Winners receive</span><button class="input input--select" type="button" style="color: var(--navy)">Prize coupon · valid 30 days<i class="ic ic-chevron-down"></i></button></div>
</div>
<div class="fsec"><h3 class="fsec__title"><span>3</span>Rules</h3>
<label class="field"><span>Eligibility and rules</span><span class="input input--area"><textarea id="gr" rows="3">Free to join, one entry per customer. Customers aged 18+. Staff can’t take part.</textarea></span></label>
</div>
<div class="fsec"><h3 class="fsec__title"><span>4</span>Timing &amp; winners</h3>
<div class="two"><div class="field"><span>Start date</span><button class="input input--select" type="button" style="color: var(--navy)">1 Oct 2026<i class="ic ic-calendar"></i></button></div><div class="field"><span>End date</span><button class="input input--select" type="button" style="color: var(--navy)">14 Oct 2026<i class="ic ic-calendar"></i></button></div></div>
<div class="toggle-row"><span><b>Number of winners</b></span><div class="stepper"><button type="button" aria-label="Fewer"><i class="ic ic-minus"></i></button><span>3</span><button type="button" aria-label="More"><i class="ic ic-plus"></i></button></div></div>
</div>
</div>
<div class="stickycta"><a class="btn" href="giveaway-detail.html">Publish giveaway</a></div>
EOF

# ======================= 54 GIVEAWAY DETAILS =======================
GD_TOP='<div class="gd-hero" style="background-image: url(assets/img/table.jpg); height: 220px"><div class="hero__bar"><a class="round round--photo" href="giveaways.html" aria-label="Back"><i class="ic ic-arrow-left"></i></a><div><a class="round round--photo" href="giveaway-form.html" aria-label="Edit"><i class="ic ic-edit"></i></a></div></div></div>
<div class="sheet-top" style="padding-bottom: 6px"><div style="display: flex; justify-content: space-between; align-items: center"><h1 class="rd__name" style="padding-right: 0; font-size: 22px">Win dinner for two</h1><span class="st st--orange">Active</span></div>
<div class="facts" style="margin-top: 12px"><div class="fact"><small>Entries</small><b>1,248</b></div><div class="fact"><small>Winners</small><b>3</b></div><div class="fact"><small>Ends</small><b>14 Oct</b></div></div></div>'
page giveaway-detail.html "Giveaway details" <<EOF
@@SBW@@
<div class="scroll">
${GD_TOP}
$(TABS "Overview|giveaway-detail.html|1" "Participants|giveaway-participants.html|" "Winners|giveaway-winners.html|")
<div class="tabbody">
<div class="prize"><i class="ic ic-gift"></i><span><b>15,000 HUF dinner coupon</b><small>Prize coupon valid for 30 days</small></span></div>
<div class="sec-card"><div class="sec-card__head"><h3>Rules</h3></div><ul class="rules"><li>Free to join, one entry per customer.</li><li>Customers aged 18+. Staff can’t take part.</li><li>Winners drawn at random after 14 Oct.</li></ul></div>
<div class="sec-card"><div class="kv"><small>Runs</small><span>1 Oct – 14 Oct 2026</span></div></div>
<a class="btn" href="giveaway-draw.html"><i class="ic ic-shuffle ic-20"></i>Draw winners</a>
<button class="btn btn--ghost" type="button" style="color: #c2380f">End giveaway early</button>
</div>
</div>
EOF
page giveaway-participants.html "Giveaway participants" <<EOF
@@SBW@@
<div class="scroll">
${GD_TOP}
$(TABS "Overview|giveaway-detail.html|" "Participants|giveaway-participants.html|1" "Winners|giveaway-winners.html|")
<div class="tabbody">
<p style="margin: 0; font-size: 12.5px; color: var(--text)">1,248 participants · newest first</p>
<div class="card-plain">
<div class="person"><span class="av-sm av-a">AK</span><span class="person__body"><b>Anna K.</b><small>Joined today, 19:50</small></span></div>
<div class="person"><span class="av-sm av-b">PN</span><span class="person__body"><b>Péter N.</b><small>Joined today, 18:02</small></span></div>
<div class="person"><span class="av-sm av-c">EF</span><span class="person__body"><b>Eszter F.</b><small>Joined today, 12:44</small></span></div>
<div class="person"><span class="av-sm av-d">DM</span><span class="person__body"><b>Dávid M.</b><small>Joined yesterday</small></span></div>
</div>
</div>
</div>
EOF
page giveaway-draw.html "Draw winners" <<EOF
@@SBW@@
<div class="scroll" style="overflow: hidden">
${GD_TOP}
</div>
<div class="scrim"></div>
<div class="bsheet" role="dialog" aria-label="Draw winners">
<span class="handle"></span>
<div class="bsheet__head"><h2>Draw 3 winners?</h2></div>
<p style="margin: -4px 0 0; font-size: 13.5px; line-height: 20px; color: var(--text)">Winners are picked at random from 1,248 participants. Each winner gets the prize coupon and a notification. This can’t be undone.</p>
<div class="hint"><i class="ic ic-info"></i><span>The giveaway closes when you draw. New entries won’t be accepted.</span></div>
<a class="btn" href="giveaway-winners.html"><i class="ic ic-shuffle ic-20"></i>Draw winners</a>
<a class="btn btn--ghost" href="giveaway-detail.html">Cancel</a>
</div>
EOF
page giveaway-winners.html "Giveaway winners" <<EOF
@@SBW@@
<div class="scroll">
${GD_TOP}
$(TABS "Overview|giveaway-detail.html|" "Participants|giveaway-participants.html|" "Winners|giveaway-winners.html|1")
<div class="tabbody">
<div class="toast-ok" style="position: static; box-shadow: none"><i class="ic ic-check-circle"></i><span>3 winners drawn. Prize coupons have been sent.</span></div>
<div class="card-plain">
<div class="winner"><span class="winner__n">1</span><span class="av-sm av-c">EF</span><span class="person__body"><b>Eszter F.</b><small>Prize coupon awarded</small></span><span class="st st--ok">Sent</span></div>
<div class="winner"><span class="winner__n">2</span><span class="av-sm av-a">AK</span><span class="person__body"><b>Anna K.</b><small>Prize coupon awarded</small></span><span class="st st--ok">Sent</span></div>
<div class="winner"><span class="winner__n">3</span><span class="av-sm av-d">DM</span><span class="person__body"><b>Dávid M.</b><small>Prize coupon awarded</small></span><span class="st st--ok">Sent</span></div>
</div>
</div>
</div>
EOF

# ======================= 55 STATISTICS =======================
page statistics.html "Statistics" <<EOF
@@SB@@
$(BAR account.html "Statistics")
<div class="chips" style="margin-top: 8px"><button class="chip2" type="button">7 days</button><button class="chip2 is-on" type="button">30 days</button><button class="chip2" type="button"><i class="ic ic-calendar"></i>Custom</button></div>
<div class="scroll" style="padding: 14px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div class="statgrid">
<div class="stat2"><small>Profile views</small><b>9,840</b><span class="delta up"><i class="ic ic-trend-up"></i>+12%</span></div>
<div class="stat2"><small>Redemptions</small><b>317</b><span class="delta up"><i class="ic ic-trend-up"></i>+9%</span></div>
<div class="stat2"><small>Repeat customers</small><b>37%</b><span class="delta down"><i class="ic ic-trend-up" style="transform: scaleY(-1)"></i>−2 pts</span></div>
<div class="stat2"><small>Points earned / used</small><b style="font-size: 20px">12.5k / 4.4k</b><span class="delta" style="color: var(--text)">loyalty</span></div>
</div>
<div class="chart"><div class="chart__head"><b>Redemptions</b><small>Last 4 weeks</small></div>
<svg viewBox="0 0 320 150" role="img" aria-label="Weekly redemptions: 58, 71, 84, 104">
<line x1="0" y1="20" x2="320" y2="20" stroke="#ece4d6"/><line x1="0" y1="70" x2="320" y2="70" stroke="#ece4d6"/><line x1="0" y1="120" x2="320" y2="120" stroke="#d8cfbf"/>
<text class="axis" x="320" y="14" text-anchor="end">120</text><text class="axis" x="320" y="64" text-anchor="end">60</text>
<rect x="22" y="62" width="44" height="58" rx="8" fill="#f8d9cf"/><rect x="102" y="49" width="44" height="71" rx="8" fill="#f8d9cf"/><rect x="182" y="36" width="44" height="84" rx="8" fill="#f8d9cf"/><rect x="262" y="16" width="44" height="104" rx="8" fill="#fe552e"/>
<text class="axis" x="44" y="56" text-anchor="middle">58</text><text class="axis" x="124" y="43" text-anchor="middle">71</text><text class="axis" x="204" y="30" text-anchor="middle">84</text><text class="axis" x="284" y="11" text-anchor="middle" style="fill: #18181b; font-weight: 700">104</text>
<text class="axis" x="44" y="140" text-anchor="middle">16 Sep</text><text class="axis" x="124" y="140" text-anchor="middle">23 Sep</text><text class="axis" x="204" y="140" text-anchor="middle">30 Sep</text><text class="axis" x="284" y="140" text-anchor="middle">7 Oct</text>
</svg></div>
<div class="sec-card"><div class="sec-card__head"><h3>Coupon performance</h3><small style="font-size: 12px; color: var(--text)">Redemptions</small></div>
<div class="rank"><span class="rank__n">1</span><span class="rank__body"><b>20% off your whole bill</b><span class="bar8"><span style="width: 100%"></span></span></span><span class="rank__end">142<small>4.1% rate</small></span></div>
<div class="rank"><span class="rank__n">2</span><span class="rank__body"><b>Free tiramisu with any main</b><span class="bar8"><span style="width: 62%"></span></span></span><span class="rank__end">88<small>3.2% rate</small></span></div>
<div class="rank"><span class="rank__n">3</span><span class="rank__body"><b>Second Margherita free</b><span class="bar8"><span style="width: 36%"></span></span></span><span class="rank__end">51<small>2.7% rate</small></span></div>
<div class="rank"><span class="rank__n">4</span><span class="rank__body"><b>Aperol spritz for 1,500 HUF</b><span class="bar8"><span style="width: 25%"></span></span></span><span class="rank__end">36<small>1.9% rate</small></span></div>
</div>
</div>
EOF

# ======================= 56 ACCOUNT =======================
page account.html "Profile" <<EOF
@@SB@@
$(TOPTITLE "Profile" '<a class="round" href="notifications.html" aria-label="Notifications"><i class="ic ic-bell"></i><span class="dot"></span></a>')
<div class="scroll" style="padding: 8px 0 20px">
<div class="me-head"><span class="pm-logo" style="border-color: #ffffff; width: 68px; height: 68px">NR</span><span><b>Trattoria Nonna Rosa</b><small><span class="st st--ok" style="height: 20px; font-size: 10.5px">Approved</span> · Growth plan</small></span></div>
<div class="group"><h2>Restaurant</h2><div class="rows">
<a class="row" href="profile-manage.html"><span class="row__icon"><i class="ic ic-store"></i></span><span class="row__label">Restaurant profile</span><span class="row__value">85%</span><i class="ic ic-chevron-right"></i></a>
<a class="row" href="menu-manage.html"><span class="row__icon"><i class="ic ic-book"></i></span><span class="row__label">Menu</span><i class="ic ic-chevron-right"></i></a>
</div></div>
<div class="group"><h2>Business</h2><div class="rows">
<a class="row" href="subscription.html"><span class="row__icon"><i class="ic ic-card"></i></span><span class="row__label">Subscription</span><span class="row__value">Growth</span><i class="ic ic-chevron-right"></i></a>
<a class="row" href="statistics.html"><span class="row__icon"><i class="ic ic-bars"></i></span><span class="row__label">Statistics</span><i class="ic ic-chevron-right"></i></a>
</div></div>
<div class="group"><h2>Engagement</h2><div class="rows">
<a class="row" href="loyalty.html"><span class="row__icon"><i class="ic ic-award"></i></span><span class="row__label">Loyalty</span><i class="ic ic-chevron-right"></i></a>
<a class="row" href="giveaways.html"><span class="row__icon"><i class="ic ic-gift"></i></span><span class="row__label">Giveaways</span><span class="row__value">1 active</span><i class="ic ic-chevron-right"></i></a>
</div></div>
<div class="group"><h2>Account</h2><div class="rows">
<a class="row" href="notifications.html"><span class="row__icon"><i class="ic ic-bell"></i></span><span class="row__label">Notifications</span><i class="ic ic-chevron-right"></i></a>
<a class="row" href="settings.html"><span class="row__icon"><i class="ic ic-settings"></i></span><span class="row__label">Settings</span><i class="ic ic-chevron-right"></i></a>
</div></div>
</div>
@@NAV_PROFILE@@
EOF

# ======================= 57 SUBSCRIPTION MANAGEMENT =======================
SUB_BODY='<div class="scroll" style="padding: 10px 20px 24px; display: flex; flex-direction: column; gap: 12px">
<div class="loy" style="gap: 12px">
<div style="display: flex; justify-content: space-between; align-items: center"><span style="font-size: 12px; color: rgba(255,255,255,.72)">Current plan</span><span class="st st--ok" style="background: rgba(73,209,125,.18); color: #7be3a3">Active</span></div>
<div style="display: flex; justify-content: space-between; align-items: baseline"><b style="font-size: 26px; line-height: 32px">Growth</b><span><b style="font-size: 20px">19,990</b> <small style="color: rgba(255,255,255,.72)">HUF / month</small></span></div>
<div class="loy__bar"><span style="width: 40%"></span></div>
<div class="loy__next">4 of 10 active coupons used · Renews <b>14 Nov 2026</b></div>
</div>
<div class="sec-card"><div class="sec-card__head"><h3>Included</h3></div><ul class="feats"><li><i class="ic ic-check"></i>Up to 10 active coupons</li><li><i class="ic ic-check"></i>2 giveaways per month</li><li><i class="ic ic-check"></i>Highlighted in your category</li><li><i class="ic ic-check"></i>Full statistics</li></ul></div>
<div class="sec-card"><div class="sec-card__head"><h3>Billing</h3><a href="#">Update</a></div>
<div class="inforow" style="padding: 4px 0"><i class="ic ic-card"></i><span>Payment method<small>[Payment method on file]</small></span></div>
<div class="inforow" style="padding: 4px 0; border: 0"><i class="ic ic-file"></i><span>Last payment 14 Oct 2026<small>19,990 HUF · Invoice available</small></span></div></div>
<a class="btn" href="subscription-change.html">Change plan</a>
<button class="btn btn--ghost" type="button" style="color: #c2380f">Cancel subscription</button>
</div>'
page subscription.html "Subscription" <<EOF
@@SB@@
$(BAR account.html "Subscription")
${SUB_BODY}
EOF
page subscription-change.html "Change plan" <<EOF
@@SB@@
$(BAR account.html "Subscription")
${SUB_BODY}
<div class="scrim"></div>
<div class="bsheet" role="dialog" aria-label="Change plan">
<span class="handle"></span>
<div class="bsheet__head"><h2>Change plan</h2><a class="round" href="subscription.html" aria-label="Close" style="width: 36px; height: 36px"><i class="ic ic-x"></i></a></div>
<div class="vis"><span class="vis__body"><b>Starter · 9,990 HUF</b><small>3 coupons · no giveaways</small></span><span class="radio"></span></div>
<div class="vis is-on"><span class="vis__body"><b>Growth · 19,990 HUF</b><small>Current plan · 10 coupons · 2 giveaways</small></span><span class="radio is-on"><i class="ic ic-check"></i></span></div>
<div class="vis"><span class="vis__body"><b>Pro · 34,990 HUF</b><small>Unlimited coupons · featured on Home</small></span><span class="radio"></span></div>
<p style="margin: 0; font-size: 11.5px; line-height: 17px; color: var(--text)">Changes apply from your next billing date unless the final payment policy says otherwise.</p>
<a class="btn" href="subscription.html">Confirm change</a>
</div>
EOF

# ======================= 58 NOTIFICATIONS =======================
page notifications.html "Notifications" <<EOF
@@SB@@
$(BAR account.html "Notifications" '<a class="link" href="#" style="font-size: 13px; white-space: nowrap">Mark all read</a>')
<div class="scroll" style="padding-bottom: 20px">
<p class="day">Today</p>
<a class="nt is-new" href="loyalty-activity.html"><span class="nt__icon" style="background: var(--coral); color: #ffffff"><i class="ic ic-scan"></i></span><span class="nt__body"><b>18 coupons redeemed today</b><span>Your busiest Tuesday this month.</span><small>21:00</small></span><span class="nt__dot"></span></a>
<a class="nt is-new" href="giveaway-detail.html"><span class="nt__icon" style="background: var(--cream); color: var(--coral)"><i class="ic ic-gift"></i></span><span class="nt__body"><b>Giveaway ends tomorrow</b><span>Win dinner for two has 1,248 entries. Draw winners after 14 Oct.</span><small>10:00</small></span><span class="nt__dot"></span></a>
<p class="day">This week</p>
<a class="nt" href="loyalty.html"><span class="nt__icon" style="background: var(--cream); color: var(--navy)"><i class="ic ic-award"></i></span><span class="nt__body"><b>Reward redeemed</b><span>Bence T. used Free espresso (150 points).</span><small>Mon</small></span></a>
<a class="nt" href="subscription.html"><span class="nt__icon" style="background: var(--peach); color: #b06b00"><i class="ic ic-card"></i></span><span class="nt__body"><b>Subscription renewed</b><span>Growth plan renewed until 14 Nov 2026.</span><small>Mon</small></span></a>
<a class="nt" href="coupon-detail.html"><span class="nt__icon" style="background: var(--cream); color: var(--navy)"><i class="ic ic-ticket"></i></span><span class="nt__body"><b>Coupon ends soon</b><span>20% off your whole bill ends on 31 Oct.</span><small>Sun</small></span></a>
<a class="nt" href="status-approved.html"><span class="nt__icon" style="background: #e6f4ea; color: #1f7a45"><i class="ic ic-check-circle"></i></span><span class="nt__body"><b>Your restaurant is approved</b><span>Welcome to Rivjuuu, Trattoria Nonna Rosa.</span><small>1 Oct</small></span></a>
</div>
EOF

# ======================= 59 SETTINGS =======================
SET_BODY='<div class="scroll" style="padding: 0 0 24px">
<div class="group" style="margin-top: 10px"><h2>Account</h2><div class="rows">
<a class="row" href="#"><span class="row__icon"><i class="ic ic-lock"></i></span><span class="row__label">Change password</span><i class="ic ic-chevron-right"></i></a>
<a class="row" href="settings-language.html"><span class="row__icon"><i class="ic ic-globe"></i></span><span class="row__label">Language</span><span class="row__value">English</span><i class="ic ic-chevron-right"></i></a>
</div></div>
<div class="group"><h2>Notification preferences</h2><div class="rows">
<div class="row"><span class="row__icon"><i class="ic ic-scan"></i></span><span class="row__label">Coupon redemptions</span><span class="switch" role="switch" aria-checked="true"></span></div>
<div class="row"><span class="row__icon"><i class="ic ic-gift"></i></span><span class="row__label">Giveaway updates</span><span class="switch" role="switch" aria-checked="true"></span></div>
<div class="row"><span class="row__icon"><i class="ic ic-award"></i></span><span class="row__label">Loyalty rewards</span><span class="switch switch--off" role="switch" aria-checked="false"></span></div>
<div class="row"><span class="row__icon"><i class="ic ic-card"></i></span><span class="row__label">Subscription &amp; billing</span><span class="switch" role="switch" aria-checked="true"></span></div>
</div></div>
<div class="group"><h2>Support &amp; legal</h2><div class="rows">
<a class="row" href="#"><span class="row__icon"><i class="ic ic-help"></i></span><span class="row__label">Help &amp; contact support</span><i class="ic ic-chevron-right"></i></a>
<a class="row" href="#"><span class="row__icon"><i class="ic ic-file"></i></span><span class="row__label">Privacy Policy</span><i class="ic ic-chevron-right"></i></a>
<a class="row" href="#"><span class="row__icon"><i class="ic ic-file"></i></span><span class="row__label">Terms and Conditions</span><i class="ic ic-chevron-right"></i></a>
</div></div>
<div class="group"><div class="rows"><a class="row row--danger" href="#"><span class="row__icon"><i class="ic ic-logout"></i></span><span class="row__label">Log out</span></a></div></div>
</div>'
UK='<svg viewBox="0 0 60 60"><rect width="60" height="60" fill="#012169"/><path d="M0 0L60 60M60 0L0 60" stroke="#ffffff" stroke-width="12"/><path d="M0 0L60 60M60 0L0 60" stroke="#c8102e" stroke-width="5"/><path d="M30 0v60M0 30h60" stroke="#ffffff" stroke-width="18"/><path d="M30 0v60M0 30h60" stroke="#c8102e" stroke-width="10"/></svg>'
HU='<svg viewBox="0 0 60 60"><rect width="60" height="20" fill="#cd2a3e"/><rect y="20" width="60" height="20" fill="#ffffff"/><rect y="40" width="60" height="20" fill="#436f4d"/></svg>'
page settings.html "Settings" <<EOF
@@SB@@
$(BAR account.html "Settings")
${SET_BODY}
EOF
page settings-language.html "Language" <<EOF
@@SB@@
$(BAR account.html "Settings")
${SET_BODY}
<div class="scrim"></div>
<div class="bsheet" role="dialog" aria-label="Language">
<span class="handle"></span>
<div class="bsheet__head"><h2>Language</h2><a class="round" href="settings.html" aria-label="Close" style="width: 36px; height: 36px"><i class="ic ic-x"></i></a></div>
<button class="lang is-on" type="button" aria-pressed="true"><span class="flag">${UK}</span><span class="lang__name">English</span><span class="radio is-on"><i class="ic ic-check"></i></span></button>
<button class="lang" type="button" aria-pressed="false"><span class="flag">${HU}</span><span class="lang__name">Hungarian</span><span class="radio"></span></button>
<p style="margin: 0; font-size: 12px; color: var(--text)">Changes apply straight away.</p>
</div>
EOF

# ======================= INDEX =======================
card() { echo "<a class=\"ix-card\" href=\"$1\">$2</a>"; }
cat > "$H/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Rivjuuu Restaurant App</title>
<link rel="stylesheet" href="assets/rv2.css">
</head>
<body class="pg">
<main class="ix">
<img class="brand-logo" src="assets/img/logo.png" alt="Rivjuuu" style="width: 120px">
<section><h2>01 Onboarding &amp; subscription</h2><div class="ix-grid">$(card status-pending.html "39 · Status: pending")$(card status-approved.html "39 · Status: approved")$(card status-rejected.html "39 · Status: rejected")$(card plans.html "40 · Subscription packages")$(card plan-payment.html "40 · Confirm plan")</div></section>
<section><h2>02 Dashboard</h2><div class="ix-grid">$(card dashboard.html "41 · Dashboard")</div></section>
<section><h2>03 Restaurant management</h2><div class="ix-grid">$(card profile-manage.html "42 · Restaurant profile")$(card profile-edit.html "42 · Edit section sheet")$(card menu-manage.html "43 · Menu")</div></section>
<section><h2>04 Coupons</h2><div class="ix-grid">$(card coupons.html "44 · Coupons · Active")$(card coupons-expired.html "44 · Coupons · Expired")$(card coupon-form.html "45 · Create / edit coupon")$(card coupon-detail.html "46 · Coupon performance")</div></section>
<section><h2>05 QR redemption</h2><div class="ix-grid">$(card scanner.html "47 · QR scanner")$(card scanner-validating.html "47 · Validating")$(card scan-valid.html "48 · Result: valid")$(card scan-success.html "48 · Result: redeemed")$(card scan-invalid.html "48 · Result: invalid")</div></section>
<section><h2>06 Loyalty</h2><div class="ix-grid">$(card loyalty.html "49 · Loyalty")$(card reward-form.html "50 · Add / edit reward")$(card loyalty-activity.html "51 · Loyalty activity")</div></section>
<section><h2>07 Giveaways</h2><div class="ix-grid">$(card giveaways.html "52 · Giveaways")$(card giveaway-form.html "53 · Create / edit giveaway")$(card giveaway-detail.html "54 · Details · Overview")$(card giveaway-participants.html "54 · Participants")$(card giveaway-draw.html "54 · Draw winners sheet")$(card giveaway-winners.html "54 · Winners")</div></section>
<section><h2>08 Statistics</h2><div class="ix-grid">$(card statistics.html "55 · Statistics")</div></section>
<section><h2>09 Account</h2><div class="ix-grid">$(card account.html "56 · Restaurant account")$(card subscription.html "57 · Subscription")$(card subscription-change.html "57 · Change plan sheet")$(card notifications.html "58 · Notifications")$(card settings.html "59 · Settings")$(card settings-language.html "59 · Language sheet")</div></section>
</main>
</body>
</html>
EOF
echo built
