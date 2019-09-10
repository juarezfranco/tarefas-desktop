
using App.Resources;

public class App.Views.TaskShow : Gtk.Box {

    private App.Models.Task task;
    private Granite.HeaderLabel header_label;
    private Gtk.Label description_label;
    private Gtk.Button edit_button;
    private Gtk.Button remove_button;
    private Gtk.Button ready_button;

    public signal void on_edit_clicked (App.Models.Task task);

    public TaskShow (App.Models.Task task) {
        create_widgets ();

        this.task = task;
        task.on_changed.connect (update_task);
        task.on_deleted.connect (remove_task);
        update_task (task);

        listen_widgets ();
    }

    private void update_task (App.Models.Task task) {
        header_label.label = task.title;
        description_label.label = task.description;
        ready_button.sensitive = !task.finished;
    }

    private void remove_task (App.Models.Task task) {
        destroy ();
    }

    private void listen_widgets () {

        // Edit pressed
        edit_button.clicked.connect (() => on_edit_clicked (task));

        ready_button.clicked.connect (() => {
            task.ready ();
            ready_button.sensitive = false;
        });

        remove_button.clicked.connect (() => {
            task.delete();
        });
    }

    private void create_widgets () {
        orientation = Gtk.Orientation.VERTICAL;
        margin_top = 20;
        margin_start = 25;
        margin_end = 15;
        margin_bottom = 15;

        // start: header
        var header = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
        var image = new Gtk.Image.from_icon_name ("tag", Gtk.IconSize.DND);
        image.vexpand = false;
        header_label = new Granite.HeaderLabel ("");
        header_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        header_label.set_line_wrap (true);
        header.add (image);
        header.add (header_label);
        // end: header

        // start: actions
        var actions_button = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        actions_button.set_spacing (5);
        actions_button.set_layout (Gtk.ButtonBoxStyle.CENTER);
        actions_button.margin_top = 15;
        actions_button.margin_bottom = 15;
        ready_button = new Gtk.Button.with_label (Strings.get("READY"));
        edit_button = new Gtk.Button.with_label (Strings.get("EDIT"));
        remove_button = new Gtk.Button.with_label (Strings.get("REMOVE"));
        actions_button.add (ready_button);
        actions_button.set_child_non_homogeneous (ready_button, true);
        actions_button.add (edit_button);
        actions_button.set_child_non_homogeneous (edit_button, true);
        actions_button.add (remove_button);
        actions_button.set_child_non_homogeneous (remove_button, true);
        // end: actions

        // Start: description of task
        description_label = new Gtk.Label (null);
        description_label.xalign = 0;
        description_label.yalign = 0;
        description_label.margin_top = 25;
        description_label.set_line_wrap (true);

        var description_box = new Gtk.ScrolledWindow (null, null);
        description_box.vexpand = true;
        description_box.add (description_label);

        add (header);
        add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        add (actions_button);
        add (description_box);
    }
}
