# Co-op social ritual — shared chuông cầu an

## Wish being fulfilled
Players want to *belong with someone on the yard* — not alone XP. A short shared ritual (chuông / cầu an cùng lúc) that only works when another pilgrim (remote player or friendly NPC stand-in) is near, with a world toast they can show off.

## Player fantasy loop (addictive)
1. **Discover** — near chuông (or dedicated ritual spot) see cue “Có thể cầu chung” when another soul is close  
2. **Interact** — tap **Cầu chung** / hold with partner within ~4–6s window  
3. **Reward** — dual VFX + toast + công đức burst + Sổ `rituals` line; optional world wish blip  
4. **Escalate** — 2+ successful co-op rituals in a session → streak bonus; dusk/night slight flavor bump  
5. **Show off** — online toast: “A và B vừa cầu chung bên chuông”; nameplate / presence blip of last ritual

## Must implement (in index.html)
- [x] **Co-op hook at chuông (or incense zone)** — when local player is near bell/mõ zone AND (a remote player within ~5m OR a soft NPC pilgrim helper if alone offline), show action **Cầu chung** (distinct from solo rung chuông)
- [x] **Synced mini-window (≤6s)** — start ritual → partner prompt / local “đợi nhịp” → both complete (solo+NPC path auto-fills second beat so offline still works). Success = clear feedback; fail/timeout = gentle toast, no soft-lock
- [x] **Rewards** — +công đức (higher than solo bell), toast Vietnamese, Sổ entry list `coopRituals` (max ~15), session `coopStreak` bonus
- [x] **Social show-off** — if online: `publishWish` / presence blip with deed line (names), not idol content
- [x] Reuse zones, action-btn, toast, gainCongDuc, publishPresence/publishWish, day phase only as light flavor
- [x] Keep mobile + desktop + FPS usable; existing solo chuông / incense / fortune / stamps still work
- [x] **Do NOT** expand BTS / princess / idol romance

## Acceptance criteria
- Within ~30s of finding chuông + a partner (or NPC helper), player can start Cầu chung
- Clear success feedback (VFX/toast/công đức/Sổ)
- Feels exclusive / “chỉ có ở chùa online này”
- Touches GLOBAL social multiplayer system (not a cameo)
- Offline path still completable via NPC pilgrim helper
- No blank screen; no new BTS UI

## Out of scope
- Full voice/chat, friend lists, matchmaking servers
- Weather rewrite, festival hour rewrite (save for later)
- Daily streak system rewrite (adjacent, not this task)
- BTS / princess feature work

## Notes for Agent 2
Reuse: bell/mõ zone + `actBell` (or equivalent), remotePlayers map, `publishWish`, `gainCongDuc`, toast, Sổ `openBook`, fate/stamp HUD patterns.
Primary file: `index.html`.
Focus: `agents/FOCUS.md` — global ≥80%; pillar = **Social multiplayer**.
Prior ship: công đức tiers, day cycle, stamps, fortune→fate (+ compass chip) — leave intact; co-op should *feed* công đức and Sổ.

## Done report
- Files changed: `index.html` only
- What the player can do now:
  - Near **gác chuông** → toast “Có thể cầu chung” + action **Cầu chung · [tên]**
  - Menu: **Cầu chung** (remote partner or soft NPC hành hương) or **Thỉnh một mình** (solo minigame intact)
  - ≤6s window: tap **Đồng nhịp** → “đợi nhịp” → partner auto-beat (NPC / nearby remote) → dual VFX + toast + công đức (≥16, streak & dusk/night bump) + Sổ `coopRituals`
  - Online: inbox invite toast to partner + `publishWish` deed line; session `coopStreak` shown in Sổ
- How to test:
  1. Open game offline → walk to gác chuông (trái sân, ~(-9.5, -2))
  2. See cue / action **Cầu chung** → chọn **Cầu chung** → bấm **Đồng nhịp** trong ~6s → đợi nhịp NPC → success toast + merit pulse
  3. Mở **Sổ** → section **Cầu chung bên chuông**; lặp 2 lần để thấy chuỗi
  4. Chọn **Thỉnh một mình** vẫn mở minigame chuông cũ; quẻ / ấn / ngày đêm vẫn chạy
  5. (Optional online) 2 tab cùng link đứng gần chuông → Cầu chung với tên bạn remote + wish feed
- Known limits / next ideas for Agent 1:
  - Partner beat is soft-auto (presence), not a full two-client lockstep input sync
  - Co-op focused at chuông only (not mõ / incense yet)
  - Next GLOBAL ideas: weather/festival mood, deed cosmetics / nameplate flair, shared leaderboard of cầu chung
