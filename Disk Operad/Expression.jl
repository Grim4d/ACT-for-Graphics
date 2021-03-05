using Colors, Compose
using Cairo, Fontconfig
using Plots
import FileIO

using Compose: circle, rectangle

set_default_graphic_size(10cm, 10cm)

struct Parameter_Data
    angle::Float64
    radius::Float64
end

struct Disk
    color::String
    radius::Float64
    parameters::Vector{Parameter_Data}
end

"""
    draw_disk(to_draw, origin, dash)
Basics for drawing a disk. The origin is what the disk will be relative to, and dash will be used for circles with outlines
"""
function draw_disk(to_draw::Disk, position::Tuple{Float64,Float64}, dash::Int, relative_size::Float64 = 0.5)
    return compose(context(), circle(position[1], position[2], to_draw.radius*relative_size), fill(to_draw.color))
end

"""
    disk_compose_single(root, origin, leaf_only::Int)
"""
function disk_compose_single(command::Expr, disks::Dict{String, Disk}, center_point, leaf_only::Int)
    tree = []

    center_disk = disks[string(command.args[1])]
    relative_radius = center_disk.radius * 0.5

    if size(command.args)[1] == 1
        return [draw_disk(center_disk, center_point, leaf_only)]
    else
        
        for i = 2:size(command.args)[1]
            new_center = (0.5 + (0.5*center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)), 0.5 + (0.5*center_disk.parameters[i-1].radius * sind(center_disk.parameters[i-1].angle)))
            tree = [tree; compose(context(center_point[1]-relative_radius, center_point[2]-relative_radius, 2*relative_radius, 2*relative_radius), 
                disk_compose_single(command.args[i], disks, new_center, leaf_only)...)]
        end

        if leaf_only != 2
            tree = [tree; [draw_disk(center_disk, center_point, leaf_only)]]
        end
    end
    return tree
end

"""
    disk_compose_single_base(root, leaf_only::Int)
"""
function disk_compose_single_base(command::Expr, disks::Dict{String,Disk}, leaf_only::Int, )
    tree = []
    
    center_point = (0.5, 0.5)
    center_disk = disks[string(command.args[1])]
    relative_radius = center_disk.radius * 0.5

    for i = 2:size(command.args)[1]
        new_center = (center_point[1] + (0.5 * center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)), center_point[2] + (0.5 * center_disk.parameters[i-1].radius * sind(center_disk.parameters[i-1].angle)))
        tree = [tree; compose(context(center_point[1]-relative_radius, center_point[2]-relative_radius, 2*relative_radius, 2*relative_radius), 
            disk_compose_single(command.args[i], disks, new_center, leaf_only)...)]
    end

    return (context(), 
    tree...,
    compose(context(), circle(center_point[1], center_point[2], center_disk.radius*0.5),  fill("bisque")),
    compose(context(), rectangle()), fill("tomato"))
end

function height_calculation(command::Expr)
    if size(command.args)[1] == 1
        return (1, 1)
    end

    height = 1;
    width = 0;
    for i = 2:size(command.args)[1]
        new_values = height_calculation(command.args[i])

        width = width + new_values[2]

        if height <= new_values[1]
            height = new_values[1] + 1
        end
    end

    return (height, width)
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
    all_disks = Dict{String, Disk}()
    all_disks["a"] = Disk("bisque", 1, [Parameter_Data(45, 0.5), Parameter_Data(225, 0.5)])
    all_disks["b"] = Disk("orange", 0.5, [Parameter_Data(45, 0.5)])
    all_disks["c"] = Disk("red", 0.3, [Parameter_Data(45, 0.5), Parameter_Data(225, 0.5)])
    all_disks["d"] = Disk("black", 0.3, [])
    all_disks["e"] = Disk("yellow", 0.1, [])
    all_disks["f"] = Disk("lime", 0.4, [])
    expression = "a(b(d()), c(e(), f()))"
    compose(context(), disk_compose_single_base(Meta.parse(expression), all_disks, 0))
    
    #=
    for i in 1:360
        file_path = string("Saved Images/Disk Operad/", string(i), ".png")
        all_disks["a"] = Disk("bisque", 1, [Parameter_Data(45 + i, 0.5), Parameter_Data(225 + i, 0.5)])
        all_disks["b"] = Disk("orange", 0.5, [Parameter_Data(45 - i, 0.5)])
        all_disks["c"] = Disk("red", 0.3, [Parameter_Data(45 - i, 0.5), Parameter_Data(225 - i, 0.5)])
        frame = compose(context(), disk_compose_single_base(Meta.parse(expression), all_disks, 0))
        draw(PNG(file_path, 10cm, 10cm, dpi=250), frame) 
    end

    anim = @animate for i in 1:360
        file_path = string("Saved Images/Disk Operad/", string(i), ".png")
        image = FileIO.load(file_path)
        plot(image, axis = nothing, background_color=:transparent)
    end

    gif(anim, "Saved Images/Rotating Cicles.gif", fps = 30)
    =#
end

main()