import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {
    const max = parseInt(this.element.dataset.maxFiles)

    if (event.target.files.length > max) {
      alert(this.element.dataset.maxFilesMessage)
      event.target.value = ""
    }
  }
}