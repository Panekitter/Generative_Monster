import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: String }

  connect() {
    console.log("DeleteCharacter controller connected")
    console.log("ID Value:", this.idValue)
    
    // グローバルイベントリスナーを追加
    document.addEventListener("turbo:submit-success", this.handleSuccess.bind(this))
  }

  disconnect() {
    // コントローラーが切断されるときにイベントリスナーを削除
    document.removeEventListener("turbo:submit-success", this.handleSuccess.bind(this))
  }

  confirm(event) {
    console.log("Confirm method called")
    if (!confirm("本当に削除してよろしいですか？")) {
      event.preventDefault()
    } else {
      console.log("Deletion confirmed")
    }
  }

  // 成功イベントのハンドラー
  handleSuccess(event) {
    console.log("Success event received", event)
    // フォームのaction URLにこのキャラクターのIDが含まれているか確認
    if (event.detail && event.detail.formSubmission) {
      const formUrl = event.detail.formSubmission.formElement.action
      const characterId = this.idValue
      console.log("Checking URL:", formUrl, "for character ID:", characterId)
      if (formUrl.includes(`/characters/${characterId}`)) {
        console.log("URL match found, removing element")
        this.removeElement()
      }
    }
  }

  removeElement() {
    const id = this.idValue
    console.log("Attempting to remove element with ID:", `character-${id}`)
    const element = document.getElementById(`character-${id}`)
    console.log("Element to remove:", element)
    if (element) {
      element.remove()
      console.log(`Character ${id} removed from DOM`)
    } else {
      console.log("Element not found in DOM")
    }
  }

  // 元のメソッドも残しておく
  remove() {
    console.log("Original remove method called")
    this.removeElement()
  }
}