// from https://www.youtube.com/watch?v=-ssp88Q9Pmk
import { Controller } from "@hotwired/stimulus";

// The HTML code for the spinner
const spinner = `
  <div id="spinner" style=" height: 80px; padding: 20px; text-align: center; color: white;">
    Loading...
  </div>
`;

export default class extends Controller {
    fetching = false; // debounce

    static values = {
        url: String,
        page: {type: Number, default: 1},
    };

    static targets = ["posts", "noRecords", "registers"];

    initialize(){
        this.scroll = this.scroll.bind(this);
    }

    connect() {
        console.log("🔥 PAGINATION CONECTADO");
        document.addEventListener("scroll", this.scroll)
    }

    scroll() {
        if (this.#pageEnd && !this.fetching && !this.hasNoRecordsTarget) {
            //Add the spinner at the end of the page.
            this.registersTarget.insertAdjacentHTML("beforeend", spinner)
            this.#loadRecords();
        }
    }

    // Send a turbo-stream request to the controller
    async #loadRecords() {
        const url = new URL(this.urlValue, window.location.origin);
        url.searchParams.set("page", this.pageValue);

        this.fetching = true;

        const response = await fetch(url.toString(), {
            headers: {
            Accept: "text/vnd.turbo-stream.html"
            }
        });

        const html = await response.text();

        Turbo.renderStreamMessage(html);

        this.fetching = false;
        this.pageValue += 1;
    }

    // Detect if were at the bottom of the page
    get #pageEnd() {
        const {scrollHeight, scrollTop, clientHeight} = document.documentElement;
        return scrollHeight - scrollTop - clientHeight < 40;
    }
}
