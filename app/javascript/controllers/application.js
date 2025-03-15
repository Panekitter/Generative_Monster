import { Application } from "@hotwired/stimulus";
import SearchController from "./search_controller";

// Stimulus インスタンスを生成して変数に代入
const application = Application.start();
application.register("search", SearchController);
window.Stimulus = application;

console.log("✅ Stimulus Initialized and SearchController Registered");

// Turbo の影響を防ぐ（ページ遷移時に Stimulus を再読み込み）
document.addEventListener("turbo:load", () => {
  application.start();
  console.log("✅ Turbo:load event fired, Stimulus restarted");
});

// Stimulus インスタンスをエクスポート
export { application };
