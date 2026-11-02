# Festival hour — Giờ hội chùa

## Wish being fulfilled
Players want the temple to *come alive on a schedule* — a short, rare “hội” window where the yard feels magical, rituals pay more, and they earn a festival deed they can show in Sổ / presence. Sacred calm on demand + reason to linger through the day cycle.

## Player fantasy loop (addictive)
1. **Discover** — time-chip / toast announces **🎉 Giờ hội chùa** (short window tied to day cycle, e.g. late day → early dusk, or a ~45–90s spike once per cycle)  
2. **Interact** — during hội: brighter lanterns / petal rain / denser soft crowd silhouettes; tip to do a quick festival act (thắp hương, thỉnh chuông, or one dedicated **Thả hoa hội** / **Cầu giờ hội** near an existing zone)  
3. **Reward** — first festival act in the window → bonus công đức + toast + Sổ `festivalMoments` line + optional “Khách Hội” flair chip for the session  
4. **Escalate** — 2+ festival acts in same window → “Hội duyên” toast; night/dusk overlap may tint sky warmer; optional soft pilgrim tip “đúng giờ hội rồi” (flavor only, no quest rewrite)  
5. **Show off** — presence / nameplate blip or merit chip: “· Khách Hội”; Sổ section lists recent giờ hội

## Must implement (in index.html)
- [x] **Festival window** — detect/schedule a short spike from existing `timeOfDay` / `timePhase` (do not replace day cycle). Clear enter + exit toasts; time-chip shows festival state while active
- [x] **Atmosphere** — at least 2 of: lantern glow boost, floating petals/confetti, ambient pitch/volume nudge, soft extra crowd silhouettes in yard (cheap meshes OK). Keep FPS mobile-friendly
- [x] **Festival action** — one clear hook within ~30s: either boosted first incense/bell during window **or** a dedicated near-zone action **Cầu giờ hội** / **Thả hoa hội** that awards once per window (or once + small repeat cap)
- [x] **Rewards** — `gainCongDuc` bonus, toast, persist Sổ list `festivalMoments` (max ~12); session flair “Khách Hội” on merit chip / presence title if easy
- [x] **Coexistence** — leave intact: công đức tiers, day cycle base phases, stamps, fortune→fate, Cầu chung, pilgrim quests, Phố An Lạc + đánh ghen gossip (do not expand street/gossip/BTS)
- [x] UI copy in Vietnamese where the game already uses Vietnamese
- [x] Keep mobile + desktop + FPS usable
- [x] **Do NOT** expand BTS / princess / idol romance
- [x] **Do NOT** rewrite đánh ghen / gossip circle / street district beyond leaving them intact

## Acceptance criteria
- Player notices festival within ~10s of window start (toast + chip and/or VFX)
- Can complete one festival-rewarded act within ~30s of finding the tip
- Clear enter/exit feedback; no soft-lock if they ignore the window
- Feels exclusive / “chỉ có đúng giờ hội ở sân chùa này”
- Touches GLOBAL **world living** pillar (≥80% global systems)
- Offline-completeable; no blank screen; no new BTS UI

## Out of scope
- Full calendar / real-world clock sync / push notifications
- Weather system rewrite (rain/fog as separate task later)
- Daily streak / Sổ goals overhaul (save for later loop)
- Pilgrim quest redesign (tiny flavor tip OK)
- Identity wardrobe / áo shop
- BTS / princess / gossip street expansion

## Notes for Agent 2
Reuse: `phaseFromTimeOfDay` / `updateTimeHud` / time-chip, sky/lantern lights, `gainCongDuc`, toast, `openBook` Sổ, presence title helpers (same pattern as Thiện Duyên), incense/bell zones, optional petal/particle patterns already in sky/effects.
Primary file: `index.html`.
Focus: `agents/FOCUS.md` — global ≥80%; pillar = **World living (festival moments)**.
Prior ship: công đức+day+stamps, fortune→fate, Cầu chung, pilgrim quests, Phố An Lạc/gossip — leave intact; festival should *amplify* the yard for everyone, not a cameo.

## Director review (prior task)
Pilgrim quests (TASK-20261102-1924): solid — 3 NPCs, 6 variants, zone routing, Sổ + Thiện Duyên, dusk rare bias. No polish required this pass; leave as-is.

## Director review (loop 7)
Accepted. Wish clear in ~10s (toast + chip + VFX). Global yard amplify, not a cameo. Return hook via day-cycle spike + Sổ. No polish this pass — assign next: daily streak / Sổ goals.

## Done report
- Files changed: `index.html` (festival window + VFX + Thả hoa hội + Sổ/save/presence flair); task + `agents/loop-state.json`
- What the player can do now:
  - Once per day-cycle at late day (`tod≈0.18`), a **~58s Giờ hội chùa** opens — toast + time-chip `🎉 Giờ hội · Ns` + warmer sky
  - Atmosphere: brighter lanterns, denser petal rain, soft crowd silhouettes, ambient tone/volume nudge
  - Dedicated **Thả hoa hội** (cam vòng sáng near hồ sen, up to 2×/window) or boosted thắp hương / thỉnh chuông
  - First festival act → bonus công đức + Sổ **🎉 Giờ hội chùa** + session **Khách Hội** on merit chip / presence; 2nd → **Hội duyên**; pilgrim soft tip “Đúng giờ hội rồi…”
  - Ignoring the window just ends with exit toast — no soft-lock
- How to test:
  1. Open `index.html`, enter name, play (start quickly — festival ~7–10s after boot from `tod=0.12`)
  2. Watch toast + time-chip flip to **🎉 Giờ hội**; lanterns/petals/crowd silhouettes kick in
  3. Walk to orange marker by hồ sen → **Thả hoa hội** (or thắp hương / thỉnh chuông) → công đức + Khách Hội
  4. Do a second festival act → **Hội duyên** toast
  5. Open **Sổ** → section **🎉 Giờ hội chùa**; wait for exit toast when timer ends
  6. Smoke-check: stamps, xin quẻ→Theo vận, Cầu chung, pilgrim giúp, Phố An Lạc gossip still work; no new BTS UI
- Known limits / next ideas for Agent 1:
  - Festival is wall-clock ~58s once per cycle (not real-world calendar)
  - Khách Hội is session flair (not persisted) — could become a deed title later
  - Next: weather (mưa/sương) layered on day cycle, or Sổ daily goals that mention giờ hội without BTS
