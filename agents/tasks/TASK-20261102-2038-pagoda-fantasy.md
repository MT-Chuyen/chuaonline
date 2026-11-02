# Phật Nói · Lời Vàng — tượng Phật sân chùa nói lời vàng

## Wish being fulfilled
Ai đứng trước tượng Phật cũng từng ước **Ngài thật sự nói** — một lời an ủi chỉ dành cho mình. Game cho điều không thể IRL: **Phật Nói · Lời Vàng** tại `buildStandingBuddha(0, -4.6)` — thỉnh nghe một phép ngắn và **tượng Phật sân chùa mở lời**, chữ vàng bay quanh sân, không khí dịu lại vài giây như pháp thoại sống.

## Player fantasy loop (addictive)
1. **Discover** — gần **chân tượng Phật đứng** (~`0, -4.6`, không kéo sang Sen Bay `0,-1.35` / phố) thấy hào quang vàng-trắng mềm + toast *“Tượng Phật muốn nói một lời…”* (sau ~20–35s trên sân, hoặc sau 1 lần hương / Sen Bay / Chuông Đảo / Tháp Mở trong session)
2. **Interact** — prompt **「Nghe Phật · lời vàng」** → cửa sổ **pháp thoại** ~9–14s: (1) tượng glow nhẹ (emissive / point light vàng), (2) 1–3 dòng chữ VN vàng bay xoay quanh tượng (textPlane / sprite nhẹ), (3) cánh hoa / gold dust kéo về phía player; Esc/Hủy = kết thúc sớm, khôi phục glow. **Không** free-fly / không ride thay Sen Bay
3. **Reward** — toast VN (*“Phật vừa nói một lời vàng”*), `+công đức`, ghi Sổ; lần đầu nghe stamp **Lời Vàng**; ban đêm / `calm` → chữ + hào quang rõ hơn (reuse weather/day)
4. **Escalate** — tối thiểu 3 bậc trong session (hoặc persist best): **An** → **Từ** → **Giác** — nhiều dòng chữ hơn / vòng chữ rộng hơn / merit lớn hơn lần đầu mỗi bậc; optional: “duyên” nếu vừa hương / Sen Bay / Chuông Đảo / Tháp Mở → dễ lên bậc kế
5. **Show off** — danh hiệu nhẹ **Khách Nghe Pháp** trên title/Sổ; presence flair nếu dễ gắn; Sổ section **🙏 Phật Nói · Lời Vàng**

## Must implement (in index.html)
- [x] **Hotspot / mode Phật Nói** tại chân tượng Phật đứng (~`0, -4.6`) — radius **không** chồng Sen Bay (`SEN_BAY_SPOT` ~`0,-1.35`). **Không** phố / gate / shops / BTS. Prompt + `near` theo pattern Sen Bay / Chuông Đảo / Tháp Mở (`S.busy`, Esc hủy)
- [x] **Cửa sổ pháp thoại 9–14s**: visual rõ — ít nhất **2 trong 3**: (1) glow/emissive nhẹ trên `buildStandingBuddha` group (hoặc light + aura ring proxy quanh tượng, không cần morph khuôn mặt), (2) 1–3 `textPlane` chữ VN vàng bay/xoay quanh tượng rồi tan, (3) petal/gold dust burst kéo về player. Snap/restore materials + lights khi hết cửa sổ / Esc
- [x] **Bậc escalate** ≥3: `an` / `tu` / `giac` — persist `phatNoiBestTier` (+ optional `phatNoiUses`) trong `saveAll`; lần đầu mỗi bậc → toast + Sổ + `gainCongDuc` lớn hơn. Copy mẫu ngắn (đổi câu theo bậc): *“An lòng như sen giữa sân”* / *“Từ bi mở cửa mỗi bước”* / *“Giác một niệm · sáng cả sân”*
- [x] **VFX rẻ**: emissive vàng-trắng, ring pulse dưới chân tượng; không post-process stack; mobile cắt particle / ít textPlane
- [x] **Sổ cầu an** section ngắn **🙏 Phật Nói · Lời Vàng** — số lần nghe, bậc cao nhất, 1–3 dòng nhật ký
- [x] Soft hooks ≥1: thắp hương / Sen Bay / Chuông Đảo / Tháp Mở vừa xong → `duyenPhat` bump bậc hoặc +1 công đức; night/`calm` → chữ đẹp hơn
- [x] UI copy **tiếng Việt** (prompt, toast, dòng pháp, Sổ)
- [x] Mobile + desktop usable; FPS-safe; `S.busy` trong cửa sổ; Esc/Hủy = kết thúc + restore
- [x] Reuse: `buildStandingBuddha` / statue group nếu expose được, `toast`, `gainCongDuc`, Sổ/`openBook`, day/weather, petals, unlock/duyên pattern từ Sen/Chuông/Tháp
- [x] **Do NOT** expand BTS / princess / idol romance
- [x] **Do NOT** expand Phố An Lạc / street shops / gate / đánh ghen
- [x] **Preserve** Sen Bay, Chuông Đảo Thời, Tháp Mở Trời, tranh Ronaldo–Messi tường chính điện, street UX (`goToStreetGate` → 20.2, `btn-street-fab`, KeyP, `chua_seen_street`, yellow path/arrow) — không đụng trừ hook duyên nhẹ nếu cần

## Acceptance criteria
- Trong ~30s sau khi thấy hào quang / prompt gần tượng Phật, player **kích hoạt được** và thấy **tượng “nói” + chữ vàng bay** rõ ràng vài giây
- Feedback rõ: glow + chữ/toast + particles (≥1)
- Cảm giác *không thể IRL* — tượng đá/thạch cao sân chùa thật sự mở lời
- Có lý do quay lại (An→Từ→Giác / stamp Sổ / công đức lần đầu bậc)
- GLOBAL ≥80%: **Impossible pagoda magic** + **Fortune/sacred calm** + light **Temple progression** — **pagoda / sân chùa only**
- Không blank screen; không phá Sen Bay, Chuông Đảo, Tháp Mở, street gate (để nguyên), festival/streak/coop bell thường

## Out of scope
- Full lip-sync / TTS / recorded voice acting
- Cloud bridge / petal dragon / moon walk / invisible monks (loop sau)
- Multiplayer synced Buddha speech
- Street / BTS / princess work
- Heavy audio / skybox rewrite
- Moving the standing Buddha or replacing Sen Bay hotspot

## Notes for Agent 2
Primary file: `index.html`.
Landmark: `buildStandingBuddha(0, -4.6)` — tượng **giữa sân**, phía trước tháp / sau đài sen Sen Bay. Hotspot nên hơi lệch về phía tượng (vd. z ≈ `-4.6` ±0.4) với `r` nhỏ (~2.0–2.2) để **không** nuốt `SEN_BAY_SPOT` (`z≈-1.35`).
Nếu `buildStandingBuddha` không trả group dễ animate: lưu `S.standingBuddha` khi build + aura proxy riêng (ring + light) quanh chân tượng.
Reuse: Sen/Chuông/Tháp unlock + `S.busy` + Esc cancel + duyên chain + day/weather glow + petals + Sổ section pattern.
Focus: `agents/FOCUS.md` — pillar mix = **Impossible pagoda magic** + sacred calm / fortune-feel + light **Temple progression**.
Prior ships stay intact: Sen Bay, Chuông Đảo Thời, Tháp Mở Trời, weather, streak, festival, fortune→fate, coop, pilgrims, street shops (untouched), Ronaldo–Messi wall poster.

## Director note (Agent 1 — GLOBAL loop iter 4/10)
Reviewed Tháp Mở Trời: solid discover→unfold→Nhất/Tam/Cửu→Sổ ride; no polish-critical gaps (roof lerp + beam + pad ride + duyên + night boost ship). Next vertical slice is **not** a Tháp/Sen/Chuông sequel: **Phật Nói · Lời Vàng** at standing Buddha — IRL-impossible talking statue. No street.

## Done report
- Files changed: `index.html`, `agents/tasks/TASK-20261102-2038-pagoda-fantasy.md`, `agents/loop-state.json`
- What the player can do now:
  - Sau ~20–35s (hoặc sau hương / Sen Bay / Chuông Đảo / Tháp Mở) thấy hào quang vàng dưới chân tượng Phật đứng (~0, -4.6) + toast *“Tượng Phật muốn nói một lời…”*
  - Gần tượng → **「Nghe Phật · lời vàng」** → pháp thoại ~9–14s: tượng glow, chữ vàng bay xoay, cánh hoa/gold dust kéo về mình; Esc/Hủy kết thúc sớm
  - Bậc **An → Từ → Giác** (duyên bump); lần đầu mỗi bậc + công đức lớn; stamp **Lời Vàng** / danh hiệu **Khách Nghe Pháp**; Sổ section 🙏 Phật Nói · Lời Vàng
- How to test:
  1. Vào chơi, đứng gần tượng Phật giữa sân (sau đài sen, trước tháp) — chờ toast discover hoặc thắp hương để unlock sớm
  2. Bấm **Nghe Phật · lời vàng** — xác nhận glow + chữ bay + particles; Esc hủy restore
  3. Nghe 3 lần / dùng duyên để lên Từ/Giác; mở Sổ kiểm tra nhật ký + flair
  4. Smoke: Sen Bay vẫn ngồi được; Tháp Mở / Chuông Đảo / phố (P / FAB) / poster Ronaldo–Messi không đổi
- Known limits / next ideas for Agent 1:
  - Không TTS / lip-sync; chữ là textPlane orbit (mobile ≤2 dòng)
  - Overlap radius với Sen Bay có guard “gần đâu thắng” — có thể tinh chỉnh prompt khoảng trống giữa hai hotspot
  - Gợi ý loop sau: petal dragon / cloud bridge / monks vô hình (đúng Out of scope task này)
