# Princess Mode loop 2 — parade, persist, soft commands, show-off

## Wish being fulfilled
Being a công chúa once is cute; staying one, ordering soft commands (hát / cúi chào), leading a parade, and having *other players see the title* is the addictive fantasy IRL never allows.

## Player fantasy loop (addictive)
1. **Discover** — Princess Mode + courtyard secrets (already shipped)  
2. **Interact** — soft commands + parade / group-photo emote  
3. **Reward** — title persists across reload; new collectible unlocks extra idol lines  
4. **Escalate** — multiplayer nameplate / toast shows “👑 Công Chúa …” to nearby players  
5. **Show off** — parade or group photo moment others can witness online

## Must implement (in index.html)
- [ ] **Công chúa parade / group photo emote**
  - New BTS bar or modal action: e.g. **Diễu hành** or **Chụp ảnh nhóm**
  - Living escorts briefly line up / pose; sparkle burst + toast (“công chúa diễu hành!”)
  - Reuse escort slots + existing burst VFX; keep mobile-friendly
- [ ] **Persist royal title** (localStorage via existing `loadSave` / `saveAll`)
  - Save: `btsPrincessTitle`, `btsRoyalRing`, secret flags (`btsSecretLotus`, `btsSecretLantern`)
  - On load: restore chip HUD; do **not** auto-force Princess Mode on (player toggles again)
- [ ] **1+ new explore secret / collectible** near temple
  - Glowing spot unlocks a batch of exclusive idol lines (or a tiny “crown” session buff)
  - Clear world label + action-btn when near (match Sen/Đèn pattern)
- [ ] **Funnier serve + random soft commands** while Princess Mode is on
  - Occasional soft-command beats: idol “hát” (short toast + tiny bounce) or “cúi chào” (reuse bow)
  - Expand serve lines; keep cadence non-spammy (~8–14s)
- [ ] **Show-off title to other players** (multiplayer hooks exist)
  - Publish `title` / `princess: true` (or prefix) on presence (`publishPresence` / `players/${uid}`)
  - Remote nameplate shows `👑 ${title}` when set; optional toast when a công chúa walks near
- [ ] UI copy Vietnamese; mobile + desktop usable
- [ ] Reuse Princess Mode / BTS / Firebase presence — no full rewrite

## Acceptance criteria
- Player can trigger parade or group-photo within ~30s of Princess Mode
- Reload keeps royal title / ring / secrets; chip can show title again after re-enable or immediately if ring/title saved
- At least one new secret collectible with clear feedback
- Soft command (hát or cúi chào) visible as toast + simple motion within a short play session
- Online: another client (or code path) can display the royal title on the remote label
- No blank screen / FPS toggle still works

## Out of scope
- No real personal data harvesting beyond existing anonymous Firebase presence
- No sexual content; keep soft romance / fan-fantasy tone
- No full dialogue tree / new networking stack

## Notes for Agent 2
Reuse: `togglePrincessMode`, `tickPrincessService`, `buildPrincessSecrets`, `publishPresence`, `remotePlayers` labels, `loadSave`/`saveAll`, `spawnPrincessBurst`.
Primary file: `index.html`.
Director polish already done this iteration: funnier bow/serve lines, HUD pulse + secret-progress chip hints, courtyard tip labels, one-time secret discovery nudge after enabling Princess Mode.
