# Hẻm Nem Thanh Hóa — Nhà Ông Chủ Nem Chua

## Wish being fulfilled
Players want a living culinary street beside Phố An Lạc: meet the chief who makes **nem chua Thanh Hóa**, read its history and recipe, then sit down and craft it step by step.

## Player fantasy loop
1. Discover → tip + sign at ngã ba Phở/Trà đá → Hẻm Nem
2. Interact → hub: lịch sử / công thức / ngồi làm nem
3. Reward → công đức + Sổ nhật ký
4. Escalate → hoàn thành 7 bước + đọc đủ sử/công thức → flair **Thợ Nem Thanh Hóa**
5. Show off → flair on merit chip / Sổ

## Implemented (index.html)
- [x] Side alley south of Phố An Lạc (`STREET_Z - Z`, avoids Hẻm Phóng Lợn +Z)
- [x] House + Ông Chủ Thanh + door glow + lamps
- [x] History modal + recipe/instruction modal (Vietnamese)
- [x] 7-step sit-and-craft workshop
- [x] Persist + Sổ section + flair
- [x] Proximity prompt / action button wiring

## How to test
1. FAB / P → Phố An Lạc
2. Walk toward Phở / Trà đá (−Z), follow **← Hẻm Nem Thanh Hóa**
3. Stand orange glow → **Ghé nhà · Nem Chua Thanh Hóa**
4. Read lịch sử + công thức; **Ngồi làm nem · từng bước** through all 7
5. Open Sổ → **🥩 Hẻm Nem Thanh Hóa**; unlock flair when history+recipe+1 mẻ done
