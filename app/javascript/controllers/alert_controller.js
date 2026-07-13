import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

   static values = {
    message: String
  }

  show() {
    window.alert(this.messageValue)
  }

}