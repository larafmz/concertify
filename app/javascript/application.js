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