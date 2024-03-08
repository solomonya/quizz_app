// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const cloneAlpineJSData = (from, to) => {
  if (!window.Alpine || !from || !to) return

  for (let index = 0; index < to.children.length; index++) {
    const from2 = from.children[index]
    const to2 = to.children[index]

    if (from2 instanceof HTMLElement && to2 instanceof HTMLElement) {
      cloneAlpineJSData(from2, to2)
    }
  }

  if (from._x_dataStack) window.Alpine.clone(from, to)

}

let Hooks = {};
Hooks.PageLeaving = {
  mounted() {
    window.addEventListener("beforeunload", (e) => {
    e.preventDefault();
    this.pushEvent("page-disconnected");
  });
  },
  /*destroyed() {
    window.removeEventListener("beforeunload", this.handle);
  }*/
}

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken }, 
  dom: {
    onBeforeElUpdated(from, to) {
      cloneAlpineJSData(from, to)

      return true
    }
  },
  hooks: Hooks,
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())
window.addEventListener("quiz_app:scroll_to", (event) => {
  console.log(event)
  event.target.scrollIntoView()
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

