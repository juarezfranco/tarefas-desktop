
using Gee;
using App.Controllers;
using App.Resources;

public class App.Views.TasksList : Gtk.ListBox {

    private int limit = 20;
    private Gtk.Button more_button;

    private TasksController tasks_controller;

    public signal void on_task_selected (App.Models.Task task);

    public TasksList () {
        create_widgets ();
        listen_widgets ();

        tasks_controller = new TasksController ();
        insert_more_tasks ();

        tasks_controller.on_added_task.connect ((ctrl, task) => {
            insert (new TaskItemList (task), 0);
            show_all ();
        });
    }

    private void insert_more_tasks () {
        int skip = -1; // subtract more_button
        @foreach (() => {
            skip++;
        });

        var tasks = tasks_controller.get_tasks (limit, skip);

        if (tasks == null || tasks.size == 0) {
            more_button.destroy ();
            return;
        }

        foreach (var task in tasks) {
            insert (new TaskItemList (task), skip++);
        }
        show_all ();
    }

    private void listen_widgets () {
        row_activated.connect (() => {
            var task = get_task_selected ();
            if (task != null) {
                on_task_selected (task);
            }
        });

        more_button.clicked.connect (() => {
            insert_more_tasks ();
        });
    }

    public App.Models.Task? get_task_selected () {
        var task_item_list = get_selected_row () as TaskItemList;
        return task_item_list != null ? task_item_list.task : null;
    }

    private void create_widgets () {
        get_style_context().add_class("bg-sidebar");
        vexpand = false;

        more_button = new Gtk.Button ();
        more_button.label = Strings.get("MORE");
        more_button.margin = 25;
        add (more_button);

    }
}
