using Colors, Compose
set_default_graphic_size(10cm, 10cm)

struct Disk
    identifier::String
    color::String
    location::Tuple{Float64, Float64}
    radius::Float64
    parameters::Vector{Disk}
end

"""
    add_disk(rt::Disk, parent, child = [])

The basic tree creation for disk operads. Specifying the new Disk, the parent identifier, and any potential children.
"""
function add_disk(rt::Disk, parent, child = [])
    found = false

    if parent == rt.identifier
        push!(rt.parameters, child)
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

"""
    draw_disk(to_draw, origin, dash)
Basics for drawing a disk. THe origin is what the disk will be relative to, and dash will be used for circles with outlines
"""
function draw_disk(to_draw, origin, dash)
    center = (origin[1] + (to_draw.location[1] * cosd(to_draw.location[2])), origin[2] + (to_draw.location[1] * sind(to_draw.location[2])))
    return compose(context(), circle(center[1], center[2], to_draw.radius), fill(to_draw.color))
    #if dash == 0
    #    circle = compose(context(), circle(center[1], center[2], to_draw.radius), fill(to_draw.color))
    #elseif dash == 1
    #    circle = compse(context(), arc(center[1], center[2], to_draw.radius, range(0, step=pi/4, length=8), range(pi/8, step=pi/4, length = 8)), fill(to_draw.color))
    #else
    #    circle = 0;
    #end
end

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

"""
    height_calculation(root)
"""
function height_calculation(root)
    height = 2 * root.radius + 0.3
    additional_height = 0
    for i in root.parameters
        temp = height_calculation(i)
        if additional_height < temp
            additional_height = temp
        end
    end
    height = height + additional_height;
    return height
end

"""
    disk_compose_tree(root, height, width)
"""
function disk_compose_tree(root, height, width)

end

"""
    disk_compose_tree_base(root)
"""
function disk_compose_tree_base(root)
    height = height_calculation(root)
    
    println(height)

    leafs = []
    #center = (0.5, 0.5)
    #for i in root.parameters    
        #leafs = [leafs; disk_compose_tree(i, cur_height, cur_width)]
    #end

    return (context(), 
    leafs...,
    (context(), circle( root.radius, root.radius, root.radius),  fill("bisque")),
    (context(), rectangle()), fill("tomato"))
end

function main()
    root = Disk("a", "bisque",(0, 0), 0.45, [])
    add_disk(root, "a", Disk("b", "orange", (0.235, 45), 0.2, []))
    add_disk(root, "a", Disk("c", "red", (0.20, 225), 0.225, []))
    add_disk(root, "b", Disk("d", "black", (0.04, 45), 0.1, []))
    add_disk(root, "c", Disk("e", "yellow", (0.1, 0), 0.1, []))
    add_disk(root, "c", Disk("e", "lime", (0.1, 180), 0.05, []))
    compose(context(), disk_compose_single_base(root,0))
end

main()