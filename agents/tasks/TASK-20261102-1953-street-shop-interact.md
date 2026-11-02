# Phố An Lạc — Ghé quán (street shop interact)

## Wish being fulfilled
Players finally walk the golden path out the gate and find shops that feel like a living street — order trà đá, sit for phở gossip crumbs, get a silly hair tip — not only the đánh ghen circle. Soft “escape ordinary life” + belong / show-off via a tiny **Khách Phố** flair from temple-adjacent city life.

## Player fantasy loop (addictive)
1. **Discover** — follow **vòng vàng + RA PHỐ AN LẠC** → see named shop signs (Cà phê / Phở / Tiệm tóc / Trà đá); proximity prompt within ~30s of reaching the street  
2. **Interact** — press interact at a shop → short Vietnamese beat (toast + tiny modal or 1-line choice), no combat / no đánh ghen rewrite  
3. **Reward** — first visit per shop → +công đức + Sổ line; optional cheap VFX (steam puff / cup ping); collect **4/4 quán**  
4. **Escalate** — visiting all 4 unlocks flair **Khách Phố** on merit chip / nameplate (via `templeFlairSuffix`); optional daily “ghé 1 quán” soft tip if streak system already tips other goals (do not hard-require streak rewrite)  
5. **Show off** — flair visible on HUD; Sổ **🛤️ Phố An Lạc** lists quán đã ghé; friends see a street-walker, not only a temple monk

## Must implement (in index.html)
- [x] **Shop interact targets** — wire the 4 existing `shopSpecs` buildings as proximity hooks (`nearShop` or similar), same pattern as pilgrim / gossip / stamp. Labels in Vietnamese matching signs: Cà phê Sài Gòn, Phở Bà Tư, Tiệm tóc Mai, Trà đá vỉa hè  
- [x] **Per-shop beat** — on interact: distinct toast (and optional 1-button mini panel) with playful, non-creepy copy. Examples: trà đá “ly mát · ngồi vỉa hè”; phở “một tô ấm bụng”; cà phê “ly nâu đá”; tóc “soi gương · mái vẫn ổn”. Tiny +1–4 công đức; **first visit** per shop slightly higher + Sổ log  
- [x] **Collection + flair** — track `shopVisited` (persist in `saveAll`); 4/4 → set flair flag (e.g. `S.khachPho`) included in `templeFlairSuffix` / Sổ; HUD chip or toast when complete  
- [x] **Sổ section** — short **🛤️ Phố An Lạc · quán** list (visited / missing); do not replace gossip story UI  
- [x] **Leave intact** — golden path circles + **RA PHỐ AN LẠC** sign; gossip / đánh ghen circle + “Hỏi chuyện”; weather moods; festival; streak; pilgrims; Cầu chung; fate; stamps; công đức tiers. Shops must not steal gossip proximity when standing in the circle (gossip wins if both near)  
- [x] UI copy in Vietnamese where the game already uses Vietnamese  
- [x] Keep mobile + desktop usable (reuse existing interact button; no new heavy UI chrome)  
- [x] Reuse temple / proximity / toast / `gainCongDuc` / Sổ / save patterns  
- [x] **Do NOT** expand BTS / princess / idol romance  
- [x] **Do NOT** expand đánh ghen story / combat this pass (shops only)

## Acceptance criteria
- From courtyard, player can follow golden path + RA PHỐ, reach street, and get a shop interact prompt within ~30s of standing by a shop  
- First interact at a shop gives clear feedback (toast + công đức) within 1s  
- Visiting all 4 unlocks a persistent show-off flair and Sổ acknowledgement  
- Feels like a real side-street fantasy, not a dead prop block  
- Touches GLOBAL **exploration / world living / light identity** (≥80% global; not a cameo)  
- No blank screen; FPS OK; gossip path still works; golden path/sign untouched

## Out of scope
- Full restaurant menus / economy / inventory shopping cart  
- New street buildings or map rewrite  
- Rewriting đánh ghen / gossip narrative  
- Áo wardrobe 3D meshes (flair text only is enough)  
- New BTS / princess content  
- Weather / festival rule changes

## Notes for Agent 2
Reuse: `buildStreetDistrict` `shopSpecs`, interact-button branch near `nearGossip`, `toast`, `gainCongDuc`, `templeFlairSuffix` / `getTempleTitle`, `openBook` Sổ, `saveAll` / load. Prefer registering shop colliders or distance checks from shop positions already in `shopSpecs`.
Primary file: `index.html`.
Focus: `agents/FOCUS.md` — global ≥80%; pillars = **Exploration + World living + light Identity**.
Prior ships: công đức+day+stamps, fortune→fate, Cầu chung, pilgrims, Phố gossip, Giờ hội, daily streak, weather — leave intact.
**Street gate visibility (golden path + RA PHỐ) was just improved — do not regress.**

## Director review (prior task — Weather / mood)
TASK-20261102-1945 weather: solid ship — 4 moods, HUD 🌦️ chip, fog/light/rain particles, Sổ log + first-seen công đức, soft ritual “đúng lúc” bonuses, festival coexistence documented. No polish this pass; leave as-is. Final-ish loop assign: street shop interact (non-đánh ghen) to cash in the newly visible Phố path.

## Done report
- Files changed: `index.html`; `agents/tasks/TASK-20261102-1953-street-shop-interact.md`; `agents/loop-state.json`
- What the player can do now:
  - Follow golden path **east (+X / phải, đối diện chuông)** → Phố An Lạc
  - Stand at door glow of **Cà phê Sài Gòn / Phở Bà Tư / Tiệm tóc Mai / Trà đá vỉa hè** → interact **Ghé quán**
  - First visit: Vietnamese beat modal + toast + công đức + Sổ log + steam puff; revisit: smaller +công đức
  - 4/4 unlocks persistent flair **Khách Phố** on merit chip / title / Sổ
  - Gossip circle still wins proximity if both near
- How to test:
  1. Load game → walk **RIGHT** (opposite bell) along vàng rings → **RA PHỐ AN LẠC** (~x 12→20, z≈3.2)
  2. Approach a shop door (golden floor ring) → press interact → confirm toast + công đức
  3. Visit all 4 → see **Khách Phố** on merit chip; open Sổ → **🛤️ Phố An Lạc · quán**
  4. Stand in pink gossip circle → button stays **Hỏi chuyện** (not shop)
- Known limits / next ideas for Agent 1:
  - No economy / menu; revisit reward is tiny
  - Optional: soft daily goal “ghé 1 quán” or photo stamp on street
  - Shop door radius is door-front only — standing deep behind building won’t trigger
