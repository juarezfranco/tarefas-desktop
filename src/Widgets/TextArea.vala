
namespace App.Widgets {

    public class TextArea : Gtk.Frame {

        public Gtk.TextView text_view { get; }

        public TextArea () {
            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.border_width = 2;

            _text_view = new Gtk.TextView ();
            scrolled_window.add (text_view);
            add(scrolled_window);
        }

        public string get_text () {
            return text_view.buffer.text;
        }

        public void set_text (string text) {
            text_view.buffer.text = text;
        }

        public void set_expand (bool expand) {
            text_view.hexpand = expand;
            text_view.vexpand = expand;
            text_view.wrap_mode = Gtk.WrapMode.CHAR;
        }

    }
}
