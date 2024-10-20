#include <gtk/gtk.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

// ====================== Widget APIs ======================
/// valign: 0 for fill 1 for start, 2 for center, 3 for end
void sgtk_widget_set_valign(GtkWidget *widget, int32_t valign)
{
    switch (valign)
    {
    case 1:
        gtk_widget_set_valign(widget, GTK_ALIGN_START);
        break;
    case 2:
        gtk_widget_set_valign(widget, GTK_ALIGN_CENTER);
        break;
    case 3:
        gtk_widget_set_valign(widget, GTK_ALIGN_END);
        break;
    default:
        gtk_widget_set_valign(widget, GTK_ALIGN_FILL);
        break;
    }
}

// halign: 0 for fill 1 for start, 2 for center, 3 for end
void sgtk_widget_set_halign(GtkWidget *widget, int32_t halign)
{
    switch (halign)
    {
    case 1:
        gtk_widget_set_halign(widget, GTK_ALIGN_START);
        break;
    case 2:
        gtk_widget_set_halign(widget, GTK_ALIGN_CENTER);
        break;
    case 3:
        gtk_widget_set_halign(widget, GTK_ALIGN_END);
        break;
    }
}

void sgtk_widget_set_vexpand(GtkWidget *widget, int32_t vexpand)
{
    if (vexpand == 0)
    {
        gtk_widget_set_vexpand(widget, FALSE);
    }
    else
    {
        gtk_widget_set_vexpand(widget, TRUE);
    }
}

void sgtk_widget_set_margin_start(GtkWidget *widget, int32_t margin_start)
{
    gtk_widget_set_margin_start(widget, (int) margin_start);
}

void sgtk_widget_set_margin_end(GtkWidget *widget, int32_t margin_end)
{
    gtk_widget_set_margin_end(widget, (int) margin_end);
}


void sgtk_widget_set_size_request(GtkWidget *widget, int32_t width, int32_t height)
{
    gtk_widget_set_size_request(widget, (int) width, (int) height);
}

void sgtk_widget_get_size_request(GtkWidget *widget, int32_t *width, int32_t *height)
{
    gtk_widget_get_size_request(widget, (int*) width, (int*) height);
}

void sgtk_widget_set_sensitive(GtkWidget *widget, int32_t sensitive)
{
    if (sensitive == 0)
    {
        gtk_widget_set_sensitive(widget, FALSE);
    }
    else
    {
        gtk_widget_set_sensitive(widget, TRUE);
    }
}

// ====================== Window APIs ======================

GtkWidget* sgtk_window_new(GtkApplication* app)
{
    return gtk_application_window_new(app);
}

void sgtk_window_set_title(GtkWidget *window, const char *title)
{
    gtk_window_set_title(GTK_WINDOW(window), title);
}

void sgtk_window_set_default_size(GtkWidget *window, int32_t width, int32_t height)
{
    gtk_window_set_default_size(GTK_WINDOW(window), width, height);
}

void sgtk_window_set_child(GtkWidget *window, GtkWidget *child)
{
    gtk_window_set_child(window, child);
}

// ====================== Paned APIs ======================

/// orientation: 0 for horizontal, otherwise for vertical
GtkWidget* sgtk_paned_new(int32_t orientation)
{
    if (orientation == 0)
    {
        return gtk_paned_new(GTK_ORIENTATION_HORIZONTAL);
    }
    else
    {
        return gtk_paned_new(GTK_ORIENTATION_VERTICAL);
    }
}

void sgtk_paned_set_start_child(GtkWidget *paned, GtkWidget *child)
{
    gtk_paned_set_start_child(GTK_PANED(paned), child);
}

void sgtk_paned_set_end_child(GtkWidget *paned, GtkWidget *child)
{
    gtk_paned_set_end_child(GTK_PANED(paned), child);
}

void sgtk_paned_set_position(GtkWidget *paned, int32_t position)
{
    gtk_paned_set_position(GTK_PANED(paned), (int) position);
}

// ====================== Box APIs ======================

void sgtk_box_append(GtkWidget *box, GtkWidget *child)
{
    gtk_box_append(GTK_BOX(box), child);
}

// orientation: 0 for horizontal, otherwise for vertical
GtkWidget* sgtk_box_new(int32_t orientation, int32_t spacing)
{
    if (orientation == 0)
    {
        return gtk_box_new(GTK_ORIENTATION_HORIZONTAL, spacing);
    }
    else
    {
        return gtk_box_new(GTK_ORIENTATION_VERTICAL, spacing);
    }
}

// ====================== Label APIs ======================
GtkWidget* sgtk_label_new(const char *text)
{
    return gtk_label_new(text);
}

void sgtk_label_set_text(GtkWidget *label, const char *text)
{
    gtk_label_set_text(GTK_LABEL(label), text);
}

GtkWidget* sgtk_button_new_with_label(const char *text)
{
    return gtk_button_new_with_label(text);
}

// button set label
void sgtk_button_set_label(GtkWidget *button, const char *text)
{
    gtk_button_set_label(GTK_BUTTON(button), text);
}


// ================== Scrolled Window APIs ==================
GtkWidget* sgtk_scrolled_window_new()
{
    return gtk_scrolled_window_new();
}

void sgtk_scrolled_window_set_child(GtkWidget *scrolled, GtkWidget *child)
{
    gtk_scrolled_window_set_child(GTK_SCROLLED_WINDOW(scrolled), child);
}


// ====================== Notebook APIs ======================
GtkWidget* sgtk_notebook_new()
{
    return gtk_notebook_new();
}

void sgtk_notebook_append_page(GtkWidget *notebook, GtkWidget *child, GtkWidget *tab_label)
{
    gtk_notebook_append_page(GTK_NOTEBOOK(notebook), child, tab_label);
}

// ====================== Callback & Misc ======================
void sgtk_show(GtkWidget *window)
{
    gtk_widget_show(GTK_WIDGET(window));
}

void sgtk_timeout_add(int32_t interval, int (*callback)(void*), gpointer data)
{
    g_timeout_add(interval, callback, data);
}


void sgtk_signal_connect(GtkWidget *widget, const char *signal, void (*callback)(GtkWidget*, void*), gpointer data)
{
    g_signal_connect(widget, signal, G_CALLBACK(callback), data);
}


int32_t sgtk_main(
    const char* app_id,
    void (*main)(GtkApplication*, gpointer data),
    gpointer data
)
{
    int32_t status;
    GtkApplication* app;

    app = gtk_application_new("org.gtk.example", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(main), data);
    status = g_application_run(G_APPLICATION(app), 0, NULL);
    g_object_unref(app);

    return status;
}