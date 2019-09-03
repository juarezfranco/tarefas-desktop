
using App.Views;
using App.Resources;

public class Application : Gtk.Application {

    public Application () {
        Object (
            application_id: "com.github.juarezfranco.tarefas-desktop",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        // Set styles
        var provider = new Gtk.CssProvider ();
        provider.load_from_data (Styles.default ());
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        // show window
        var main_window = new MainWindow (this);
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Application ();
        return app.run (args);
    }
}
