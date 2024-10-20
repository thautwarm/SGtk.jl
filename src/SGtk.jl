module SGtk

export show_gtk

include("Compat.jl")
include("Lib.jl")
include("Abs.jl")
include("Callbacks.jl")

function show_gtk(w::GtkWindow)
    SGtk_Lib.sgtk_show(getfield(w, :_widget))
end

end # module SGtk
