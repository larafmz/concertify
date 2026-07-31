import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  // Cada vez que pulso tecla en text area de chats, aqui se comprueba si la tecla es ENTER, y si lo es se envia el mensaje
  submit(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.form.requestSubmit()
    }
  }

  // Cuando se envia un mensaje a chat, se resetea (se vacia) el text area
  reset(event) {
    if (event.detail.success) {
      this.element.reset()
      this.element.querySelector("textarea")?.focus()
    }
  }
  
}