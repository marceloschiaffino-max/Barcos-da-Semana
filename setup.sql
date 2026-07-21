:root {
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  color: #172033;
  background: #eef3fb;
  font-synthesis: none;
}
* { box-sizing: border-box; }
body { margin: 0; min-width: 320px; min-height: 100vh; }
button, input { font: inherit; }
button { cursor: pointer; }
.app-shell { width: min(980px, 100%); margin: 0 auto; padding: 22px 18px 36px; }
.topbar { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 18px; }
.eyebrow { margin: 0 0 4px; font-size: 12px; letter-spacing: .15em; font-weight: 800; color: #55709f; }
h1 { margin: 0; font-size: clamp(27px, 5vw, 40px); letter-spacing: -.04em; }
.save-state { display: flex; align-items: center; gap: 7px; padding: 8px 12px; border-radius: 999px; background: #fff; box-shadow: 0 3px 14px rgba(35, 55, 90, .08); font-size: 13px; color: #58705c; }
.save-state.error { color: #a93434; }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.week-picker { display: grid; grid-template-columns: 44px 1fr 44px; align-items: center; background: #fff; border-radius: 18px; padding: 10px; box-shadow: 0 10px 30px rgba(50, 70, 110, .08); }
.week-picker button { width: 38px; height: 38px; border: 0; border-radius: 12px; background: #eef3fb; color: #3f5f93; display: grid; place-items: center; }
.week-picker div { text-align: center; display: flex; flex-direction: column; gap: 2px; }
.week-picker span { font-size: 13px; color: #6c778c; text-transform: capitalize; }
.day-tabs { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin: 16px 0; }
.day-tabs button { border: 0; border-radius: 15px; padding: 11px 8px; background: #dfe8f6; color: #597096; display: flex; flex-direction: column; gap: 2px; align-items: center; }
.day-tabs button.active { background: #2e61a8; color: white; box-shadow: 0 8px 18px rgba(46, 97, 168, .25); }
.day-tabs span { font-size: 18px; font-weight: 800; }
.day-tabs small { opacity: .8; }
.notice { margin: 12px 0; padding: 11px 14px; border-radius: 12px; background: #e4f5e8; color: #245d31; font-size: 14px; }
.notice.error { background: #fde8e8; color: #8f2727; }
.schedule { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; align-items: start; }
.time-card { background: #fff; border-radius: 20px; overflow: hidden; box-shadow: 0 12px 30px rgba(42, 65, 105, .09); }
.time-heading { padding: 18px 18px 14px; background: linear-gradient(135deg, #dbeaff, #eef5ff); display: flex; justify-content: space-between; align-items: baseline; }
.time-heading h2 { margin: 0; font-size: 24px; }
.time-heading span { font-size: 13px; color: #597096; }
.boats { padding: 14px; display: flex; flex-direction: column; gap: 12px; }
.boat { border: 1px solid #dfe7f2; border-radius: 15px; overflow: hidden; }
.boat-title { padding: 10px 12px; background: #f6f8fc; display: flex; justify-content: space-between; align-items: center; }
.boat-title small { color: #8792a5; }
.seats { padding: 10px; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8px; }
.boat:nth-child(3) .seats, .boat:nth-child(4) .seats { grid-template-columns: 1fr; }
.seat { display: flex; align-items: center; min-width: 0; }
.seat input { width: 100%; min-width: 0; border: 1px solid #d5deeb; border-radius: 10px; padding: 10px 11px; color: #172033; background: white; outline: none; }
.seat input:focus { border-color: #4f7ec0; box-shadow: 0 0 0 3px rgba(79, 126, 192, .13); }
.side { align-self: stretch; min-width: 38px; display: grid; place-items: center; background: #e8eef8; color: #3d5f91; font-weight: 900; border-radius: 10px 0 0 10px; }
.side + input { border-radius: 0 10px 10px 0; }
.actions { margin-top: 18px; display: flex; flex-wrap: wrap; gap: 10px; }
.actions button { border: 1px solid #d4deec; border-radius: 12px; padding: 11px 14px; display: inline-flex; gap: 8px; align-items: center; justify-content: center; background: white; color: #31445f; }
.actions .primary { background: #2e61a8; color: white; border-color: #2e61a8; }
.actions .danger { color: #a12c2c; }
footer { text-align: center; color: #737f93; font-size: 13px; margin-top: 22px; }
.setup { min-height: 100vh; display: grid; place-items: center; padding: 20px; }
.setup-card { max-width: 520px; background: white; border-radius: 20px; padding: 28px; box-shadow: 0 12px 35px rgba(0,0,0,.08); }
.setup-card code { display: block; padding: 10px; margin: 8px 0; border-radius: 8px; background: #f1f4f8; overflow-wrap: anywhere; }
@media (max-width: 720px) {
  .app-shell { padding: 16px 12px 28px; }
  .topbar { align-items: flex-start; }
  .save-state span { display: none; }
  .schedule { grid-template-columns: 1fr; }
  .time-card { border-radius: 17px; }
  .actions { display: grid; grid-template-columns: 1fr 1fr; }
  .actions button { padding: 11px 8px; font-size: 13px; }
}
@media (max-width: 390px) {
  .seats { grid-template-columns: 1fr; }
  .day-tabs { gap: 5px; }
}
