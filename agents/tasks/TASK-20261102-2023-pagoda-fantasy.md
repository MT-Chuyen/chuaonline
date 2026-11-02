# Chuông Đảo Thời — chuông sân chùa đảo ngược thời gian

## Wish being fulfilled
Ai cũng từng ước **quay lại vài nhịp** — chuông ngân xong đời vẫn trôi thẳng. Game cho họ điều không thể IRL: **Chuông Đảo Thời** tại gác chuông sân chùa — thỉnh một nhịp đặc biệt và **thời gian sân chùa chạy ngược** vài giây (ánh ngày/đêm, cánh hoa, hành hương), rồi khóa lại như một phép lành.

## Player fantasy loop (addictive)
1. **Discover** — gần **gác chuông** (`bell` hotspot ~`-9.5, -2`) thấy vòng sáng tím/bạc + toast *“Chuông muốn đảo một nhịp thời gian…”* (sau ~20–35s trên sân, hoặc sau 1 lần thỉnh chuông thường / Sen Bay trong session)
2. **Interact** — prompt **「Đảo thời · thỉnh」** (tách khỏi thỉnh chuông thường / Cầu chung): player thỉnh → cửa sổ **đảo thời** ~6–10s: day-phase lerp ngược nhẹ, cánh hoa bay ngược, 1–2 pilgrim/NPC walk reverse hoặc đứng “đóng băng rồi lùi”, chuông glow xoáy
3. **Reward** — toast VN (*“Thời gian sân chùa vừa đảo một nhịp”*), `+công đức`, ghi Sổ; lần đầu mở stamp **Nhịp Đảo**; ban đêm / `calm` → hiệu ứng rõ hơn (reuse weather/day)
4. **Escalate** — tối thiểu 3 tầng trong session (hoặc persist best): **Giây** → **Khắc** → **Kiếp** — cửa sổ dài hơn / đảo day↔night rõ hơn / +merit lớn hơn lần đầu mỗi tầng; optional: “duyên” nếu vừa thắp hương hoặc vừa ngồi Sen Bay trước đó → dễ lên tầng kế
5. **Show off** — danh hiệu nhẹ **Người Đảo Thời** trên title/Sổ; bạn bè thấy flair nếu presence dễ gắn; Sổ section **⏳ Chuông Đảo Thời**

## Must implement (in index.html)
- [x] **Hotspot / mode Đảo Thời** tại gác chuông sân chùa — **không** phố / gate / shops / BTS. Có thể: (a) prompt thứ hai khi near bell + unlocked, hoặc (b) sau thỉnh thường có nút/chip **Đảo thời** trong ~8s. Prefer pattern interact hiện có (`S.busy`, Esc hủy)
- [x] **Cửa sổ rewind 6–10s**: visual rõ trong sân — ít nhất **2 trong 3**: (1) `timePhase`/sky tint lerp ngược hoặc day clock lùi tạm, (2) particle cánh hoa/smoke vận tốc đảo dấu, (3) 1–2 `PILGRIM` hoặc ambient props tween lùi nhẹ. Snap/restore state an toàn khi hết cửa sổ (không phá save day cycle dài hạn)
- [x] **Tầng escalate** ≥3: `giay` / `khac` / `kiep` — persist `chuongDaoBestTier` (+ optional `chuongDaoUses`) trong `saveAll`; lần đầu mỗi tầng → toast + Sổ + `gainCongDuc` lớn hơn
- [x] **VFX rẻ**: chuông emissive xoáy / ring pulse tím-bạc; không post-process stack; mobile cắt particle
- [x] **Sổ cầu an** section ngắn **⏳ Chuông Đảo Thời** — số lần đảo, tầng cao nhất, 1–3 dòng nhật ký
- [x] Soft hooks ≥1: thắp hương / Sen Bay vừa xong → `duyenDao` bump tier hoặc +1 công đức; night/`calm` → rewind đẹp hơn
- [x] UI copy **tiếng Việt** (prompt, toast, Sổ)
- [x] Mobile + desktop usable; FPS-safe; `S.busy` trong rewind; Esc/Hủy = cắt sớm + restore
- [x] Reuse: bell hotspot, `toast`, `gainCongDuc`, Sổ/`openBook`, day/weather, petals/smoke, pilgrim roots nếu dễ
- [x] **Do NOT** expand BTS / princess / idol romance
- [x] **Do NOT** expand Phố An Lạc / street shops / gate / đánh ghen
- [x] **Preserve** Sen Bay + tranh Ronaldo–Messi tường chính điện — không đụng trừ hook duyên nhẹ nếu cần

## Acceptance criteria
- Trong ~30s sau khi thấy vòng sáng / prompt Đảo Thời bên chuông, player **kích hoạt được** và thấy sân **chạy ngược** rõ ràng vài giây
- Feedback rõ: glow chuông + toast + ≥1 hệ thống thế giới đảo (sky/petals/NPC)
- Cảm giác *không thể IRL* — chuông chùa đảo thời gian sân
- Có lý do quay lại (tầng Giây→Khắc→Kiếp / stamp Sổ / công đức lần đầu tầng)
- GLOBAL ≥80%: **World living** (time paint) + **Exploration** (secret bell mode) + **Temple progression** (công đức/Sổ) — **pagoda / sân chùa only**
- Không blank screen; không phá Sen Bay, street gate (để nguyên), festival/streak/coop bell thường

## Out of scope
- Full timeline editor / save-scum toàn game state
- Cloud bridge / talking Buddha / petal dragon / sky-unfolding tháp (loop sau)
- Multiplayer synced rewind physics
- Street / BTS / princess work
- Heavy audio engine rewind scrubbing

## Notes for Agent 2
Primary file: `index.html`.
Landmark: bell interact `{ id: 'bell', pos: (-9.5, 0, -2) }` — gác chuông **trái sân**, đối diện phố (đừng kéo sang phố).
Reuse: thỉnh chuông minigame / `gainCongDuc('Thỉnh chuông…')`, day cycle (`S.timePhase`), weather mood, petal system, `PILGRIM_DEFS` groups, Sen Bay duyên pattern.
Focus: `agents/FOCUS.md` — pillar mix = **Impossible pagoda magic** + **World living** + light **Temple progression**.
Prior ships stay intact: Sen Bay, weather, streak, festival, fortune→fate, coop, pilgrims, street shops (untouched), Ronaldo–Messi wall poster.

## Director note (Agent 1 — GLOBAL loop iter 2/10)
Reviewed Sen Bay: solid discover→ride→tier→Sổ loop; tiny polish = once/session peak toast *“Nhìn xuống sân chùa — chỉ có trong mơ”*. Next vertical slice is **not** a Sen Bay sequel: **Chuông Đảo Thời** at the courtyard bell — IRL-impossible time rewind. No street.

## Done report
- Files changed: `index.html`
- What the player can do now: Near gác chuông (trái sân), after ~20–35s or after thắp hương / thỉnh chuông / Sen Bay, a purple-silver ring unlocks. Prompt **「Đảo thời · thỉnh」** rewinds courtyard time ~6–10s (sky/day clock, petals reverse, 1–2 pilgrims step back); Esc/Hủy restores. Tiers **Giây → Khắc → Kiếp**, first-tier merit + Sổ **⏳ Chuông Đảo Thời**, flair **Người Đảo Thời**. Night/`calm` and hương/Sen Bay duyên bump the fantasy.
- How to test: Enter play → wait ~25s or thắp hương once → walk to gác chuông (-9.5, -2) → tap **Đảo thời · thỉnh** → confirm sky tint / petals / pilgrims reverse, toast + công đức; Esc mid-window restores; repeat 3× for Khắc/Kiếp; open Sổ for section + flair. Confirm Sen Bay + street untouched.
- Known limits / next ideas for Agent 1: Rewind is visual-only (day clock snaps back). Presence flair is title-string only. Next IRL-impossible slice could be talking Buddha or cloud bridge — still sân chùa, no street/BTS.
