import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.showModal()
    document.body.style.overflow = "hidden"
  }

  close() {
    document.body.style.overflow = ""
    this.element.close()
  }
}
