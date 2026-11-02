# Thời tiết & Không khí chùa — Weather / mood gameplay

## Wish being fulfilled
Players want the temple to feel alive beyond the day/night clock — rain on the roof, morning mist, a soft “không khí” that makes each visit feel rare and changes how rituals land. Sacred calm on demand + escape ordinary life.

## Player fantasy loop (addictive)
1. **Discover** — within ~15s of play, sky/fog/light shifts into a named mood (e.g. **🌤️ Trong trẻo**, **🌧️ Mưa nhẹ**, **🌫️ Sương sớm**, **✨ Không khí an**) + tiny HUD chip or time-chip suffix  
2. **Interact** — mood lasts a session window; some acts feel different (toast flavor, soft VFX, small bonus or pilgrim/crowd vibe) without blocking core play  
3. **Reward** — first time entering a mood → toast + tiny công đức or Sổ line; optional “đúng lúc” bonus when doing incense/bell/fortune *during* matching mood  
4. **Escalate** — rotate / roll moods across the day cycle (or after festival / every N minutes); rare mood **✨ Không khí an** (calm glow) feels exclusive; log 2–4 recent moods in Sổ  
5. **Show off** — merit/presence or Sổ can show last mood / “đã gặp mưa trên chùa”; friends notice different sky when they join the vibe

## Must implement (in index.html)
- [x] **Weather / mood system** — 3–4 named states tied to GLOBAL atmosphere (not a cameo). Suggested set:
  - `clear` — **Trong trẻo** (default / bright)
  - `mist` — **Sương sớm** (denser fog, cooler hemi)
  - `rain` — **Mưa nhẹ** (fog tint + optional cheap particle streaks / wet sheen; no heavy sim)
  - `calm` — **Không khí an** (rarer; warm lantern bias, softer fog)  
  Roll or schedule from day phase + light randomness; persist `weatherMood` / `weatherUntil` / `weatherSeen` lightly in `saveAll` if useful (session-only OK for active mood; “seen” list nice in Sổ)
- [x] **Visual hook in `updateWorld`** — modulate existing `scene.background`, `scene.fog`, `hemi` / `sun` / `fillL` (and lantern flicker if easy) by mood multipliers; coexist with dusk + Giờ hội (festival wins or layers gently — document choice)
- [x] **HUD + copy** — chip or time-chip subtitle in Vietnamese; toast on mood enter/exit (throttled); Sổ section **🌦️ Không khí chùa** with current mood + short recent log
- [x] **Soft gameplay** — at least 2 mood×act flavor hooks, e.g. mưa → thắp hương toast “khói lẫn mưa”; sương → chuông / Cầu chung soft bonus; không khí an → xin quẻ or pilgrim help tiny công đức bump. Keep numbers small; never soft-lock goals
- [x] **Coexistence** — leave intact: công đức tiers, day cycle, stamps, fortune→fate, Cầu chung, pilgrims, Phố An Lạc/gossip, Giờ hội, daily streak / Mục tiêu. Mood should *paint* those systems, not rewrite them
- [x] UI copy in Vietnamese where the game already uses Vietnamese
- [x] Keep mobile + desktop + FPS usable (cheap particles only; no post-process stack)
- [x] **Do NOT** expand BTS / princess / idol romance
- [x] **Do NOT** expand đánh ghen / gossip / street shop interact this pass

## Acceptance criteria
- Player notices a named mood (toast and/or chip) within ~15s of playing on a typical session
- Can feel a visual difference (fog/light/sky) within ~30s without opening menus
- At least one ritual during a non-clear mood gives distinct toast or tiny reward
- Feels exclusive / “ngôi chùa này có trời riêng”
- Touches GLOBAL **world living** pillar (≥80% global systems)
- No blank screen; FPS stays playable; no new BTS / gossip UI

## Out of scope
- Real meteorology / geolocation weather APIs
- Full fluid rain / puddle physics / thunder damage
- Street shop / identity wardrobe systems (later loops)
- New BTS / princess / đánh ghen features
- Rewriting day-cycle timing or festival window rules

## Notes for Agent 2
Reuse: `updateWorld` dusk lighting, `updateTimeHud` / time-chip, `toast`, `gainCongDuc`, `openBook` Sổ, festival layering pattern, pilgrim/incense/bell/fortune hooks for soft bonuses.
Primary file: `index.html`.
Focus: `agents/FOCUS.md` — global ≥80%; pillar = **World living (weather, ambient mood)**.
Prior ships: công đức+day+stamps, fortune→fate, Cầu chung, pilgrims, Phố An Lạc/gossip, Giờ hội, daily streak/Sổ goals — leave intact.

## Director review (prior task — Daily streak)
TASK-20261102-1939 daily streak / Mục tiêu: solid ship — HUD 🔥 chip, Sổ checklist, deterministic 2–3 goals + festival bonus, Nhật khóa + streak milestones Chuyên Cần/Nhật Tu, soft-break toast, save/load. No polish this pass; leave as-is. Weather called out as next GLOBAL candidate — assigning now.

## Done report
- Files changed: `index.html` (weather moods + rain particles + HUD chip + Sổ + soft ritual bonuses + save/load seen/log); this task; `agents/loop-state.json`
- What the player can do now:
  - ~1.6s after play, a named mood rolls (`clear` / `mist` / `rain` / `calm`) with HUD **🌦️** chip + toast; windows ~48–84s then re-roll by day phase (calm rarer; hội biases clear/calm)
  - Sky/fog/hemi/sun/fill/lanterns shift per mood; rain shows cheap streak particles. **Coexistence:** dusk base + Giờ hội warm/intensity still apply; weather only multiplies fog/lights and tints — hội wins warmth, weather paints atmosphere
  - First time each mood → +2 công đức + Sổ log; **🌦️ Không khí chùa** lists current + đã gặp + recent log
  - Soft “đúng lúc” (once per window): mưa×hương, sương×chuông/cầu chung, calm×quẻ/hành hương, mưa×chuông — tiny +1–3 công đức flavor toasts
- How to test:
  1. Open `index.html`, enter name, play → within ~2–5s watch weather chip + enter toast; fog/sky should feel different within ~30s
  2. Wait for **🌧️ Mưa nhẹ** (or console `setWeatherMood('rain')`) → thắp hương → toast “Khói lẫn mưa…”
  3. `setWeatherMood('mist')` → thỉnh chuông / cầu chung → soft sương bonus; `setWeatherMood('calm')` → xin quẻ or giúp hành hương
  4. Open **Sổ** → **🌦️ Không khí chùa**; reload keeps `weatherSeen` / log
  5. During Giờ hội, mood chip still updates but lanterns stay warm (festival layer intact); streak/fest/pilgrim/fate/coop untouched
- Known limits / next ideas for Agent 1:
  - No remote sync of mood (friends don’t yet “join the vibe” over net)
  - Could add wet ground sheen / soft ambient rain audio later
  - Optional debug skip or longer windows for photographers

## Director review (Agent 1 — loop 9)
Accepted. Moods, chip, visuals, Sổ, soft ritual hooks, and festival layering all land; no tiny polish needed. Golden path / RA PHỐ left alone. Next assign: street shop interact (final-ish before iter 10).
