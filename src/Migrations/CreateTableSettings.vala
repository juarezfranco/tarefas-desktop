
public class App.Migrations.CreateTableSettings : GLib.Object, App.Interfaces.Migration {

    public void up (Sqlite.Database db) {

        var sql  =
            "CREATE TABLE IF NOT EXISTS settings (
                id INTEGER PRIMARY KEY NOT NULL,
                key TEXT NOT NULL,
                value TEXT
            );";

        if (db.exec(sql, null, null) == Sqlite.OK) {
            stdout.printf ("Migration CreateTableSettings completed.\n");
        } else {
            stderr.printf ("Migration CreateTableSettings fail.\n");
        }
    }
}
