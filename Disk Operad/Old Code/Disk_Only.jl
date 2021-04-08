using Colors, Compose
set_default_graphic_size(10cm, 10cm)

include("Disk_Old.jl")

"""
    disk_compose_single(root, origin, leaf_only::Int)
"""
function disk_compose_single(root, origin, leaf_only::Int)
    leafs = []
    center = (origin[1] + (root.location[1] * cosd(root.location[2])), origin[2] + (root.location[1] * sind(root.location[2])))
    if isempty(root.parameters)
        return [draw_disk(root, origin, leaf_only)]
    else
        for i in root.parameters    
            leafs = [leafs; disk_compose_single(i, center, leaf_only)]
        end

        if leaf_only != 2
            leafs = [leafs; [draw_disk(root, origin, leaf_only)]]
        end
    end
    return leafs
end

"""
    disk_compose_single_base(root, leaf_only::Int)
"""
function disk_compose_single_base(root, leaf_only::Int)
    leafs = []
    center = (0.5, 0.5)
    for i in root.parameters    
        leafs = [leafs; disk_compose_single(i, center, leaf_only)]
    end

    return (context(), 
    leafs...,
    (context(), circle(center[1] + (root.location[1] * cosd(root.location[2])), center[2] + (root.location[1] * sind(root.location[2])), root.radius),  fill("bisque")),
    (context(), rectangle()), fill("tomato"))
end

function main()
    root = Disk_old("a", "bisque",(0, 0), 0.45, [])
    add_disk(root, "a", Disk_old("b", s"orange", (0.235, 45), 0.2, []))
    add_disk(root, "a", Disk_old("c", "red", (0.20, 225), 0.225, []))
    add_disk(root, "b", Disk_old("d", "black", (0.04, 45), 0.1, []))
    add_disk(root, "c", Disk_old("e", "yellow", (0.1, 0), 0.1, []))
    add_disk(root, "c", Disk_old("e", "lime", (0.1, 180), 0.05, []))
    compose(context(), disk_compose_single_base(root,0))
end

main()