
public class App.Migrations.CreateTableMigrations : GLib.Object, App.Interfaces.Migration {

    public void up (Sqlite.Database db) {

        var sql  =
            "CREATE TABLE IF NOT EXISTS migrations (
                id INTEGER PRIMARY KEY NOT NULL,
                name TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );";

        if (db.exec(sql, null, null) != Sqlite.OK) {
            stderr.printf ("Migration CreateTableMigrations fail.\n");
        }
    }
}
