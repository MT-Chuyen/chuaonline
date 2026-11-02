# Sen Bay — Sen khổng lồ bay trên sân chùa

## Wish being fulfilled
Ai lên chùa cũng từng ước ngồi trong đóa sen khổng lồ treo lơ lửng trên sân — nhìn xuống tháp, tượng Phật, hồ sen — thanh tịnh kiểu chỉ có trong mơ. Game cho họ làm điều đó: **Sen Bay**, một đài sen sống biết nâng người lên trời chùa.

## Player fantasy loop (addictive)
1. **Discover** — tới gần **tượng Phật / đài sen giữa sân** (hoặc mép sân phía tháp `buildGrandPagoda`) thấy vòng sáng + prompt **「Ngồi Sen Bay」** / soft toast *“Đóa sen đang chờ bạn…”* (xuất hiện ~15–30s sau khi vào sân hoặc sau 1 act hương/chuông gần khu này)
2. **Interact** — bấm hành động → nhân vật ngồi vào lòng sen; sen **nâng lên** 4–8m trên sân (bay chậm, không teleport) trong ~12–20s cửa sổ; có thể **xuống sớm** bằng Hủy / hành động lần nữa
3. **Reward** — mưa cánh hoa + toast VN (*“Sen nâng bạn lên trời chùa”*), `+công đức` nhỏ, ghi Sổ; ban đêm / **Không khí an** thì sen phát sáng ấm hơn (reuse day + weather)
4. **Escalate** — lần 2–3 trong session (hoặc theo streak) mở tầng cao hơn: **Vân** → **Nguyệt** → **Tịnh** (cao hơn / xoay chậm / blessing dày hơn); lần đầu mỗi tầng = stamp/Sổ riêng + thưởng lớn hơn một chút
5. **Show off** — presence/nameplate hoặc Sổ hiện *Khách Sen Bay* / tầng cao nhất; bạn bè nhìn thấy bạn đang ngồi trên sen bay giữa sân (nếu multiplayer presence dễ gắn cờ; không thì ít nhất Sổ + danh hiệu nhẹ)

## Must implement (in index.html)
- [x] **Hotspot Sen Bay** gần đài sen / tượng Phật giữa sân (`buildStandingBuddha` ~`0,-4.6`) hoặc sàn trước tháp — **không** đẩy sang phố / BTS. Prompt + `near` radius giống interact chuông/hương
- [x] **Một mesh sen bay** (reuse geometry đài sen / petal nếu có; 1 group nhẹ): idle glow trên mặt đất → sit → lerp lên cao → hover → hạ xuống. Không physics nặng, không multi-lotus swarm
- [x] **Cửa sổ ride** 12–20s với HUD/tiny chip hoặc toast countdown nhẹ; Hủy = hạ sen an toàn về chỗ cũ; `S.busy` / interact pattern hiện có
- [x] **Tầng escalate** tối thiểu 3: `van` / `nguyet` / `tinh` — persist `senBayBestTier` (và optionally `senBayRides`) trong `saveAll`; lần đầu mỗi tầng → toast + Sổ line + `gainCongDuc`
- [x] **VFX rẻ**: particle cánh hoa / soft light (reuse particle helpers nếu có); không post-process stack; tắt/bớt trên mobile nếu FPS thấp (theo pattern particle rain hiện có)
- [x] **Sổ cầu an** section ngắn **🪷 Sen Bay** — số lần ngồi, tầng cao nhất, 1–3 dòng nhật ký gần đây
- [x] Soft hooks (optional nhưng nên có ≥1): thắp hương hoặc thỉnh chuông *trước* khi ngồi → lần đó dễ lên tầng kế / +1 công đức “duyên sen”; ban đêm hoặc weather `calm` → glow đẹp hơn
- [x] UI copy **tiếng Việt** (prompt, toast, Sổ) nơi game đã dùng VN
- [x] Mobile + desktop usable; FPS-safe (1 lotus + ≤1 particle burst)
- [x] Reuse: `toast`, `gainCongDuc`, Sổ/`openBook`, day cycle, weather mood, interact/`S.busy`, particles
- [x] **Do NOT** expand BTS / princess / idol romance
- [x] **Do NOT** expand phố shops / gossip this pass

## Acceptance criteria
- Trong ~30s sau khi tìm thấy vòng sáng đài sen, player **ngồi được lên Sen Bay** và thấy mình nhấc khỏi mặt đất
- Feedback rõ: animation nâng + toast + cánh hoa (và/hoặc ánh sáng)
- Cảm giác *không thể IRL* — ngồi trong sen khổng lồ trên sân chùa
- Có lý do quay lại (tầng cao hơn / stamp Sổ / công đức lần đầu tầng)
- GLOBAL ≥80%: exploration + temple progression + world living paint — **pagoda / sân chùa** fantasy, không cameo
- Không blank screen; không phá day/weather/festival/streak/công đức hiện có

## Out of scope
- Cloud bridge tới mặt trăng / tháp biến thành cung điện (để loop sau)
- Speak-with-Buddha dialogue tree đầy đủ
- Real flight free-cam toàn map
- BTS / princess / street shop work
- Heavy audio engine hoặc network-synced lotus physics

## Notes for Agent 2
Primary file: `index.html`.
Landmarks: `buildStandingBuddha(0, -4.6)`, `buildGrandPagoda(0, -18.5)`, hồ sen phía trước — keep ride **in courtyard vertical space**, not over street.
Reuse patterns from weather particles, Giờ hội VFX, interact hotspots (`bell` style), `gainCongDuc`, Sổ sections.
Focus: `agents/FOCUS.md` — no BTS; pillar mix = **Exploration** (secret ride) + **Temple progression** (công đức/Sổ) + light **World living** (night/calm glow).
Prior ships stay intact: weather, streak goals, festival, fortune→fate, coop, pilgrims, street shops.

## Director note (Agent 1 — GLOBAL loop iter 1/10)
Fresh GLOBAL restart. Assigning one strong pagoda fantasy vertical slice: **Sen Bay**. Agent 2 implements; Agent 1 will review next round for addiction polish + next courtyard wonder if needed.

## Done report
- Files changed: `index.html` only (courtyard Sen Bay; no street/gate/shop edits)
- What the player can do now:
  - After ~18–28s in sân (or sooner after thắp hương / thỉnh chuông), a glowing **Sen Bay** lotus appears in front of the standing Buddha (`0,-1.35`)
  - Walk up → **「Ngồi Sen Bay」** → sit; lotus rises ~4.6–7.8m, hovers ~12–20s total, then descends
  - **Hủy** / Esc mid-ride safely lowers the lotus
  - Session rides escalate **Vân → Nguyệt → Tịnh**; incense/bell “duyên” bumps tier +1 and +1 công đức; night/`calm` warms the glow
  - First visit each tier stamps Sổ + bigger công đức; flair **Khách Sen Bay** on title / Sổ section **🪷 Sen Bay**
- How to test:
  1. Open `index.html`, enter game, walk to center courtyard near Buddha/đài sen (south of statue toward lư hương)
  2. Wait for toast *“Đóa sen đang chờ bạn…”* (~20s) **or** thắp hương / thỉnh chuông first to unlock early
  3. Stand in pink glow → tap **Ngồi Sen Bay** → confirm lift-off + petal burst + toast
  4. Tap **Hủy · hạ sen** or Esc to descend early; ride again for Nguyệt / Tịnh
  5. Open **Sổ** → section **🪷 Sen Bay** shows rides, best tier, log lines
- Known limits / next ideas for Agent 1:
  - Presence does not yet sync a live “on lotus” pose to remotes (title flair only via `publishPresence`)
  - No multiplayer shared lotus / co-op rise
  - Next courtyard wonder candidates: cloud bridge, talking Buddha, time-rewind chuông (still no street)
