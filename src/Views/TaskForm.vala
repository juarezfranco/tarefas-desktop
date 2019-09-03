
using App.Controllers;
using App.Resources;

public class App.Views.TaskForm : Gtk.Box {

    // Properties
    private App.Models.Task task;
    private bool edit;
    private ulong handler_error_save_taks_id = 0;

    // Controllers
    private TasksController tasks_controller;

    // Widgets
    private App.Widgets.FormGroup title_formgroup;
    private App.Widgets.FormGroup description_formgroup;
    private Gtk.ButtonBox actions_button;
    private Gtk.Button save_button;
    private Gtk.Button cancel_button;

    // Signals
    public signal void canceled_action ();
    public signal void completed_action ();

    public TaskForm () {
        create_widgets ();
        listen_widgets ();

        tasks_controller = new TasksController ();
    }

    public void prepare_to_add () {
        edit = false;
        reset_form ();
    }

    public void prepare_to_edit (App.Models.Task task) {
        edit = true;
        reset_form ();
        this.task = task;
        title_formgroup.set_text (task.title);
        description_formgroup.set_text (task.description);
    }

    private void reset_form () {
        title_formgroup.entry.set_text ("");
        description_formgroup.textarea.set_text ("");
    }

    private void show_error_submit_form (TasksController ctrl, string message) {
        stdout.printf (@"$message\n");
    }

    private void listen_widgets () {
        // Cancel form
        cancel_button.clicked.connect (() => {
            title_formgroup.reset ();
            description_formgroup.reset ();
            canceled_action ();
        });

        // Submit form
        save_button.clicked.connect (() => {
            var title = title_formgroup.get_text ();
            var description = description_formgroup.get_text ();
            var ok = false;

            if (edit) {
                task.title = title;
                task.description = description;
                ok = tasks_controller.update_task (task);
            } else {
                ok = tasks_controller.store_task (title, description);
            }

            if (ok) {
                completed_action ();
            }
        });
    }

    private void create_widgets () {
        spacing = 25;
        orientation = Gtk.Orientation.VERTICAL;
        margin = 25;

        // Add input for title
        title_formgroup = new App.Widgets.FormGroup.with_entry (Strings.get("TITLE"));
        title_formgroup.entry.set_max_length (80);
        title_formgroup.entry.set_max_width_chars (80);

        // Add input for description
        description_formgroup = new App.Widgets.FormGroup.with_textarea (Strings.get("DESCRIPTION"));
        description_formgroup.textarea.set_expand (true);

        // Add inputs in form
        var form = new Gtk.Box (Gtk.Orientation.VERTICAL, 25);
        form.hexpand = true;
        form.vexpand = true;
        form.add (title_formgroup);
        form.add (description_formgroup);

        // Add action buttons
        save_button = new Gtk.Button ();
        save_button.label = Strings.get("SAVE_TASK");
        save_button.image = new Gtk.Image.from_icon_name ("media-floppy", Gtk.IconSize.BUTTON);
        save_button.image_position = Gtk.PositionType.LEFT;
        save_button.always_show_image  = true;

        cancel_button = new Gtk.Button ();
        cancel_button.label = Strings.get("CANCEL");
        cancel_button.image = new Gtk.Image.from_icon_name ("window-close", Gtk.IconSize.BUTTON);
        cancel_button.image_position = Gtk.PositionType.LEFT;
        cancel_button.always_show_image  = true;

        actions_button = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        actions_button.set_spacing (10);
        actions_button.set_layout (Gtk.ButtonBoxStyle.END);
        actions_button.add (cancel_button);
        actions_button.add (save_button);

        add(form);
        add(actions_button);
    }
}
