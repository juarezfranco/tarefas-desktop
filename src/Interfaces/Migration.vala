
using Sqlite;

public interface App.Interfaces.Migration : GLib.Object {

    public abstract void up (Database db);

}
