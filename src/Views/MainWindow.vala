
using Gee;
using App.Controllers;
using App.Resources;

public class App.Views.MainWindow : Gtk.ApplicationWindow {

    private const int DEFAULT_WIDTH = 860;
    private const int DEFAULT_HEIGHT = 480;
    private const int SIDEBAR_WIDTH = 250;

    // Widgets
    private Gtk.MenuButton home_button;
    private Gtk.MenuButton add_task_button;
    private Gtk.Paned main_container;
    private App.Views.TaskForm task_form;
    private App.Views.TaskView task_view;
    private Gtk.Box content;
    private App.Views.TasksList tasks_list;

    // Widgets Body
    private Gtk.Stack stack;

    public MainWindow (Gtk.Application app) {
        application = app;
        default_width = DEFAULT_WIDTH;
        default_height = DEFAULT_HEIGHT;

        create_widgets ();
        listen_widgets ();
    }

    public override void  show_all () {
        base.show_all ();
        home_button.visible = false;

        var task = tasks_list.get_task_selected ();
        if (task != null) {
            show_task (task);
        }
    }

    // Move stack to home
    private void go_to_home () {
        add_task_button.visible = true;
        home_button.visible = false;
        home_button.active = false;
        stack.set_transition_type (Gtk.StackTransitionType.SLIDE_RIGHT);
        stack.set_visible_child(main_container);
    }

    private void show_task (App.Models.Task task) {
        if (task_view != null) {
            task_view.destroy ();
        }
        task_view = new App.Views.TaskView (task);

        // Listen action edit task
        task_view.on_edit_clicked.connect ((view, task) => {
            add_task_button.visible = false;
            home_button.visible = true;
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT);

            task_form.prepare_to_edit (task);
            stack.set_visible_child (task_form);
        });

        content.add (task_view);
        content.show_all ();
    }

    private void listen_widgets () {
        // Listen action show form to add task
        add_task_button.clicked.connect (() => {
            add_task_button.visible = false;
            add_task_button.active = false;
            home_button.visible = true;
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT);

            task_form.prepare_to_add ();
            stack.set_visible_child (task_form);
        });

        // Listen canceled/completed form
        home_button.clicked.connect (go_to_home);
        task_form.canceled_action.connect (go_to_home);
        task_form.completed_action.connect (go_to_home);

        // Listen selected task in list of tasks
        tasks_list.on_task_selected.connect ((list, task) => {
            show_task (task);
        });
    }

    private void create_widgets () {
        // start: headerbar
        home_button = new Gtk.MenuButton ();
        home_button.set_can_focus (false);
        home_button.label = Strings.get("GO_TO_HOME");
        home_button.valign = Gtk.Align.CENTER;
        home_button.sensitive = true;
        home_button.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);

        add_task_button = new Gtk.MenuButton ();
        add_task_button.set_can_focus (false);
        add_task_button.label = Strings.get("ADD_TASK");
        add_task_button.image = new Gtk.Image.from_icon_name ("tag-new", Gtk.IconSize.SMALL_TOOLBAR);
        add_task_button.image_position = Gtk.PositionType.LEFT;
        add_task_button.always_show_image  = true;
        add_task_button.valign = Gtk.Align.CENTER;
        add_task_button.sensitive = true;

        var mode_switch = new Granite.ModeSwitch.from_icon_name (
            "display-brightness-symbolic",
            "weather-clear-night-symbolic"
        );
        mode_switch.primary_icon_tooltip_text = ("Light background");
        mode_switch.secondary_icon_tooltip_text = ("Dark background");
        mode_switch.valign = Gtk.Align.CENTER;
        mode_switch.bind_property ("active", Gtk.Settings.get_default (), "gtk_application_prefer_dark_theme");

        var headerbar = new Gtk.HeaderBar ();
        headerbar.get_style_context ().add_class ("default-decoration");
        headerbar.show_close_button = true;
        headerbar.has_subtitle = false;
        headerbar.pack_start (home_button);
        headerbar.pack_end (mode_switch);
        headerbar.pack_end (add_task_button);
        headerbar.title = Strings.get("TASKS");
        set_titlebar (headerbar);
        // end: headerbar

        // start: content main
        tasks_list = new App.Views.TasksList ();

        var scroll_list = new Gtk.ScrolledWindow (null, null);
        scroll_list.add (tasks_list);
        scroll_list.vexpand = true;
        var sidebar = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        sidebar.get_style_context().add_class("bg-sidebar");
        sidebar.add (scroll_list);

        content = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        content.get_style_context().add_class("bg-white");
        content.expand = true;

        main_container = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        main_container.position = SIDEBAR_WIDTH;
        main_container.pack1 (sidebar, true, true);
        main_container.pack2 (content, true, true);
        // end: content main

        // start: form task
        task_form = new App.Views.TaskForm ();
        // end: form task

        // start - stack with content main and form task
        stack = new Gtk.Stack ();
        stack.set_transition_duration (600);
        stack.add_named (main_container, "home");
        stack.add_named (task_form, "form_task");
        add(stack);
    }
}
