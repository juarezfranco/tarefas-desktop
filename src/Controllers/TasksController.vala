
using Gee;
using App.Dao;

public class App.Controllers.TasksController {

    public signal void on_added_task (App.Models.Task task);

    public signal void on_deleted_task (App.Models.Task task);

    public TasksController () {
        var dbm = DatabaseManager.get_instance ();
        TaskDao task_dao = dbm.get_task_dao ();

        task_dao.on_added.connect ((dao, task) => on_added_task (task));
        task_dao.on_deleted.connect ((dao, task) => on_deleted_task (task));
    }

    public ArrayList<App.Models.Task> get_tasks (int limit, int skip) {
        return App.Models.Task.get (limit, skip);
    }

    public ArrayList get_finished_tasks (int limit, int skip) {
        return App.Models.Task.get_finished_tasks (limit, skip);
    }

    public bool store_task (string title, string description) {
        var task = new App.Models.Task ();
        task.title = title;
        task.description = description;

        return task.save ();
    }

    public App.Models.Task find_task (int id) {
        return App.Models.Task.find (id);
    }

    public bool update_task (App.Models.Task task) {
        return task.save ();
    }

    public void delete_task (App.Models.Task task) {
        task.delete ();
    }
}
