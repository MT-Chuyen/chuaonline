# NPC pilgrim quests — chuyện hành hương ngắn

## Wish being fulfilled
Players want the yard to feel *inhabited by stories*, not empty props: meet funny/soft pilgrims, help with a tiny errand, earn a deed line + công đức, and feel like the temple’s quiet helper — without idol/BTS content.

## Player fantasy loop (addictive)
1. **Discover** — notice a marked pilgrim NPC in the yard (soft glow / name cue “Hành hương · …”) with a speech bubble or toast tip  
2. **Interact** — talk → short Vietnamese ask (lost sandal, wrong incense count, photo of gate, find a quiet spot, deliver a wish slip to chuông, etc.)  
3. **Reward** — complete in ~20–40s → toast + công đức + Sổ `pilgrimQuests` line + optional tiny title flair chip  
4. **Escalate** — 3 distinct daily pilgrims / quest ids; completing 2+ in a session unlocks “Thiện Duyên” streak toast; dusk/night pilgrim has slightly rarer ask  
5. **Show off** — presence/nameplate blip or wish feed: “vừa giúp hành hương …” (deed, not idol)

## Must implement (in index.html)
- [x] **2–3 pilgrim NPCs** in the courtyard (reuse / extend existing soft NPC / crowd meshes if any; else simple labeled figures + billboard name). Not BTS idols.
- [x] **Quest hook** — near pilgrim → action **Nói chuyện** / **Giúp** → short choice or one-step errand that routes player to an existing zone (chuông, hương, stamp spot, gate, fortune) within ~30–40s
- [x] **At least 3 quest variants** (rotate or pick unused id per session): funny mishap tone OK; all Vietnamese UI copy
- [x] **Rewards** — `gainCongDuc`, toast, persist Sổ list `pilgrimQuests` (max ~12), session count; optional light title flavor if easy (reuse công đức tier / presence, no new idol cosmetics tree)
- [x] **Coexistence** — do not break Cầu chung NPC helper, stamps, fortune→fate, day cycle, solo chuông
- [x] Keep mobile + desktop + FPS usable
- [x] **Do NOT** expand BTS / princess / idol romance

## Acceptance criteria
- Within ~30s of spotting a pilgrim, player can start a quest
- Clear feedback on accept + complete (toast / VFX / công đức / Sổ)
- Feels exclusive / “chỉ có ở sân chùa sống này”
- Touches GLOBAL **NPC pilgrims** pillar (≥80% global systems)
- Offline-completeable; no soft-lock if player walks away (cancel/timeout gentle)
- No blank screen; no new BTS UI

## Out of scope
- Full branching dialogue RPG / quest journal rewrite
- Weather / festival hour rewrite (save for later loop)
- Full cosmetic wardrobe (identity áo) — only light deed flair if cheap
- BTS / princess feature work
- Matchmaking / voice chat

## Notes for Agent 2
Reuse: zones (bell/incense/fortune/stamps), `gainCongDuc`, toast, Sổ `openBook`, presence/`publishWish`, day phase as light flavor, any existing NPC/crowd helpers from Cầu chung.
Primary file: `index.html`.
Focus: `agents/FOCUS.md` — global ≥80%; pillar = **NPC pilgrims**.
Prior ship: công đức+day+stamps, fortune→fate, co-op Cầu chung — leave intact; quests should *feed* công đức and Sổ, and may lightly use chuông/hương zones without replacing co-op.

## Done report
- Files changed: `index.html` (pilgrim NPCs + quests, Sổ/save/presence); task + `agents/loop-state.json`
- What the player can do now:
  - Meet **3** labeled pilgrims (Bà Năm / Chú Tư / Cô Hạnh) with soft green glow in the yard
  - **Giúp / Nói chuyện** → accept a short Vietnamese errand (6 variants; 3 assigned per session, unused ids preferred; dusk/night biases a rarer ask)
  - Follow the green marker to an existing zone (cổng, lư hương, chuông, hồ sen, xin quẻ) and press **Xong việc** (~75s soft timeout / “Thôi giúp”)
  - Doing the matching ritual (thắp hương / thỉnh·cầu chung / xin quẻ / thu ấn cổng·hồ) also completes the errand
  - Earn công đức + Sổ **Giúp hành hương** line; 2+ helps → **Thiện Duyên** flair on merit chip / presence title; optional wish-feed blip online
- How to test:
  1. Open `index.html`, enter name, play
  2. Look for green-glow figures + tip “Hành hương · …” (e.g. near gate / fortune / wish side of yard)
  3. Press action **Giúp · …** → **Giúp** → toast tip + green destination marker
  4. Walk to marker → **Xong việc** (or do matching incense/bell/fortune/stamp) → toast + công đức
  5. Open **Sổ** → section **🌿 Giúp hành hương**; help a second pilgrim → **Thiện Duyên** toast
  6. Smoke-check: Cầu chung at chuông, stamps, xin quẻ→Theo vận, day-phase chip still work; no new BTS UI
- Known limits / next ideas for Agent 1:
  - Pilgrims stay put (no pathing); one quest each until helped then “Cảm ơn”
  - Session pool can reshuffle if all variants used; no multi-day calendar yet
  - Next: pilgrim return schedules, tiny dialogue beats, or festival-hour special ask without BTS
