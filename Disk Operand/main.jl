using Colors, Compose
set_default_graphic_size(10cm, 10cm)

struct Disk
    identifier::String
    location::Tuple{Float64, Float64}
    radius::Float64
    parameters::Vector{Disk}
end

function add_disk(rt::Disk, parent, child)
    found = false

    if parent == rt.identifier
        append!(rt.parameters, [child])
        return (rt, true)
    end

    for i in rt.parameters
        found_m = false
        (i, found_m) = add_disk(i, parent, child)
        if found_m == true
            found = true
        end
    end

    return rt, found
end

function disk_compose_base(root)
    return (context(), 
    ,
    (context(), circle(root.location[0], root.location[1], locatio.radius),
    disk_compose)
end

function disk_compose(root)
    compose(context(), circle(0.5, 0.5, 0.2))
end

function main()
    root = Disk("a", (0.5, 0.5), 0.4, [])
    add_disk(root, "a", Disk("b", (0, 0), 0.3, []))
    add_disk(root, "b", Disk("c", (0, 0), 0.2, []))
    disk_compose_base(root)
    
    

end

main()