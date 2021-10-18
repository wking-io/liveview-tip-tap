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

/*=================
Hermes Editor Setup
=================*/

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
      if (from.__x) {
        window.Alpine.clone(from.__x, to);
      }
    },
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' });
window.addEventListener('phx:page-loading-start', (info) => topbar.show());
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
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

const NONE = 'none';
const MENU = 'menu';
const DETAILS = 'details';

Alpine.store('panel', {
  state: MENU,
  init() {
    this.state = MENU;
  },
  toggle(panel) {
    this.state = this.state === panel ? NONE : panel;
  },
  open(panel) {
    this.state = panel;
  },
  close() {
    this.state = NONE;
  },
  getClasses(component) {
    switch (component) {
      case 'workspace':
        if (this.state === MENU) {
          return '!ml-56';
        } else if (this.state === DETAILS) {
          return '!ml-0 !mr-[500px]';
        } else {
          return '!mx-0';
        }
      case 'topnav':
        if (this.state === MENU) {
          return '';
        } else if (this.state === DETAILS) {
          return '!left-0 !right-[500px]';
        } else {
          return '!left-0';
        }
      default:
        return '';
    }
  },
});

Alpine.start();
