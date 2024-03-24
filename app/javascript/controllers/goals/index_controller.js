import {Controller} from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"


export default class extends Controller {
    static values = {finishEndpoint: String}
    static targets = ["finishButton"]

    finishingMany() {
        const ids = this.checkboxTargets
            .filter(checkbox => checkbox.checked)
            .map(checkbox => checkbox.value);
        const finishEndpoint = this.finishEndpointValue;

        const data = {goal_ids: ids};
        const url = finishEndpoint + '.json';
        const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': token,
                'Accept': 'text/vnd.turbo-stream.html',
            },
            body: JSON.stringify(data),
        })
            .then(response => response.json())
            .then(data => {
                console.log('Success:', data);
            })
            .catch((error) => {
                console.error('Error:', error);
            });
    }
}
