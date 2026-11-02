# Princess service + addictive BTS fantasy loop

## Wish being fulfilled
Players wish they could be noticed, spoiled, and “owned the moment” by idols — kiss, marry, be carried, be followed, be treated like royalty. Real life never allows that. The game should.

## Player fantasy loop (addictive)
1. **Discover** — find BTS near temple / fanmeet sign  
2. **Interact** — selfie / chat / hug (already partly there)  
3. **Reward** — kiss, marry, husband follows  
4. **Escalate** — unlock **Princess Mode**: members bow, fan the player, bring “tea”, call the player “công chúa”, form a soft escort circle  
5. **Show off** — world toast + floating hearts; optional “royal title” that persists in session HUD

## Must implement (in index.html)
- [x] Add a clear in-world / UI entry: **“Chế độ Công Chúa”** (Princess Mode) when near BTS or after marry/husband
- [x] Princess Mode behaviors for living BTS members near player:
  - soft follow / escort formation (reuse husband-follow patterns where possible)
  - periodic bow / “dạ công chúa” toast lines (Vietnamese, cute, not spammy)
  - optional “serve” action: one member pretends to offer tea / fan (simple prop or emoji VFX is OK)
- [x] Keep existing kiss / bế / husband follow working
- [x] Add 1–2 **secret explore hooks** near temple (sign or glowing spot) that unlocks an extra line or a “royal ring” buff (session-only is fine)
- [x] Mobile-friendly buttons in existing BTS action UI
- [x] Make it feel exclusive: short sparkle/heart burst when Princess Mode starts

## Acceptance criteria
- Within ~30s of meeting BTS, player can enter Princess Mode
- At least 2 visible “they serve me” moments (bow + serve/toast)
- Feature still works if some members are dead/despawned
- No blank screen / no broken FPS toggle

## Out of scope
- No real money / real personal data
- No sexual content; keep soft romance / fan-fantasy tone
- No full dialogue tree rewrite

## Notes for Agent 2
Reuse: `S.btsHusbandId`, `S.btsCarryId`, `updateBts`, existing BTS action panel, kiss/carry/marry UI.
Primary file: `index.html`.

## Done report
- Files changed: `index.html` (CSS/HUD/BTS bar + Princess Mode logic, secrets, VFX); this task file.
- What the player can do now:
  - Near BTS (or with BTS bar open): tap **Chế độ Công Chúa** (bar + modal) to toggle Princess Mode.
  - Living idols form a soft escort circle; husband still follows (or joins escort when several are alive).
  - Periodic bows + Vietnamese toasts (“dạ công chúa…”); serve tea/fan with prop + toast.
  - Kiss / bế / làm chồng keep working; dead members are skipped.
  - Explore glowing spots: **Sen ẩn** (~5.4, −1.6) → session **Nhẫn Hoàng Gia**; **Đèn ẩn** (~−8.2, 3.6) → extra line.
  - Sparkle/heart burst + HUD chip `👑 Công Chúa` when mode (or ring) is on.
- How to test:
  1. Enter game → walk to BTS fanmeet near gate (~−6.5, 9.2).
  2. Open BTS actions → **Chế độ Công Chúa** → confirm burst, escort, bow/serve toasts within ~15s.
  3. Try hôn / bế / làm chồng while mode is on.
  4. Walk to sen glow (east of sân) and đèn glow (near chuông area); collect both.
  5. Toggle FPS (V / nút 3rd) and reload — no blank screen.
- Known limits / next ideas for Agent 1:
  - Royal ring / princess title are session-only (not in localStorage).
  - Serve props are simple meshes (cup/fan), not full animations.
  - Could later persist title in Sổ or add a short “công chúa parade” emote.
