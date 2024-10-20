using .SGtk_Lib
export GWidget, GtkAlign, GApp, GtkOrientation
export GtkWidget, GtkWindow, GtkPaned, GtkLabel, GtkScrolledWindow, GtkButton, GtkNotebook, GtkBox

abstract type GtkWidget end

struct GtkWindow <: GtkWidget
    _widget::GWidget
end

struct GtkBox <: GtkWidget
    _widget::GWidget
end

struct GtkLabel <: GtkWidget
    _widget::GWidget
end

struct GtkScrolledWindow <: GtkWidget
    _widget::GWidget
end

struct GtkButton <: GtkWidget
    _widget::GWidget
end

struct GtkPaned <: GtkWidget
    _widget::GWidget
end

struct GtkNotebook <: GtkWidget
    _widget::GWidget
end

@inline function widget_setproperty!(w::GtkWidget, name::Symbol, value)
    if name === :valign
        SGtk_Lib.sgtk_widget_set_valign(getfield(w, :_widget), convert(GtkAlign.T, value))
    elseif name === :halign
        SGtk_Lib.sgtk_widget_set_halign(getfield(w, :_widget), convert(GtkAlign.T, value))
    elseif name === :vexpand
        SGtk_Lib.sgtk_widget_set_vexpand(getfield(w, :_widget), convert(Bool, value))
    elseif name === :margin_start
        SGtk_Lib.sgtk_widget_set_margin_start(getfield(w, :_widget), convert(Int32, value))
    elseif name === :margin_end
        SGtk_Lib.sgtk_widget_set_margin_end(getfield(w, :_widget), convert(Int32, value))
    elseif name === :height_request
        width, height = SGtk_Lib.sgtk_widget_get_size_request(getfield(w, :_widget))
        SGtk_Lib.sgtk_widget_set_size_request(getfield(w, :_widget), width, convert(Int32, value))
    elseif name === :width_request
        width, height = SGtk_Lib.sgtk_widget_get_size_request(getfield(w, :_widget))
        SGtk_Lib.sgtk_widget_set_size_request(getfield(w, :_widget), convert(Int32, value), height)
    elseif name == :sensitive
        SGtk_Lib.sgtk_widget_set_sensitive(getfield(w, :_widget), convert(Bool, value))
    else
        error("Unsupported property: $name")
    end
end

@inline function Base.setproperty!(w::GtkPaned, name::Symbol, value)
    if name === :position
        SGtk_Lib.sgtk_paned_set_position(getfield(w, :_widget), convert(Int32, value))
    elseif name === :start_child
        value::GtkWidget
        SGtk_Lib.sgtk_paned_set_start_child(getfield(w, :_widget), getfield(value, :_widget))
    elseif name === :end_child
        value::GtkWidget
        SGtk_Lib.sgtk_paned_set_end_child(getfield(w, :_widget), getfield(value, :_widget))
    else
        widget_setproperty!(w, name, value)
    end
end

@inline function Base.setproperty!(w::GtkLabel, name::Symbol, value)
    if name === :text || name === :label
        SGtk_Lib.sgtk_label_set_text(getfield(w, :_widget), value::String)
    else
        widget_setproperty!(w, name, value)
    end
end

@inline function Base.setproperty!(w::GtkScrolledWindow, name::Symbol, value)
    if name === :child
        value::GtkWidget
        SGtk_Lib.sgtk_scrolled_window_set_child(getfield(w, :_widget), getfield(value, :_widget))
    else
        widget_setproperty!(w, name, value)
    end
end


@inline function Base.setproperty!(w::GtkBox, name::Symbol, value)
    widget_setproperty!(w, name, value)
end

@inline function Base.setproperty!(w::GtkButton, name::Symbol, value)
    if name == :label
        SGtk_Lib.sgtk_button_set_label(getfield(w, :_widget), value::String)
    else
        widget_setproperty!(w, name, value)
    end
end

function Base.push!(w::GtkBox, child::GtkWidget)
    SGtk_Lib.sgtk_box_append(getfield(w, :_widget), getfield(child, :_widget))
    return w
end


function Base.push!(w::GtkNotebook, child::GtkWidget, title::String)
    label = SGtk_Lib.sgtk_label_new(title)
    SGtk_Lib.sgtk_notebook_append_page(getfield(w, :_widget), getfield(child, :_widget), label)
    return w
end

function GtkWindow(app::GApp)
    ptr = SGtk_Lib.sgtk_window_new(app)
    return GtkWindow(ptr)
end

function GtkWindow(app::GApp, title::String, width::Int, height::Int)
    ptr = SGtk_Lib.sgtk_window_new(app)
    SGtk_Lib.sgtk_window_set_title(ptr, title)
    SGtk_Lib.sgtk_widget_set_size_request(ptr, Int32(width), Int32(height))
    return GtkWindow(ptr)
end

@inline function GtkPaned(v::Union{Symbol, GtkOrientation.T})
    orientation = GtkOrientation.HORIZONTAL
    if v === :v || v === :vertical
        orientation = GtkOrientation.VERTICAL
    elseif v === :h || v === :horizontal
        # do nothing
    elseif v isa GtkOrientation.T
        orientation = v
    else
        error("Unsupported orientation: $v")
    end
    ptr = SGtk_Lib.sgtk_paned_new(orientation)
    return GtkPaned(ptr)
end

function GtkLabel(text::String)
    ptr = SGtk_Lib.sgtk_label_new(text)
    return GtkLabel(ptr)
end

function GtkButton(text::String)
    ptr = SGtk_Lib.sgtk_button_new_with_label(text)
    return GtkButton(ptr)
end

function GtkScrolledWindow()
    ptr = SGtk_Lib.sgtk_scrolled_window_new()
    return GtkScrolledWindow(ptr)
end

function GtkNotebook()
    ptr = SGtk_Lib.sgtk_notebook_new()
    return GtkNotebook(ptr)
end

function GtkBox(v::Union{Symbol, GtkOrientation.T}, spacing::Int = 0)
    orientation = GtkOrientation.HORIZONTAL
    if v === :v || v === :vertical
        orientation = GtkOrientation.VERTICAL
    elseif v === :h || v === :horizontal
        # do nothing
    elseif v isa GtkOrientation.T
        orientation = v
    else
        error("Unsupported orientation: $v")
    end

    ptr = SGtk_Lib.sgtk_box_new(orientation, Int32(spacing))
    return GtkBox(ptr)
end

function Base.setindex!(w::GtkWindow, child::GtkWidget)
    SGtk_Lib.sgtk_window_set_child(getfield(w, :_widget), getfield(child, :_widget))
end

function Base.setindex!(w::GtkScrolledWindow, child::GtkWidget)
    SGtk_Lib.sgtk_scrolled_window_set_child(getfield(w, :_widget), getfield(child, :_widget))
end