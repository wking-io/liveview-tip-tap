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

// This is an AlpineJS reusable function for tabs we use on the BIT dashboard
export function tabs() {
  const tabEls = [ ...document.querySelectorAll('[role="tab"]') ].map((tab, i) => {
    tab.index = i;
    return tab;
  });

  // For easy reference
  var keys = {
    end: 35,
    home: 36,
    left: 37,
    right: 39,
    enter: 13,
    space: 32,
  };

  return {
    tab: 'entries',
    select(tab) {
      this.tab = tab;
      document.body.dataset.current_tab = tab;
    },
    setTabindex(tab) {
      return this.tab === tab ? 'false' : '-1';
    },
    isTab(tab) {
      return this.tab === tab;
    },
    navigate(event) {
      const key = event.keyCode;

      switch (key) {
        case keys.left:
        case keys.right:
          event.preventDefault();
          switchTabOnArrowPress(tabEls, keys, event);
          break;
        case keys.end:
          event.preventDefault();
          focusLastTab(tabEls);
          break;
        case keys.home:
          event.preventDefault();
          focusFirstTab(tabEls);
          break;
      }
    },
  };
}
