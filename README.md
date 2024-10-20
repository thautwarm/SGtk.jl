# SGtk.jl

AOT-compatible Gtk4 binding for Julia.

P.S: I might present a full example when getting the permission from the example author.

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

# Build C library

You need to install `gtk4` system-wide, then run the following command to build the shared library.

```sh
gcc -shared -fPIC $(pkg-config --cflags gtk4) small_gtk.c -o sgtk.dll $(pkg-config --libs gtk4)
```

About `gtk4` installation:

1. msys2: `pacman -S mingw-w64-ucrt-x86_64-gtk4`
2. Ubuntu 22.04: `sudo apt install libgtk-4-dev`
