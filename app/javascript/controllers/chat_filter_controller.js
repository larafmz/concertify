import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "chat"]

  filter() {
    const search = this.inputTarget.value.toLowerCase().trim()

    this.chatTargets.forEach(chat => {
      const name = chat.dataset.chatName

      chat.style.display = name.includes(search) ? "" : "none"
    })
  }
}