import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  connect() {
    this.category = this.inputTarget.dataset.searchCategory;
    this.userId = this.element.dataset.searchUserId;
    this.timeout = null;
    console.log("✅ Search Controller Connected. Category:", this.category, "UserID:", this.userId);
  }

  fetchResults(event) {
    const query = event.target.value.trim();
    const resultsContainer = this.resultsTarget;

    // タイマーが設定済みならクリアする
    clearTimeout(this.timeout);

    if (query.length < 2) {
      resultsContainer.innerHTML = "";
      resultsContainer.classList.add("hidden");
      return;
    }

    // 1秒入力がなければ検索を実行
    this.timeout = setTimeout(() => {
      const url = `/search?q=${encodeURIComponent(query)}&category=${encodeURIComponent(this.category)}&user_id=${encodeURIComponent(this.userId)}`;
      console.log("🔄 Fetch URL:", url);

      fetch(url)
        .then(response => response.json())
        .then(data => {
          console.log("📥 Data received:", data);
          if (data.length === 0) {
            resultsContainer.innerHTML = `<p class="p-2 text-gray-500">検索結果なし</p>`;
            resultsContainer.classList.remove("hidden");
            return;
          }
          resultsContainer.innerHTML = data.map(item => `
            <a href="${item.url}" class="block p-2 hover:bg-gray-100">
              <div class="flex items-center">
                ${item.image_url ? `<img src="${item.image_url}" alt="${item.name}" class="w-10 h-10 rounded-full mr-2">` : ""}
                <span>${item.name}</span>
              </div>
            </a>
          `).join("");
          resultsContainer.classList.remove("hidden");
        })
        .catch(error => console.error("❌ Error fetching search results:", error));
    }, 1000);
  }
}
