import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

   static values = {
    message: String
  }

  //  Used to show alert message when "mark as favorite" and user has more than 4 artists as favorites
  show() {
    window.alert(this.messageValue)
  }

}