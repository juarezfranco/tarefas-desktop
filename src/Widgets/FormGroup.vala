
public class App.Widgets.FormGroup : Gtk.Box {

    public Granite.HeaderLabel label { get; }
    public Gtk.Entry entry { get; }
    public App.Widgets.TextArea textarea { get; }

    public FormGroup.with_entry (string label_string) {
        _label = new Granite.HeaderLabel (label_string);
        label.xalign = 0;

        _entry = new Gtk.Entry ();
        orientation = Gtk.Orientation.VERTICAL;

        add (label);
        add (entry);
    }

    public FormGroup.with_textarea (string label_string) {
        _label = new Granite.HeaderLabel (label_string);
        label.xalign = 0;

        _textarea = new App.Widgets.TextArea ();
        orientation = Gtk.Orientation.VERTICAL;

        add (label);
        add (textarea);
    }

    public string get_text () {
        if (entry != null) {
            return entry.get_text ();
        }

        if (textarea != null) {
            return textarea.get_text ();
        }

        return "";
    }

    public void set_text (string text) {
        if (entry != null) {
            entry.set_text (text);
        }

        if (textarea != null) {
            textarea.set_text (text);
        }
    }

    public void reset () {
        if (entry != null) {
            entry.set_text ("");
        }

        if (textarea != null) {
            textarea.set_text ("");
        }
    }
}
