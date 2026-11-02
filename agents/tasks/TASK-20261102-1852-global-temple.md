# Global temple living world — công đức, day cycle, explore stamps

## Wish being fulfilled
Players want the *whole chùa* to feel alive and meaningful: progress that matters, a world that changes, secrets to hunt, and a title they earned — not a celebrity cameo.

## Player fantasy loop (addictive)
1. **Discover** — notice dusk shift / công đức meter / glowing stamp spots  
2. **Interact** — thắp hương, rung chuông, xin quẻ, walk stamp route  
3. **Reward** — công đức XP, toast, Sổ entry, unlock title tier  
4. **Escalate** — night festival mood, rarer stamps, multiplayer see your title  
5. **Show off** — nameplate `🌸 Tu Tập` / `🔔 Hộ Pháp` from deeds; world toast on milestone

## Must implement (in index.html)
- [x] **Công đức meter (global progression)**
  - Session + persisted (localStorage via loadSave/saveAll): gain from incense, bell, fortune, prayer
  - Small HUD chip or Sổ section showing level/title tier (e.g. Thiện Nam → Tu Tập → Hộ Pháp)
  - Milestone toasts in Vietnamese
- [x] **Day → dusk → night mood cycle**
  - Slow loop or time-based lighting fog/sky tint already partly in `S.dusk` — make it readable to player (chip or sky clearly shifts)
  - Optional soft “giờ vàng / đêm thiền” toast when crossing thresholds
- [x] **Exploration photo/stamp route (3 spots)**
  - Glowing world markers around temple (NOT BTS secrets); near action → “Thu thập ấn”
  - Persist collected stamps; Sổ or HUD shows 0/3 → 3/3 reward (công đức burst + title flavor)
- [x] **Multiplayer show-off (deeds, not idols)**
  - Publish title tier on presence; remote nameplate can show temple title when set
- [x] Keep mobile + FPS + existing combat/BTS **untouched except** shared HUD/presence if needed
- [x] **Do not** add new BTS/princess features in this task

## Acceptance criteria
- Within ~30s player can gain công đức and see feedback
- Day/dusk/night (or clear dusk shift) is noticeable without reading code
- At least 3 stamp spots collectible with persistence
- Remote/local path exists for deed title on nameplate
- No blank screen; FPS toggle OK
- No new BTS UI/actions

## Out of scope
- BTS / princess / idol romance expansions
- Real money / personal data
- Full quest dialogue tree rewrite

## Notes for Agent 2
Reuse: `S`, `loadSave`/`saveAll`, zones (fortune/bell/incense), `publishPresence`, remote labels, Sổ UI, dusk lighting.
Primary file: `index.html`.
Focus doc: `agents/FOCUS.md`.

## Done report
- Files changed: `index.html`, `agents/loop-state.json`, this task file
- What the player can do now:
  - Earn **công đức** from thắp hương, chuông/mõ, xin quẻ, lời cầu — HUD chip + Sổ show tier **Thiện Nam → Tu Tập (25) → Hộ Pháp (70)**
  - See **day / giờ vàng / đêm thiền / bình minh** cycle with sky+lighting shift and phase toasts + time chip
  - Collect **3 ấn** (Cổng, Hồ Sen, Chính Điện); persist; 3/3 bonus công đức
  - Online: presence publishes deed `title` / `merit`; remote nameplate shows `🌸 Tu Tập · Name`
- How to test:
  1. Enter play → merit + time + stamp chips visible
  2. Thắp hương near lư → toast `+công đức`, chip updates
  3. Walk glowing stamps (gate / pond / hall) → Thu thập ấn; reload keeps stamps/XP
  4. Wait ~20–40s → sky shifts; toast giờ vàng / đêm thiền
  5. Open Sổ → công đức + danh hiệu + ấn checklist
  6. Second client online → see title on remote label; FPS toggle still works
- Known limits / next ideas for Agent 1:
  - Stamp positions are fixed courtyard markers (not photo UI)
  - Title tiers are XP thresholds only (no cosmetics yet)
  - Weather / co-op rituals / pilgrim NPCs still open for next global iteration
  - Partial princess persist fields remain from aborted loop2 — no new BTS features shipped
