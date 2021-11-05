import { Editor, generateHTML } from '@tiptap/core';
import StarterKit from '@tiptap/starter-kit';
import Highlight from '@tiptap/extension-highlight';
import Underline from '@tiptap/extension-underline';
import Link from '@tiptap/extension-link';

export function setupEditor() {
  let instance;
  let actionListener;

  return {
    mounted() {
      const _this = this;
      const element = this.el.querySelector('[phx-ref="element"]');
      console.log(element);

      if (element) {
        instance = new Editor({
          editorProps: {
            attributes: {
              class: 'prose',
            },
          },
          element,
          extensions: [ StarterKit, Highlight, Underline ],
          content: this.el.dataset.content,
          onUpdate({ editor }) {
            const input = _this.el.querySelector('[phx-ref="content"]');
            if (input) input.value = JSON.stringify(editor.getJSON());
          },
          onSelectionUpdate({ editor }) {},
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
    destroyed() {
      instance = null;
      window.removeEventListener(actionListener);
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
