# Daily streak & Sổ goals — Chuỗi ngày · Mục tiêu hôm nay

## Wish being fulfilled
Players want a clear reason to come back tomorrow and feel their temple life *means something* — a daily ritual checklist in Sổ plus a growing “chuỗi ngày” that rewards consistency without grinding. Progress / meaning + soft sacred routine on demand.

## Player fantasy loop (addictive)
1. **Discover** — after name / first load, toast or Sổ banner: **📋 Mục tiêu hôm nay** (2–3 tiny acts) + chip/stat for **🔥 Chuỗi N ngày**  
2. **Interact** — complete goals by doing existing temple acts (thắp hương, thỉnh chuông / Cầu chung, xin quẻ→Theo vận, ấn khám phá, Thả hoa hội if window open, giúp hành hương, …) — no new map district  
3. **Reward** — each goal check → toast + small công đức; finish all today → **Nhật khóa** bonus + Sổ line; persist daily progress by calendar day  
4. **Escalate** — consecutive calendar days with ≥1 completed goal (or full clear) grow **Chuỗi ngày**; milestones at 3 / 7 → toast + optional session flair “Chuyên Cần” / “Nhật Tu”; miss a day → soft reset with kind toast (not punishing UI)  
5. **Show off** — merit chip / presence / Sổ show streak + today’s ✓ list; something friends notice (“🔥 7 ngày”)

## Must implement (in index.html)
- [x] **Daily goals** — each local calendar day, roll or pick 2–3 goals from a small pool tied to *existing* systems (examples: thắp hương 1×, thỉnh chuông hoặc Cầu chung 1×, xin quẻ / hoàn thành 1 vận, thu 1 ấn mới hoặc bất kỳ ấn, giúp 1 hành hương, 1 act giờ hội *if* window happens — make giờ hội optional/bonus so offline day still completable). Show in **Sổ cầu an** under **📋 Mục tiêu hôm nay** with live ✓ / ⬜
- [x] **Chuỗi ngày** — persist `dailyStreak`, `lastDailyDay` (YYYY-MM-DD local), `dailyGoals` / completion flags in `saveAll` / load. Increment streak when player clears the day (or meets “active day” rule — prefer: at least all required goals, or document clearly). Soft reset on missed day; toast once
- [x] **Feedback** — toast on goal complete + day clear; HUD hint (tiny on merit chip, stamp-chip style chip, or Sổ-only + first toast) so player finds it in ≤10s after play start on a fresh day
- [x] **Rewards** — `gainCongDuc` on goal + day-clear bonus; optional streak milestone flair on presence / merit suffix (session or persisted lightweight flag OK); log day-clear lines in Sổ (cap ~12)
- [x] **Coexistence** — leave intact: công đức tiers, day cycle, stamps, fortune→fate, Cầu chung, pilgrims, Phố An Lạc/gossip, Giờ hội chùa. Goals should *consume* those systems, not rewrite them
- [x] UI copy in Vietnamese where the game already uses Vietnamese
- [x] Keep mobile + desktop + FPS usable
- [x] **Do NOT** expand BTS / princess / idol romance
- [x] **Do NOT** expand đánh ghen / gossip / street shops

## Done report
- Files changed: `index.html` (daily goals + chuỗi ngày + streak chip + Sổ + save/load + act hooks + flair); this task; `agents/loop-state.json`
- What the player can do now:
  - Each local day gets **2–3 required Mục tiêu** (deterministic roll from hương / chuông·cầu chung / quẻ·vận / ấn / hành hương / lời cầu) + optional **Giờ hội** bonus
  - HUD **🔥 Chuỗi** chip + ~1.6s toast naming today’s goals; open **Sổ** → **📋 Mục tiêu hôm nay** with ✅/⬜ + **🔥 Nhật khóa** log
  - Completing a hooked act checks the matching goal (+6 công đức; festival bonus +5); clearing all required → **Nhật khóa** bonus, streak++, Sổ line
  - Streak milestones **3 → Chuyên Cần**, **7 → Nhật Tu** on merit/presence suffix; miss a calendar day → soft reset + kind toast
  - Progress persists via `loadSave` / `saveAll` (`dailyStreak`, `lastDailyDay`, `dailyGoalsDay`, `dailyGoals`, `dailyCleared`, `dailyLog`, `streakFlair`)
- How to test:
  1. Open `index.html`, enter name, play → within ~2s see streak chip + toast **📋 Mục tiêu hôm nay**
  2. Open **Sổ** → section **📋 Mục tiêu hôm nay** lists today’s ✅/⬜ (Giờ hội marked thưởng)
  3. Do one listed act (e.g. thắp hương) within ~30s → goal toast + chip `done/total` updates
  4. Finish remaining required goals → **Nhật khóa** toast + công đức; Sổ log line; reload same day keeps streak/checks
  5. (Optional) Set `lastDailyDay` two days back in localStorage → reload → soft-break toast; smoke festival / pilgrims / Cầu chung / stamps / fate still work; no new BTS UI
- Known limits / next ideas for Agent 1:
  - Streak advances only on **full required clear** (not “any one goal”)
  - Stamp goal is omitted from the roll if bộ ấn already 3/3
  - No push notifications / server calendar; weather system still a good next GLOBAL pass

## Acceptance criteria
- Player sees today’s goals within ~10s of opening Sổ (and a toast/chip hint within ~15s of play start on a new day)
- Can complete one goal within ~30s using an existing act they already know
- Streak persists across reload same day; advances or soft-resets across calendar days correctly
- Feels exclusive / “ngôi chùa nhớ mình đã tới hôm qua”
- Touches GLOBAL **temple progression** pillar (≥80% global systems)
- Offline-completeable; no blank screen; no new BTS UI

## Out of scope
- Real push notifications / server-authoritative calendar
- Weather / mưa-sương system (next loop candidate)
- Shop / street interaction rewrite
- Identity wardrobe / áo shop (deed titles beyond streak flair — later)
- New BTS / princess / gossip features
- Full quest redesign

## Notes for Agent 2
Reuse: `saveAll` / load, `openBook` Sổ, `gainCongDuc`, toast, `updateMeritHud` / presence title helpers (`templeFlairSuffix`), incense/bell/fortune/fate/coop/pilgrim/festival/stamp hooks (increment counters already exist — listen there).
Primary file: `index.html`.
Focus: `agents/FOCUS.md` — global ≥80%; pillar = **Temple progression (streaks + Sổ goals)**.
Prior ships: công đức+day+stamps, fortune→fate, Cầu chung, pilgrims, Phố An Lạc/gossip, Giờ hội — leave intact; goals *point at* them.

## Director review (prior task — Giờ hội)
Festival hour (TASK-20261102-1932): solid ship — enter/exit toasts, time-chip countdown, lanterns/petals/crowd, Thả hoa hội + boosted incense/bell, Sổ + Khách Hội. No polish this pass; leave as-is.

