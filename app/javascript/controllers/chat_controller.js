import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { chatId: Number }

  connect() {
    this.scrollToBottom()

    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
      this.markAsRead()
    })

    this.observer.observe(this.element, {
      childList: true
    })
  }

  disconnect() {
    this.observer.disconnect()
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }

  markAsRead() {
    fetch(`/chats/${this.chatIdValue}/mark_as_read`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      }
    })
  }

}