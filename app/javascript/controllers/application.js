import { Application } from "@hotwired/stimulus";
import SearchController from "./search_controller";

window.Stimulus = Application.start();
Stimulus.register("search", SearchController);

console.log("✅ Stimulus Initialized and SearchController Registered");

// Turbo の影響を防ぐ（ページ遷移時に Stimulus を再読み込み）
document.addEventListener("turbo:load", () => {
  Stimulus.start();
  console.log("✅ Turbo:load event fired, Stimulus restarted");
});
