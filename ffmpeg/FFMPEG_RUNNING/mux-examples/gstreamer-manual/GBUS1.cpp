// compiling with:  gcc test.c `pkg-config --cflags gtk+-3.0` `pkg-config --libs gtk+-3.0` -o test
#include <stdio.h>
#include <gtk/gtk.h>
#include <glib/gi18n.h>

guint threadID = 0;
guint serial_counter = 0;

static gboolean
serial_data (gpointer user_data)
{
    // do something
    printf("counter: %d\n", serial_counter);
    serial_counter++;
    return user_data;
}

static void
on_update_button_clicked (GtkButton* button, gpointer user_data)
{
    if (user_data == 1)
    {
        threadID = g_timeout_add(250, serial_data, user_data);
    }
    else if (user_data == 0)
    {
        g_source_remove(threadID);
        threadID = 0;   
    }
}

int
main (int argc, char *argv[])
{
    GtkWidget *window;
    gtk_init (&argc, &argv);
    GtkWidget *update_button;
    GtkWidget *stop_button;
    GtkWidget *box;

    window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title (GTK_WINDOW (window), "test.c");

    box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);

    update_button = gtk_button_new_with_label (_("Update"));
    stop_button = gtk_button_new_with_label (_("Stop"));

    gtk_box_pack_start (GTK_BOX (box), update_button, FALSE, FALSE, 0);
    gtk_box_pack_start (GTK_BOX (box), stop_button, FALSE, FALSE, 0);

    gtk_container_add (GTK_CONTAINER (window), box);

    g_signal_connect (update_button, "clicked", G_CALLBACK (on_update_button_clicked), 1);
    g_signal_connect (stop_button, "clicked", G_CALLBACK (on_update_button_clicked), 0);
    g_signal_connect (window, "destroy", G_CALLBACK (gtk_main_quit), NULL);
    gtk_widget_show_all (window);

    gtk_main ();
    return 0;
}