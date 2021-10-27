// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.css';

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import Alpine from 'alpinejs';
import 'phoenix_html';
import { Socket } from 'phoenix';
import topbar from 'topbar';
import { LiveSocket } from 'phoenix_live_view';
import { setupPopup } from './modules/popup';
import { tabs } from './modules/tabs';
import { editor, render } from './modules/editor';

window.Alpine = Alpine;

let Hooks = {};

Hooks.Modal = {
  mounted() {
    setupPopup(this.el);
  },
};

Hooks.EarlyAccessEvent = {
  mounted() {
    this.handleEvent('subscribed', ({ subscribed }) => {
      if (subscribed) {
        window.fathom.trackGoal('TLI5BDX5', 0);
      }
    });
  },
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
  metadata: {
    click: (e, el) => ({
      shiftKey: e.shiftKey,
    }),
  },
});

// Show progress bar on live navigation and form submits
topbar.config({
  barColors: { 0: '#FFBA8F', 0.33: '#FF8B42', 0.66: '#F2673D', 1: '#E53A33' },
  shadowColor: 'rgba(0, 0, 0, .3)',
});
window.addEventListener('phx:page-loading-start', (info) => topbar.show());
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000); // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

Alpine.data('menuButton', () => ({
  show: false,
  toggle() {
    this.show = !this.show;
  },
  isOpen() {
    return this.show === true;
  },
}));

Alpine.data('accordion', () => ({
  selected: null,
  select() {
    console.log(this.$el.id);
    this.selected = this.$el.id === this.selected ? null : this.$el.id;
  },
}));

Alpine.data('editor', editor);
Alpine.data('render', render);
Alpine.data('tabs', tabs);
Alpine.start();
