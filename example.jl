using SGtk

function main()
    run_gtk("org.gtk.example") do app
        window = GtkWindow(app, "Hello World", 560, 400)
        window[] = paned = GtkPaned(:v)
        show_gtk(window)
    end
end

@isdefined(SyslabCC) || main()