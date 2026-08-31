// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"
import "jquery";
import "cocoon";

window.addEventListener("pageshow", () => {
  document.querySelectorAll("dialog[open]").forEach((dialog) => {
    dialog.close()
  })
})

import { Turbo } from "@hotwired/turbo-rails"

Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.getAttribute("target"))
}

// second date selector in event filters permits dates after first selector
document.addEventListener("DOMContentLoaded", () => {
  const firstDate = document.getElementById("first_date")
  const secondDate = document.getElementById("second_date")

  if (!firstDate || !secondDate) return

  const updateMinDate = () => {
    secondDate.min = firstDate.value

    if (
      secondDate.value &&
      firstDate.value &&
      secondDate.value < firstDate.value
    ) {
      secondDate.value = firstDate.value
    }
  }

  updateMinDate()
  firstDate.addEventListener("change", updateMinDate)
})