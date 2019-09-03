
using Gee;

public class App.Resources.Strings {


    public static string get(string key) {
        var strings = new HashMap<string, string> ();

        strings["GO_TO_HOME"]       = _("Go to home");
        strings["ADD_TASK"]         = _("Add task");
        strings["TASK"]             = _("Task");
        strings["TASKS"]            = _("Tasks");
        strings["TITLE"]            = _("Title:");
        strings["DESCRIPTION"]      = _("Description:");
        strings["SAVE_TASK"]        = _("Save task");
        strings["CANCEL"]           = _("Cancel");
        strings["[COMPLETED]"]      = _("[COMPLETED]");
        strings["CREATED_AT"]       = _("Created at");
        strings["MORE"]             = _("more");
        strings["READY"]            = _("Ready");
        strings["EDIT"]             = _("Edit");
        strings["REMOVE"]           = _("Remove");

        return strings[key];
    }
}
