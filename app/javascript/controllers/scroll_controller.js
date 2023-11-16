import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener('turbo:frame-render', (event) => {
      var hash = window.location.hash.substring(1);
      if (hash != '') {
        var element = document.querySelector(`#${hash}`);
        if (element != null) {
          element.scrollIntoView();
        }
      }
    })
  }
}