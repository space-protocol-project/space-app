// Модуль загружается только в стенд GTK. Управляет видимым штатным диалогом.
#include <gtk/gtk.h>

static gboolean choose_folder(gpointer unused) {
  const gchar *folder = g_getenv("SPACE_CATALOG_CI_DIRECTORY");
  GList *windows = gtk_window_list_toplevels();
  static gboolean requested = FALSE;
  gboolean clicked = FALSE;
  for (GList *item = windows; item && !clicked; item = item->next) {
    GtkWidget *window = GTK_WIDGET(item->data);
    if (!GTK_IS_FILE_CHOOSER_DIALOG(window) || !gtk_widget_get_visible(window)) continue;
    if (g_strcmp0(gtk_window_get_title(GTK_WINDOW(window)), "Choose Directory")) continue;
    GtkFileChooser *chooser = GTK_FILE_CHOOSER(window);
    if (gtk_file_chooser_get_action(chooser) != GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER) continue;
    if (!requested) {
      requested = gtk_file_chooser_set_filename(chooser, folder);
      g_printerr("catalog-ci: requested folder selection (%d)\n", requested);
      continue;
    }
    gchar *selected = gtk_file_chooser_get_filename(chooser);
    gboolean matches = g_strcmp0(selected, folder) == 0;
    g_free(selected);
    if (!matches) continue;
    GtkWidget *button = gtk_dialog_get_widget_for_response(GTK_DIALOG(window), GTK_RESPONSE_ACCEPT);
    if (!GTK_IS_BUTTON(button) || !gtk_widget_is_sensitive(button)) continue;
    g_printerr("catalog-ci: activating Open in GTK\n");
    gtk_button_clicked(GTK_BUTTON(button));
    clicked = g_file_set_contents(g_getenv("SPACE_CATALOG_CI_MARKER"), "selected", -1, NULL);
  }
  g_list_free(windows);
  return clicked ? G_SOURCE_REMOVE : G_SOURCE_CONTINUE;
}

G_MODULE_EXPORT void gtk_module_init(gint *argc, gchar ***argv) {
  if (g_strcmp0(g_getenv("GITHUB_ACTIONS"), "true") || !g_getenv("SPACE_CATALOG_CI_DIRECTORY")) return;
  g_printerr("catalog-ci: GTK module loaded\n");
  g_timeout_add(150, choose_folder, NULL);
}
