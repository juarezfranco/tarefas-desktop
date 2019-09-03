
using Gee;

public class App.Dao.TaskDao {

    private string select_columns_default = "id, title, description, finished, STRFTIME('%s', finished_at), STRFTIME('%s', created_at), STRFTIME('%s', updated_at)";

    private unowned Sqlite.Database database;

    public signal void on_added (App.Models.Task task);

    public signal void on_deleted (App.Models.Task task);

    public TaskDao (Sqlite.Database db) {
        database = db;
    }

    private App.Models.Task fill_select_columns_default (Sqlite.Statement stmt) {

        var task            = new App.Models.Task ();
        task.id             = stmt.column_int (0);
        task.title          = stmt.column_text (1);
        task.description    = stmt.column_text (2);
        task.finished       = stmt.column_int (3) == 1;
        var finished_at     = stmt.column_text (4);
        var created_at      = stmt.column_text (5);
        var updated_at      = stmt.column_text (6);

        if (finished_at != null) {
            task.set_finished_at_from_int64 (int64.parse(finished_at));
        }

        if (created_at != null) {
            task.set_created_at_from_int64 (int64.parse(created_at));
        }

        if (updated_at != null) {
            task.set_updated_at_from_int64 (int64.parse(updated_at));
        }

        return task;
    }

    public ArrayList get (int limit, int skip) {
        var sql =
            "SELECT "+select_columns_default+" FROM tasks
            WHERE deleted_at is null
            ORDER BY id DESC, created_at DESC
            LIMIT $limit OFFSET $skip";

        Sqlite.Statement stmt;
        int res = database.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (stmt.bind_parameter_index ("$limit"), limit);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (stmt.bind_parameter_index ("$skip"), skip);
        assert (res == Sqlite.OK);

        var tasks = new ArrayList<App.Models.Task> ();

        while (stmt.step () == Sqlite.ROW) {
            var task = fill_select_columns_default (stmt);
            tasks.add (task);
        }

        return tasks;
    }

    public ArrayList get_finished (int limit, int skip) {
        stdout.printf ("TaskDao.get_all_finished\n");
        return new ArrayList<App.Models.Task> ();
    }

    public bool store (App.Models.Task task) {
        const string sql = "INSERT INTO tasks (title, description) VALUES ($title, $description);";

        Sqlite.Statement stmt;
        int res = database.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (stmt.bind_parameter_index ("$title"), task.title);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (stmt.bind_parameter_index ("$description"), task.description);
        assert (res == Sqlite.OK);

        res = stmt.step () ;
        assert (res == Sqlite.DONE);

        int last_id = int.parse(database.last_insert_rowid ().to_string ());

        on_added (find (last_id));
        return true;
    }

    public App.Models.Task find (int id) {
        var sql = "SELECT " + select_columns_default + " FROM tasks WHERE id = $ID;";

        Sqlite.Statement stmt;
        int res = database.prepare_v2 (sql, sql.length, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (stmt.bind_parameter_index ("$ID"), id);
        assert (res == Sqlite.OK);

        assert (stmt.step () == Sqlite.ROW);

        var task = fill_select_columns_default (stmt);
        return task;
    }

    public bool update (App.Models.Task task) {
        const string sql = "UPDATE tasks set title = $title, description = $description where id = $id";

        Sqlite.Statement stmt;
        int res = database.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (stmt.bind_parameter_index ("$id"), task.id);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (stmt.bind_parameter_index ("$title"), task.title);
        assert (res == Sqlite.OK);

        res = stmt.bind_text (stmt.bind_parameter_index ("$description"), task.description);
        assert (res == Sqlite.OK);

        res = stmt.step () ;
        assert (res == Sqlite.DONE);

        task.on_changed ();
        return true;
    }

    public bool update_finished (App.Models.Task task) {
        const string sql = "UPDATE tasks set finished = 1, finished_at = CURRENT_TIMESTAMP where id = $id and finished != 1";

        Sqlite.Statement stmt;
        int res = database.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (stmt.bind_parameter_index ("$id"), task.id);
        assert (res == Sqlite.OK);

        res = stmt.step () ;
        assert (res == Sqlite.DONE);

        task.on_changed ();
        return true;
    }

    public bool delete (App.Models.Task task) {
        const string sql = "UPDATE tasks set deleted_at = CURRENT_TIMESTAMP where id = $id";

        Sqlite.Statement stmt;
        int res = database.prepare_v2 (sql, -1, out stmt);
        assert (res == Sqlite.OK);

        res = stmt.bind_int (stmt.bind_parameter_index ("$id"), task.id);
        assert (res == Sqlite.OK);

        res = stmt.step () ;
        assert (res == Sqlite.DONE);

        task.on_deleted ();
        return true;
    }

    public void delete_all () {
        stdout.printf ("TaskDao.delete_all\n");
    }
}
