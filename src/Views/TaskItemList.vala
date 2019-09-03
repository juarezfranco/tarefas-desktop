
using App.Resources;

public class App.Views.TaskItemList : Gtk.ListBoxRow {


    private Granite.HeaderLabel title_label;
    private Gtk.Label created_at_label;

    public App.Models.Task task { get; set; }

    public TaskItemList (App.Models.Task task) {
        this.task = task;
        create_widgets ();
        listen_widgets ();

        task.on_changed.connect (update_task);
        task.on_deleted.connect (remove_task);
        update_task (task);
    }

    private void update_task (App.Models.Task task) {
        var label = "";

        if (task.finished) {
            label += Strings.get("[COMPLETED]") + " ";
            title_label.get_style_context().add_class("label-task-completed");
        }

        label += task.title;

        title_label.label = label;
        created_at_label.label = Strings.get("CREATED_AT") + " " + task.created_at.format("%x %H:%M");
    }

    private void remove_task (App.Models.Task task) {
        destroy ();
    }

    private void listen_widgets () {

    }

    private void create_widgets () {
        var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        content.margin = 10;

        title_label = new Granite.HeaderLabel ("");
        title_label.set_line_wrap (true);
        content.pack_start (title_label);

        created_at_label = new Gtk.Label ("");
        created_at_label.xalign = 1;
        created_at_label.get_style_context().add_class("label-datetime");
        content.pack_start (created_at_label);

        add(content);
    }
}
