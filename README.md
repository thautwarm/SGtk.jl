# SGtk.jl

AOT-compatible Gtk4 binding for Julia.

P.S: I might present a full example once I got the permission from the example author.

This basically adopts Gtk4.jl's API, but with strict type stability using Julia generated functions and some FFI techniques.

```julia
using SGtk

function main()
    run_gtk("org.gtk.example") do app
        window = GtkWindow(app, "Hello World", 560, 400)
        window[] = paned = GtkPaned(:v)
        show_gtk(window)
    end
end

@isdefined(SyslabCC) || main()
```
