using Colors, Compose
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
    println(to_draw.radius*relative_size)
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
            new_center = (0.5 + (0.5*center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)), 0.5 + (0.5*center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)))
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
        new_center = (center_point[1] + (relative_radius * center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)), center_point[2] + (relative_radius * center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)))
        tree = [tree; compose(context(center_point[1]-relative_radius, center_point[2]-relative_radius, 2*relative_radius, 2*relative_radius), 
            disk_compose_single(command.args[i], disks, new_center, leaf_only)...)]
    end

    return (context(), 
    tree...,
    compose(context(), circle(center_point[1], center_point[2], center_disk.radius*relative_radius),  fill("bisque")),
    compose(context(), rectangle()), fill("tomato"))
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
end

main()