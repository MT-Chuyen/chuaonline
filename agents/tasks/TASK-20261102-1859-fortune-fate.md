# Fortune → short fate mini-event in the yard

## Wish being fulfilled
Xin quẻ should feel like *fate briefly opens a door* — not only a text modal. Players want a playful “run of destiny” they can only live out on this temple yard: chase a sign, touch a glowing spot, get a short exclusive moment + show-off reward.

## Player fantasy loop (addictive)
1. **Discover** — after xin quẻ, modal offers “Đi theo vận” / fate cue appears in yard  
2. **Interact** — walk to a glowing fate marker (or short 2–3 step path) tied to the quẻ rank  
3. **Reward** — mini VFX + toast + công đức burst + Sổ entry of the fate run  
4. **Escalate** — Đại Cát / rare ranks spawn richer markers or a tiny timed challenge; streak of fate runs in one session  
5. **Show off** — optional world toast / presence blip when completing a fate run online (deed, not idol)

## Must implement (in index.html)
- [x] **Hook from existing xin quẻ** — after `finishFortuneDraw` / “Nhận lời”, offer a clear CTA: e.g. button **Đi theo vận** (or auto-spawn marker if player dismisses with a short tip toast)
- [x] **Yard fate mini-event (30–60s max)** — spawn 1 primary glowing marker in the courtyard (reuse stamp-style mesh OR distinct gold/lotus cue). Near + action → complete event. Optional: 2-step path (marker A → marker B) for Trung Cát+; keep Đại Cát slightly juicier (extra VFX / +công đức)
- [x] **Outcome tied to quẻ** — use rank/title from `drawQue()` to pick flavor copy in Vietnamese + reward size (small table: Trung bình / Trung Cát / Đại Cát…). Persist a short line in Sổ (fortunes or new `fateRuns` list, max ~20)
- [x] **Feedback** — toast, pulse merit HUD, soft VFX/sound (reuse `playWhoosh` / `playBell` / existing particles if easy)
- [x] **Session loop** — player can xin quẻ again for another fate run; don’t soft-lock if they walk away (marker expires ~45–90s with gentle toast)
- [x] Keep mobile + desktop + FPS usable; reuse zones / action-btn / toast / gainCongDuc
- [x] **Do NOT** expand BTS / princess / idol romance

## Acceptance criteria
- Within ~30s of finishing a quẻ, player can start or see the fate hook
- Completing the yard event gives clear feedback (toast + công đức + Sổ trace)
- Feels exclusive / dreamlike — “quẻ vừa kéo mình ra sân”
- Touches GLOBAL fortune → yard fantasy (not a cameo NPC)
- No blank screen; existing incense/bell/stamps/day cycle still work
- No new BTS UI/actions

## Out of scope
- Full tarot / long dialogue trees
- Real astrology / personal data
- Weather rewrite, co-op bell (save for later iteration)
- BTS / princess feature work

## Notes for Agent 2
Reuse: `drawQue`, `finishFortuneDraw`, `actFortune`, `gainCongDuc`, `toast`, `openModal`, action-btn / `S.near*`, stamp marker patterns (`buildTempleStamps`), Sổ `openBook`, `publishPresence` only if a light online blip is easy.
Primary file: `index.html`.
Focus: `agents/FOCUS.md` — global systems ≥80%.
Prior ship: công đức tiers, day cycle, 3 stamps, deed titles — leave intact; fate runs should *feed* công đức, not replace stamps.

## Done report
- Files changed: `index.html` only
- What the player can do now:
  - After xin quẻ, modal shows **Đi theo vận** (or dismiss / Nhận lời → same spawn + tip toast)
  - Gold/lotus glowing yard markers appear (~55–80s TTL); Trung Cát+ = 2-step path; Đại/Thượng Cát = juicier VFX + more công đức
  - Walk to marker → action button **Theo vận** → toast + merit pulse + Sổ `fateRuns` entry; session streak bonus; light online wish blip
  - Walk away / timeout → gentle “vận đã khép” toast; xin quẻ again for another run
- How to test:
  1. Open game → walk to **Xin quẻ đầu năm** → lắc quẻ
  2. Tap **Đi theo vận** (or Nhận lời) → look for golden glowing marker(s) in courtyard
  3. Walk onto marker → action button → complete (2nd marker if Trung Cát+)
  4. Confirm toast + công đức chip pulse + Sổ section **Theo vận trên sân**
  5. Ignore a marker ~70s → expire toast; xin quẻ again; stamps / day cycle / incense still work
- Known limits / next ideas for Agent 1:
  - No compass/arrow to marker (player must scout the yard)
  - Online blip reuses wish feed (short deed line), not a dedicated fate channel
  - Next GLOBAL ideas: weather festival mood, co-op bell, title cosmetics from deeds
