module SGtk_Lib
    export GWidget, GtkAlign, GApp, GtkOrientation

    struct GWidget
        ptr::Ptr{Cvoid}
    end

    struct GApp
        ptr::Ptr{Cvoid}
    end

    module GtkAlign
        export T
        @enum T::Int32 begin
            FILL = 0
            START = 1
            CENTER = 2
            END = 3
        end
    end

    module GtkOrientation
        export T
        @enum T::Int32 begin
            HORIZONTAL = 0
            VERTICAL = 1
        end
    end

    # Window APIs
    function sgtk_window_new(app::GApp)::GWidget
        ptr = ccall((:sgtk_window_new, "sgtk"), Ptr{Cvoid}, (Ptr{Cvoid},), app.ptr)
        return GWidget(ptr)
    end

    function sgtk_window_set_title(window::GWidget, title::String)
        GC.@preserve title begin
            let title_ptr = Base.unsafe_convert(Cstring, title)
                ccall((:sgtk_window_set_title, "sgtk"), Cvoid, (Ptr{Cvoid}, Cstring), window.ptr, title_ptr)
            end
        end
    end

    function sgtk_window_set_default_size(window::GWidget, width::Int32, height::Int32)
        ccall((:sgtk_window_set_default_size, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32, Int32), window.ptr, width, height)
    end

    function sgtk_window_set_child(window::GWidget, child::GWidget)
        ccall((:sgtk_window_set_child, "sgtk"), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}), window.ptr, child.ptr)
    end

    # widget APIs

    function sgtk_widget_set_valign(widget::GWidget, align::GtkAlign.T)
        ccall((:sgtk_widget_set_valign, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32), widget.ptr, align)
    end

    function sgtk_widget_set_halign(widget::GWidget, align::GtkAlign.T)
        ccall((:sgtk_widget_set_halign, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32), widget.ptr, align)
    end

    function sgtk_widget_set_vexpand(widget::GWidget, vexpand::Bool)
        vexpand = vexpand ? Int32(1) : Int32(0)
        ccall((:sgtk_widget_set_vexpand, "sgtk"), Cvoid, (Ptr{Cvoid}, Bool), widget.ptr, vexpand)
    end

    function sgtk_widget_set_margin_start(widget::GWidget, margin_start::Int32)
        ccall((:sgtk_widget_set_margin_start, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32), widget.ptr, margin_start)
    end

    function sgtk_widget_set_margin_end(widget::GWidget, margin_end::Int32)
        ccall((:sgtk_widget_set_margin_end, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32), widget.ptr, margin_end)
    end

    function sgtk_widget_set_size_request(widget::GWidget, width::Int32, height::Int32)
        ccall((:sgtk_widget_set_size_request, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32, Int32), widget.ptr, width, height)
    end

    function sgtk_widget_get_size_request(widget::GWidget)
        data = Int32[0, 0];
        d1 = pointer(data)
        d2 = pointer(data) + sizeof(Int32)
        ccall((:sgtk_widget_get_size_request, "sgtk"), Cvoid, (Ptr{Cvoid}, Ptr{Int32}, Ptr{Int32}), widget.ptr, d1, d2)
        return (data[1], data[2])
    end

    function sgtk_widget_set_sensitive(widget::GWidget, sensitive::Bool)
        sensitive = sensitive ? Int32(1) : Int32(0)
        ccall((:sgtk_widget_set_sensitive, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32), widget.ptr, sensitive)
    end

    # paned APIs

    function sgtk_paned_new(orientation::GtkOrientation.T)::GWidget
        ptr = ccall((:sgtk_paned_new, "sgtk"), Ptr{Cvoid}, (Int32,), Int32(orientation))
        return GWidget(ptr)
    end

    function sgtk_paned_set_position(paned::GWidget, position::Int32)
        ccall((:sgtk_paned_set_position, "sgtk"), Cvoid, (Ptr{Cvoid}, Int32), paned.ptr, position)
    end

    function sgtk_paned_set_start_child(paned::GWidget, child::GWidget)
        ccall((:sgtk_paned_set_start_child, "sgtk"), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}), paned.ptr, child.ptr)
    end

    function sgtk_paned_set_end_child(paned::GWidget, child::GWidget)
        ccall((:sgtk_paned_set_end_child, "sgtk"), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}), paned.ptr, child.ptr)
    end

    # Box APIs

    function sgtk_box_new(orientation::GtkOrientation.T, spacing::Int32)::GWidget
        ptr = ccall((:sgtk_box_new, "sgtk"), Ptr{Cvoid}, (Int32, Int32), Int32(orientation), spacing)
        return GWidget(ptr)
    end

    function sgtk_box_append(box::GWidget, child::GWidget)
        ccall((:sgtk_box_append, "sgtk"), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}), box.ptr, child.ptr)
    end

    # Label APIs

    function sgtk_label_new(text::String)::GWidget
        GC.@preserve text begin
            let text_ptr = Base.unsafe_convert(Cstring, text)
                ptr = ccall((:sgtk_label_new, "sgtk"), Ptr{Cvoid}, (Cstring,), text_ptr)
                return GWidget(ptr)
            end
        end
    end

    function sgtk_label_set_text(label::GWidget, text::String)
        GC.@preserve text begin
            let text_ptr = Base.unsafe_convert(Cstring, text)
                ccall((:sgtk_label_set_text, "sgtk"), Cvoid, (Ptr{Cvoid}, Cstring), label.ptr, text_ptr)
            end
        end
    end

    function sgtk_button_new_with_label(text::String)::GWidget
        GC.@preserve text begin
            let text_ptr = Base.unsafe_convert(Cstring, text)
                ptr = ccall((:sgtk_button_new_with_label, "sgtk"), Ptr{Cvoid}, (Cstring,), text_ptr)
                return GWidget(ptr)
            end
        end
    end

    function sgtk_button_set_label(button::GWidget, text::String)
        GC.@preserve text begin
            let text_ptr = Base.unsafe_convert(Cstring, text)
                ccall((:sgtk_button_set_label, "sgtk"), Cvoid, (Ptr{Cvoid}, Cstring), button.ptr, text_ptr)
            end
        end
    end

    # Scrolled Window APIs
    function sgtk_scrolled_window_new()::GWidget
        ptr = ccall((:sgtk_scrolled_window_new, "sgtk"), Ptr{Cvoid}, ())
        return GWidget(ptr)
    end

    function sgtk_scrolled_window_set_child(scrolled::GWidget, child::GWidget)
        ccall((:sgtk_scrolled_window_set_child, "sgtk"), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}), scrolled.ptr, child.ptr)
    end

    # Notebook APIs
    function sgtk_notebook_new()::GWidget
        ptr = ccall((:sgtk_notebook_new, "sgtk"), Ptr{Cvoid}, ())
        return GWidget(ptr)
    end

    function sgtk_notebook_append_page(notebook::GWidget, child::GWidget, tab_label::GWidget)
        ccall((:sgtk_notebook_append_page, "sgtk"), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), notebook.ptr, child.ptr, tab_label.ptr)
    end

    # Callback & Misc APIs

    function sgtk_show(window::GWidget)
        ccall((:sgtk_show, "sgtk"), Cvoid, (Ptr{Cvoid},), window.ptr)
    end

    function sgtk_timeout_add(interval::Int32, callback::Ptr{Cvoid}, data::Ptr{Cvoid})::Int32
        ccall((:sgtk_timeout_add, "sgtk"), Int32, (Int32, Ptr{Cvoid}, Ptr{Cvoid}), interval, callback, data)
    end

    function sgtk_signal_connect(widget::GWidget, signal::String, callback::Ptr{Cvoid}, data::Ptr{Cvoid})
        GC.@preserve signal begin
            let signal_ptr = Base.unsafe_convert(Cstring, signal)
                ccall((:sgtk_signal_connect, "sgtk"), Cvoid, (Ptr{Cvoid}, Cstring, Ptr{Cvoid}, Ptr{Cvoid}), widget.ptr, signal_ptr, callback, data)
            end
        end
    end

    function sgtk_main(app_id::String, main::Ptr{Cvoid}, data::Ptr{Cvoid})::Int32
        GC.@preserve app_id begin
            let app_id_ptr = Base.unsafe_convert(Cstring, app_id)
                ccall((:sgtk_main, "sgtk"), Int32, (Cstring, Ptr{Cvoid}, Ptr{Cvoid}), app_id_ptr, main, data)
            end
        end
    end
end
