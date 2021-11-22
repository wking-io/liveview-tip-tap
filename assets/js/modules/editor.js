import { Editor, generateHTML } from '@tiptap/core';
import StarterKit from '@tiptap/starter-kit';
import Highlight from '@tiptap/extension-highlight';
import Underline from '@tiptap/extension-underline';

function updateButtonState(buttons, editor) {
  buttons.forEach((btn) => {
    if (btn.dataset.editorAction.includes('heading')) {
      const [ action, level ] = btn.dataset.editorAction.split('-');
      btn.classList.toggle('is-active', editor.isActive(action, { level: parseInt(level) }));
    } else {
      btn.classList.toggle('is-active', editor.isActive(btn.dataset.editorAction));
    }
  });
}

function updateContent(root, editor) {
  const input = root.querySelector('[phx-ref="content"]');
  if (input) input.value = JSON.stringify(editor.getJSON());
}

function onUpdate(root, actions, editor) {
  updateButtonState(actions, editor);
  updateContent(root, editor);
}

export function setupEditor() {
  let instance;
  let actionListener;

  return {
    mounted() {
      const _this = this;
      const element = this.el.querySelector('[phx-ref="element"]');
      const editorActions = this.el.querySelectorAll('[data-editor-action]');

      if (element) {
        instance = new Editor({
          editorProps: {
            attributes: {
              class: 'prose',
            },
          },
          element,
          extensions: [ StarterKit, Highlight, Underline ],
          content: JSON.parse(this.el.dataset.content),
          onUpdate({ editor }) {
            onUpdate(_this.el, editorActions, editor);
          },
          onSelectionUpdate({ editor }) {
            updateButtonState(editorActions, editor);
          },
        });

        actionListener = window.addEventListener('editor-button:action', (e) => {
          if (e.detail.action === 'toggleHeading') {
            instance.chain()[e.detail.action]({ level: e.detail.level }).focus().run();
          } else {
            instance.chain()[e.detail.action]().focus().run();
          }
        });
      }
    },
    updated() {
      updateContent(this.el, instance);
    },
    destroyed() {
      instance = null;
      window.removeEventListener('editor-button:action', actionListener);
    },
  };
}

export function render(json) {
  return {
    json,
    init() {
      this.$refs.content.innerHTML = generateHTML(json, [ StarterKit ]);
    },
  };
}
