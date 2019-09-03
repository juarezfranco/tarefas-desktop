 # project name and programming language
project('com.github.juarezfranco.tarefas-desktop', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    meson.project_name(),
    'src/Application.vala',

    'src/Models/Task.vala',

    'src/Dao/DatabaseManager.vala',
    'src/Dao/TaskDao.vala',
    'src/Controllers/TasksController.vala',

    'src/Views/MainWindow.vala',
    'src/Views/TaskForm.vala',
    'src/Views/TaskView.vala',
    'src/Views/TaskItemList.vala',
    'src/Views/TasksList.vala',

    'src/Widgets/TextArea.vala',
    'src/Widgets/FormGroup.vala',

    'src/Interfaces/Model.vala',
    'src/Interfaces/Migration.vala',

    'src/Migrations/CreateTableTasks.vala',
    'src/Migrations/CreateTableMigrations.vala',
    'src/Migrations/CreateTableSettings.vala',

    'src/Resources/Styles.vala',
    'src/Resources/Strings.vala',
    dependencies: [
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('sqlite3')
    ],
    install: true
)

subdir('data')
subdir('po')
