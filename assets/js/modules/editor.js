import { Editor, generateHTML } from '@tiptap/core';
import StarterKit from '@tiptap/starter-kit';
import Highlight from '@tiptap/extension-highlight';
import Underline from '@tiptap/extension-underline';
import Link from '@tiptap/extension-link';

export function editor(content) {
  let instance;
  return {
    isActive(type, opts = {}, updatedAt) {
      return instance.isActive(type, opts);
    },
    toggleBold() {
      console.log('bold');
      instance.chain().toggleBold().focus().run();
    },
    toggleItalic() {
      instance.chain().toggleItalic().focus().run();
    },
    toggleHeading(opts = { level: 1 }) {
      instance.chain().toggleHeading(opts).focus().run();
    },
    setParagraph() {
      instance.chain().setParagraph().focus().run();
    },
    toggleBulletList() {
      instance.chain().toggleBulletList().focus().run();
    },
    toggleOrderedList() {
      instance.chain().toggleOrderedList().focus().run();
    },
    toggleBlockquote() {
      instance.chain().toggleBlockquote().focus().run();
    },
    toggleHighlight() {
      instance.chain().toggleHighlight().focus().run();
    },
    toggleUnderline() {
      instance.chain().toggleUnderline().focus().run();
    },
    toggleStrike() {
      instance.chain().toggleStrike().focus().run();
    },
    toggleStrike() {
      instance.chain().setHorizontalRule().focus().run();
    },
    content,
    updatedAt: Date.now(), // force Alpine to rerender on selection change
    init() {
      const _this = this;
      this.$refs.element.innerHTML = '';
      instance = new Editor({
        editorProps: {
          attributes: {
            class: 'prose',
          },
        },
        element: this.$refs.element,
        extensions: [ StarterKit, Highlight, Underline ],
        content,
        onCreate({ editor }) {
          _this.updatedAt = Date.now();
        },
        onUpdate({ editor }) {
          if (_this.$refs.content) _this.$refs.content.value = JSON.stringify(editor.getJSON());

          _this.updatedAt = Date.now();
        },
        onSelectionUpdate({ editor }) {
          _this.updatedAt = Date.now();
        },
      });
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
