// Either focus the next, previous, first, or last tab depending on key pressed
function switchTabOnArrowPress(tabEls, keys, event) {
  const pressed = event.keyCode;

  // Add or subtract depending on key pressed
  const direction = {
    37: -1,
    38: -1,
    39: 1,
    40: 1,
  };

  if (direction[pressed]) {
    const target = event.target;
    if (target.index !== undefined) {
      if (tabEls[target.index + direction[pressed]]) {
        tabEls[target.index + direction[pressed]].focus();
      } else if (pressed === keys.left) {
        focusLastTab(tabEls);
      } else if (pressed === keys.right) {
        focusFirstTab(tabEls);
      }
    }
  }
}

// Make a guess
function focusFirstTab(tabEls) {
  tabEls[0].focus();
}

// Make a guess
function focusLastTab(tabEls) {
  tabEls[tabEls.length - 1].focus();
}

export function setupTabs() {
  let listeners = [];

  const keys = {
    end: 35,
    home: 36,
    left: 37,
    right: 39,
    enter: 13,
    space: 32,
  };

  return {
    mounted() {
      const tabs = [ ...this.el.querySelectorAll('[role="tab"]') ].map((tab, i) => {
        tab.index = i;
        return tab;
      });

      tabs.forEach((tab) => {
        listeners.push([
          'tab:navigate',
          tab.addEventListener('tab:navigate', (event) => {
            console.log(event);
            const key = event.keyCode;

            switch (key) {
              case keys.left:
              case keys.right:
                event.preventDefault();
                switchTabOnArrowPress(tabs, keys, event);
                break;
              case keys.end:
                event.preventDefault();
                focusLastTab(tabs);
                break;
              case keys.home:
                event.preventDefault();
                focusFirstTab(tabs);
                break;
            }
          }),
        ]);
      });

      listeners.push([
        'tab:select',
        window.addEventListener('tab:select', (e) => {
          tabs.forEach((tab) => {
            const isSelected = tab.id === e.target.id;
            tab.setAttribute('aria-selected', isSelected);
            tab.setAttribute('tabindex', isSelected ? false : -1);
          });
        }),
      ]);
    },
    destroyed() {
      listeners.forEach(([ type, id ]) => window.removeEventListener(type, id));
    },
  };
}
