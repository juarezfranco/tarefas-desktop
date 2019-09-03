
public class App.Migrations.CreateTableTasks : GLib.Object, App.Interfaces.Migration {

    public void up (Sqlite.Database db) {

        var sql  =
            "CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY NOT NULL,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
                finished INT2 NOT NULL DEFAULT 0,
                finished_at TIMESTAMP,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                deleted_at TIMESTAMP
            );";

        if (db.exec(sql, null, null) == Sqlite.OK) {
            stdout.printf ("Migration CreateTableTasks completed.\n");
        } else {
            stderr.printf ("Migration CreateTableTasks fail.\n");
        }
    }
}
