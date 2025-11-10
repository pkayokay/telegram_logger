import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.getElementById("this-element-does-not-exist").innerText = "This will cause a frontend error."
  }
}
