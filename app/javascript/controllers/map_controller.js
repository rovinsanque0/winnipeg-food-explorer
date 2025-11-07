import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { lat: Number, lng: Number }

  connect() {
    if (!window.google) {
      console.error("Google Maps failed to load")
      return
    }

    const position = { lat: this.latValue, lng: this.lngValue }

    this.map = new google.maps.Map(this.element, {
      zoom: 14,
      center: position
    })

    new google.maps.Marker({
      position: position,
      map: this.map
    })
  }
}
