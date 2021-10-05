/* global jQuery */
import { pipe } from './utils';

const focusableElementsString =
  'a[href], area[href], input:not([disabled]):not([type="hidden"]), select:not([disabled]), textarea:not([disabled]), button:not([disabled]), iframe, object, embed, *[tabindex], *[contenteditable]';

const moveToEndOfBody = (main) => (popup) => main.parentNode.insertBefore(popup, main.nextSibling);

function addTabEvent(popup) {
  popup.addEventListener('keydown', trapTabKey(popup));
}

const trapTabKey = (popup) => (event) => {
  // if tab or shift-tab pressed
  if (event.which == 9) {
    const focusableItems = [ ...popup.querySelectorAll(focusableElementsString) ];
    console.log(focusableItems);
    // get currently focused item
    const focusedItem = document.activeElement;

    // get the index of the currently focused item
    const focusedItemIndex = focusableItems.findIndex((item) => item == focusedItem);

    if (event.shiftKey) {
      //back tab
      // if focused on first item and user preses back-tab, go to the last focusable item
      if (focusedItemIndex == 0) {
        focusableItems[focusableItems.length - 1].focus();
        event.preventDefault();
      }
    } else {
      //forward tab
      // if focused on the last item and user preses tab, go to the first focusable item
      if (focusedItemIndex == focusableItems.length - 1) {
        focusableItems[0].focus();
        event.preventDefault();
      }
    }
  }
};

function setFocusToFirstItemInModal(popup) {
  // get list of all children elements in given object
  const focusableElement = popup.querySelector(focusableElementsString);
  console.log(focusableElement);
  if (focusableElement) focusableElement.focus();
  return popup;
}

function makeMainInvisible(main) {
  return function(popup) {
    // Hide main content from screen readers
    main.setAttribute('aria-hidden', true);

    // attach a listener to redirect the tab to the modal window if the user somehow gets out of the modal window
    main.addEventListener('focusin', function(e) {
      e.preventDefault();
      setFocusToFirstItemInModal(popup);
    });

    return popup;
  };
}

export function setupPopup(el) {
  const main = document.getElementById('mythic-main');
  pipe(moveToEndOfBody(main), makeMainInvisible(main), setFocusToFirstItemInModal, addTabEvent)(el);
}
