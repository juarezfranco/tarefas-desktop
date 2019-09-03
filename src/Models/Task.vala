
using Gee;
using App.Dao;

public class App.Models.Task : GLib.Object, App.Interfaces.Model {

    // Statics
    public static ArrayList get_finished_tasks (int limit, int skip) {
        return DatabaseManager.get_instance ()
            .get_task_dao ()
            .get_finished (limit, skip);
    }

    public static ArrayList get (int limit, int skip) {
        return DatabaseManager.get_instance ()
            .get_task_dao ()
            .get (limit, skip);
    }

    public static App.Models.Task find (int id) {
        return DatabaseManager.get_instance ()
            .get_task_dao ()
            .find (id);
    }

    // Signals
    public signal void on_changed ();

    public signal void on_deleted ();

    // Attributes
    public int id { get; set; default = -1; }
    public string title { get; set; }
    public string description { get; set; }
    public bool finished { get; set; default = false; }
    public DateTime finished_at { get; set; }
    public DateTime created_at { get; set; }
    public DateTime updated_at { get; set; }
    public DateTime deleted_at { get; set; }

    private App.Dao.TaskDao task_dao;

    public Task () {
        var dbm = DatabaseManager.get_instance ();
        task_dao = dbm.get_task_dao ();
    }

    public void set_finished_at_from_int64 (int64 num) {
        this.finished_at = new DateTime.from_unix_local (num);
    }

    public bool ready () {
        finished = true;
        return task_dao.update_finished(this);
    }

    public bool save () {
        var task = this;

        if (task.id > 0) {
            task.updated_at = new DateTime.now_local ();
            return task_dao.update(task);
        } else {
            return task_dao.store(task);
        }
    }

    public void delete () {
        task_dao.delete (this);
    }
}
