import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    fetching = false;

    static values = {
        url: String,
        page: { type: Number, default: 1 }
    };

    static targets = ["noRecords", "chat_entries"];

    initialize(){
        this.scroll = this.scroll.bind(this);
    }

    connect() {
        this.element.addEventListener("scroll", this.scroll);
    }

    disconnect() {
        this.element.removeEventListener("scroll", this.scroll);
    }

    scroll() {
        if (this.element.scrollTop <= 40 && !this.fetching && !this.hasNoRecordsTarget) {
            this.loadRecords();
        }
    }
    async loadRecords() {
        this.fetching = true;

        const oldHeight = this.element.scrollHeight;
        const oldTop = this.element.scrollTop;

        const url = new URL(this.urlValue, window.location.origin);
        url.searchParams.set("page", this.pageValue);

        const response = await fetch(url.toString(), {
            headers: { Accept: "text/vnd.turbo-stream.html" }
        });

        const html = await response.text();

        Turbo.renderStreamMessage(html);

        requestAnimationFrame(() => {
            const newHeight = this.element.scrollHeight;
            this.element.scrollTop = oldTop + (newHeight - oldHeight);

            this.fetching = false;
            this.pageValue += 1;
        });
    }
}