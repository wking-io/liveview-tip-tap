import { Editor, generateHTML } from '@tiptap/core';
import StarterKit from '@tiptap/starter-kit';

export function editor(content) {
  let instance;
  return {
    isActive(type, opts = {}, updatedAt) {
      return instance.isActive(type, opts);
    },
    toggleBold() {
      instance.chain().toggleBold().focus().run();
    },
    toggleItalic() {
      instance.chain().toggleItalic().focus().run();
    },
    toggleHeading(opts = { level: 1 }) {
      instance.chain().toggleHeading(opts).focus().run();
    },
    content,
    updatedAt: Date.now(), // force Alpine to rerender on selection change
    init() {
      const _this = this;
      instance = new Editor({
        element: this.$refs.element,
        extensions: [ StarterKit ],
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
