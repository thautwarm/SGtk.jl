function is_syslabcc()
    try
        cglobal("__is_syslabcc")
        true
    catch
        false
    end
end


struct _Wrap{T}
    x::T
end

function inspect(x)
    if is_syslabcc()
        r = ccall(:sj_object_inspect, Ptr{Cvoid}, (_Wrap{Any},), _Wrap{Any}(x))
        array = [r]
        addr = reinterpret(Ptr{_Wrap{String}}, pointer(array))
        return unsafe_load(addr).x
    else
        return Base.invokelatest(repr, x)::String
    end
end
