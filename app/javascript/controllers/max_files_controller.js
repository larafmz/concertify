import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {
    if (event.target.files.length > 4) {
      alert("Solo puedes seleccionar 4 fotos.")
      event.target.value = ""
    }
  }
}