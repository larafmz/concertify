import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "counter"]

  connect() {
    this.update()
  }

  update() {
    const max = this.inputTarget.maxLength
    const current = this.inputTarget.value.length
    this.counterTarget.textContent = `${current}/${max}`
  }
}