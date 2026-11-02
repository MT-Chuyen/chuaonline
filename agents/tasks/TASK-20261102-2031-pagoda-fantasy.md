# Tháp Mở Trời — bảo tháp sân chùa mở tầng lên mây

## Wish being fulfilled
Ai đứng trước bảo tháp cũng từng ước **các tầng mở ra trời** — mái tách, đài sáng, bước lên một nhịp mây. Game cho điều không thể IRL: **Tháp Mở Trời** tại `buildGrandPagoda` (~`0, -18.5`) — thỉnh một phép ngắn và **tháp sân chùa tự bung tầng lên cao**, người chơi đứng trên vành sáng bay theo vài giây rồi khép lại như một phép lành.

## Player fantasy loop (addictive)
1. **Discover** — gần **chân tháp** (sân trước tháp / mép `buildGrandPagoda`, không kéo sang phố) thấy vòng sáng vàng-trắng + toast *“Tháp muốn mở một tầng trời…”* (sau ~20–35s trên sân, hoặc sau 1 lần hương / Sen Bay / Chuông Đảo trong session)
2. **Interact** — prompt **「Mở tháp · lên tầng」** → cửa sổ **mở trời** ~10–16s: 2–4 tầng/mái lerp tách lên cao (scale/Y offset nhẹ), beam/glow dọc trục tháp, player (hoặc camera+avatar) **đứng trên vành sáng** nâng ~4–10m theo tầng đang mở; Esc/Hủy = hạ an toàn + tháp khép
3. **Reward** — toast VN (*“Tháp vừa mở một tầng trời”*), `+công đức`, ghi Sổ; lần đầu mở stamp **Tầng Trời**; ban đêm / `calm` → beam rõ hơn (reuse weather/day)
4. **Escalate** — tối thiểu 3 tầng trong session (hoặc persist best): **Nhất** → **Tam** → **Cửu** — mở cao hơn / nhiều mái hơn / merit lớn hơn lần đầu mỗi bậc; optional: “duyên” nếu vừa Sen Bay hoặc Chuông Đảo / thắp hương → dễ lên bậc kế
5. **Show off** — danh hiệu nhẹ **Khách Tầng Trời** trên title/Sổ; presence flair nếu dễ gắn; Sổ section **🏯 Tháp Mở Trời**

## Must implement (in index.html)
- [x] **Hotspot / mode Mở Trời** tại chân tháp sân chùa (~`0, -18.5`) — **không** phố / gate / shops / BTS. Prompt + `near` radius theo pattern Sen Bay / Chuông Đảo (`S.busy`, Esc hủy)
- [x] **Cửa sổ mở 10–16s**: visual rõ — ít nhất **2 trong 3**: (1) 2–4 roof/tier meshes của grand pagoda (hoặc proxy group nhẹ gắn tháp) **lerp Y/scale tách lên**, (2) beam/ring glow dọc trục + particle cánh hoa/gold dust bay lên, (3) player ride trên vành sáng (lerp Y theo avatar/`controls` pattern Sen Bay — không free-fly toàn map). Snap/restore tháp + player khi hết cửa sổ / Esc
- [x] **Tầng escalate** ≥3: `nhat` / `tam` / `cuu` — persist `thapMoBestTier` (+ optional `thapMoUses`) trong `saveAll`; lần đầu mỗi bậc → toast + Sổ + `gainCongDuc` lớn hơn
- [x] **VFX rẻ**: emissive beam vàng-trắng, ring pulse; không post-process stack; mobile cắt particle / ít tier proxy
- [x] **Sổ cầu an** section ngắn **🏯 Tháp Mở Trời** — số lần mở, bậc cao nhất, 1–3 dòng nhật ký
- [x] Soft hooks ≥1: thắp hương / Sen Bay / Chuông Đảo vừa xong → `duyenThap` bump bậc hoặc +1 công đức; night/`calm` → beam đẹp hơn
- [x] UI copy **tiếng Việt** (prompt, toast, Sổ)
- [x] Mobile + desktop usable; FPS-safe; `S.busy` trong cửa sổ; Esc/Hủy = hạ + restore tháp
- [x] Reuse: `buildGrandPagoda` / pagoda group nếu expose được, `toast`, `gainCongDuc`, Sổ/`openBook`, day/weather, petals, Sen Bay ride pattern
- [x] **Do NOT** expand BTS / princess / idol romance
- [x] **Do NOT** expand Phố An Lạc / street shops / gate / đánh ghen
- [x] **Preserve** Sen Bay, Chuông Đảo Thời, tranh Ronaldo–Messi tường chính điện, street UX (`goToStreetGate` → 20.2, `btn-street-fab`, KeyP, `chua_seen_street`, yellow path/arrow) — không đụng trừ hook duyên nhẹ nếu cần

## Acceptance criteria
- Trong ~30s sau khi thấy vòng sáng / prompt gần chân tháp, player **kích hoạt được** và thấy **tháp bung tầng + bản thân nâng theo** rõ ràng vài giây
- Feedback rõ: mái/tầng tách + toast + beam/particles (≥1)
- Cảm giác *không thể IRL* — bảo tháp sân chùa mở tầng lên mây
- Có lý do quay lại (Nhất→Tam→Cửu / stamp Sổ / công đức lần đầu bậc)
- GLOBAL ≥80%: **Impossible pagoda magic** + **Exploration** (secret tháp mode) + **Temple progression** (công đức/Sổ) — **pagoda / sân chùa only**
- Không blank screen; không phá Sen Bay, Chuông Đảo, street gate (để nguyên), festival/streak/coop bell thường

## Out of scope
- Full climbable interior tower / multi-floor physics dungeon
- Talking Buddha / cloud bridge / petal dragon (loop sau)
- Multiplayer synced tower unfold
- Street / BTS / princess work
- Heavy audio / skybox rewrite

## Notes for Agent 2
Primary file: `index.html`.
Landmark: `buildGrandPagoda(0, -18.5)` — tháp **phía sau sân**, đối diện chính điện (đừng kéo sang phố bên phải / gate).
Standing Buddha ~`0,-4.6` và Sen Bay đã chiếm đài sen giữa sân — **giữ nguyên**; hotspot mới chỉ ở **chân tháp**.
Nếu `buildGrandPagoda` không trả group dễ animate: tạo **proxy tier rings** gắn vị trí tháp (không clone heavy) + ẩn/hiện nhẹ khi mở.
Reuse: Sen Bay ride (`S.busy`, lerp Y, Esc hạ), Chuông Đảo unlock/duyên pattern, day/weather glow, petals.
Focus: `agents/FOCUS.md` — pillar mix = **Impossible pagoda magic** + **Exploration** + light **Temple progression**.
Prior ships stay intact: Sen Bay, Chuông Đảo Thời, weather, streak, festival, fortune→fate, coop, pilgrims, street shops (untouched), Ronaldo–Messi wall poster.

## Director note (Agent 1 — GLOBAL loop iter 3/10)
Reviewed Chuông Đảo Thời: solid discover→rewind→Giây/Khắc/Kiếp→Sổ; no polish-critical gaps (visual rewind + duyên + night boost ship). Next vertical slice is **not** a Chuông/Sen sequel: **Tháp Mở Trời** at grand pagoda — IRL-impossible sky-unfold. No street.

## Done report
- Files changed: `index.html`, `agents/tasks/TASK-20261102-2031-pagoda-fantasy.md`, `agents/loop-state.json`
- What the player can do now:
  - Sau ~22–35s trên sân (hoặc thắp hương / Sen Bay / Chuông Đảo) → vòng sáng vàng ở **chân tháp** (~`0, -10.85`) + toast *“Tháp muốn mở một tầng trời…”*
  - Gần vòng sáng · nút **「Mở tháp · lên tầng」** → mái tháp lerp bung lên, beam vàng-trắng, đứng trên vành sáng nâng ~5–10m (~11–16s)
  - Escalate session **Nhất → Tam → Cửu** (duyên bump bậc); lần đầu mỗi bậc +công đức lớn + nhật ký Sổ; danh hiệu **Khách Tầng Trời**
  - Esc / Hủy = hạ an toàn + tháp khép; đêm/`calm` beam rõ hơn
- How to test:
  1. Vào chơi → đi về **tháp phía sau sân** (không sang phố) · chờ toast unlock hoặc thắp 1 nén hương
  2. Đứng vòng sáng chân tháp → **Mở tháp · lên tầng** → thấy mái tách + bản thân nâng; Esc thử khép sớm
  3. Mở lại 2–3 lần trong session → bậc Tam/Cửu cao hơn; mở **Sổ** xem mục **🏯 Tháp Mở Trời**
  4. Smoke: Sen Bay vẫn ngồi được; Chuông Đảo vẫn đảo; P / nút phố / tranh Ronaldo–Messi không đổi
- Known limits / next ideas for Agent 1:
  - Chỉ animate mái/tip groups (thân tháp đứng yên) — đủ “bung tầng” nhưng chưa tách cả khối thân
  - Không sync multiplayer tháp mở; particle cắt trên mobile
  - Loop sau: cloud bridge / talking Buddha / petal dragon (đã out of scope)
