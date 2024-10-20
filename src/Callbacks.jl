export run_gtk, add_timeout!, add_signal!

struct AnyWrap; o::Any; end
const MEM_FORGOT = AnyWrap[]
const MEM_FREE_SLOT = Int[]

struct TimeoutClosure{F}; f::F; end
struct TimeoutClosureCaller{F} end

struct SignalClosure{F}; f::F; end
struct SignalClosureCaller{F} end

struct GtkRunnerClosure{F}; f::F; end
struct GtkRunnerClosureCaller{F} end

@inline function _alloc(v)::Int
    if isempty(MEM_FREE_SLOT)
        push!(MEM_FORGOT, AnyWrap(v))
        return length(MEM_FORGOT)
    else
        slot = pop!(MEM_FREE_SLOT)
        MEM_FORGOT[slot] = AnyWrap(v)
        return slot
    end
end

@inline function _free(slot::Int)
    MEM_FORGOT[slot] = AnyWrap(nothing)
    push!(MEM_FREE_SLOT, slot)
end

function (c::TimeoutClosureCaller{F})(slot::Int) where {F}
    wrapped = MEM_FORGOT[slot]
    v = false
    try
        closure = wrapped.o::TimeoutClosure{F}
        f = closure.f
        v = f()
    catch e
        println("timeout callback error:")

        # syslabcc 暂不支持 showerror :(
        println(inspect(e))
    end
    if v
        return Cint(1)
    else
        _free(slot)
        return Cint(0)
    end
end

@generated function add_timeout!(f::F, interval::Int) where {F<:Function}
    ClosureT = TimeoutClosure{F}
    toplevel_fn = TimeoutClosureCaller{F}()
    return quote
        erased = _alloc($ClosureT(f))
        fptr = @cfunction($toplevel_fn, Cint, (Int, ))

        # TODO: GC, or not needed in SyslabCC
        erased = reinterpret(Ptr{Cvoid}, erased)
        SGtk_Lib.sgtk_timeout_add(Int32(interval), fptr, erased)
    end
end

function (c::SignalClosureCaller{F})(_unused_widget::Ptr{Cvoid}, slot::Int) where {F}
    wrapped = MEM_FORGOT[slot]
    try
        closure = wrapped.o::SignalClosure{F}
        f = closure.f
        f()
    catch e
        println("signal callback error:")
        # syslabcc 暂不支持 showerror :(
        println(inspect(e))
    end
    return nothing
end

@generated function add_signal!(widget::GtkWidget, signal::String, f::F) where {F<:Function}
    ClosureT = SignalClosure{F}
    toplevel_fn = SignalClosureCaller{F}()
    return quote
        erased = _alloc($ClosureT(f))
        fptr = @cfunction($toplevel_fn, Cvoid, (Ptr{Cvoid}, Int, ))

        # TODO: GC, or not needed in SyslabCC
        erased = reinterpret(Ptr{Cvoid}, erased)
        SGtk_Lib.sgtk_signal_connect(getfield(widget, :_widget), signal, fptr, erased)
    end
end

function (c::GtkRunnerClosureCaller{F})(app::GApp, slot::Int) where {F}
    wrapped = MEM_FORGOT[slot]
    try
        closure = wrapped.o::GtkRunnerClosure{F}
        f = closure.f
        f(app)
    catch e
        println("gtk runner callback error:")
        # syslabcc 暂不支持 showerror :(
        println(inspect(e))
    end
    return nothing
end


@generated function run_gtk(f::F, app_id::String) where {F<:Function}
    ClosureT = GtkRunnerClosure{F}
    toplevel_fn = GtkRunnerClosureCaller{F}()

    return quote
        erased = _alloc($ClosureT(f))
        fptr = @cfunction($toplevel_fn, Cvoid, (GApp, Int, ))

        # TODO: GC, or not needed in SyslabCC
        erased = reinterpret(Ptr{Cvoid}, erased)
        SGtk_Lib.sgtk_main(app_id, fptr, erased)
    end
end
