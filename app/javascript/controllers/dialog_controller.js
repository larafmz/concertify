import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.closeOnCache = this.closeOnCache.bind(this)
    document.addEventListener("turbo:before-cache", this.closeOnCache)

    this.element.showModal()
    document.body.style.overflow = "hidden"
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.closeOnCache)
  }

  close() {
    document.body.style.overflow = ""
    this.element.close()
    this.resetFrame()
  }

  closeOnCache() {
    if (this.element.open) {
      this.close()
    }
  }

  resetFrame() {
    const frame = document.getElementById("modal")
    if (frame) frame.innerHTML = ""
  }
}