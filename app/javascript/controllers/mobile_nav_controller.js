import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="mobile-nav"
export default class extends Controller {
  static targets = ["toggle", "menu"];

  connect() {
    // Ensure the menu starts hidden on connect (optional safety)
    if (!this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden");
    }
  }

  toggle() {
    const menu = this.menuTarget;
    const toggle = this.toggleTarget;

    const isHidden = menu.classList.contains("hidden");

    if (isHidden) {
      menu.classList.remove("hidden");
      toggle.classList.add("text-orange-300");
    } else {
      menu.classList.add("hidden");
      toggle.classList.remove("text-orange-300");
    }
  }
}
