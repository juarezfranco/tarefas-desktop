
using Sqlite;
using Gee;
using App.Migrations;

public class App.Dao.DatabaseManager {

    private static DatabaseManager instance;

    private static TaskDao instance_task_dao;

    public static DatabaseManager get_instance () {
        if (instance == null) {
            instance = new DatabaseManager ();
        }
        return instance;
    }

    private Database database;

    private DatabaseManager () {

        // Create if not exists dir for app
        string path = Environment.get_home_dir () + "/.cache/com.github.juarezfranco.tarefas-desktop/";
        File tmp = File.new_for_path (path);
        if (tmp.query_file_type (0) != FileType.DIRECTORY) {
            GLib.DirUtils.create_with_parents (path, 0775);
        }

        var rc = Database.open (path + "database.db", out database);

        if (rc != Sqlite.OK) {
            stderr.printf ("Can't open database: %d, %s\n", rc, database.errmsg ());
            Process.exit (-1);
        }
        exec_migrations ();
    }

    public TaskDao get_task_dao () {
        if (instance_task_dao == null) {
            instance_task_dao =  new  App.Dao.TaskDao (database);
        }
        return instance_task_dao;
    }

    private void exec_migrations () {

        (new CreateTableMigrations ()).up (database);

        // Add migrations here
        var migrations = new HashMap<string, App.Interfaces.Migration> ();
        migrations["create_table_settings"] = new CreateTableSettings ();
        migrations["create_table_task"] = new CreateTableTasks ();

        // List commited migrations
        var results = new ArrayList<string> ();
        database.exec("SELECT name FROM migrations", (n_columns, values, column_names) => {
            results.add (values[0]);
            return 0;
        }, null);

        // Run new migrations
        foreach (var entry in migrations.entries) {
            if (! (entry.key in results)) {
                var migration = entry.value;
                migration.up (database);

                database.exec(@"INSERT INTO migrations (name) VALUES ('$(entry.key)')", null, null);
            }
        }
    }
}
