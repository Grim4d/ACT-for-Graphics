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
Basics for drawing a disk. THe origin is what the disk will be relative to, and dash will be used for circles with outlines
"""
function draw_disk(to_draw, position, dash)
    return compose(context(), circle(position[1], position[2], to_draw.radius), fill(to_draw.color))
end

"""
    disk_compose_single(root, origin, leaf_only::Int)
"""
function disk_compose_single(command::Expr, disks::Dict{String, Disk}, center, leaf_only::Int)
    tree = []
    center_disk = disks[string(command.args[1])]
    if size(command.args)[1] == 1
        return [draw_disk(center_disk, center, leaf_only)]
    else
        for i = 2:size(command.args)[1]
            new_center = (center[1] + (center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)), center[2] + (center_disk.parameters[i-1].radius * sind(center_disk.parameters[i-1].angle)))
            tree = [tree; disk_compose_single(command.args[i], disks, new_center, leaf_only)]
        end

        if leaf_only != 2
            tree = [tree; [draw_disk(center_disk, center, leaf_only)]]
        end
    end
    return tree
end

"""
    disk_compose_single_base(root, leaf_only::Int)
"""
function disk_compose_single_base(command::Expr, disks::Dict{String,Disk}, leaf_only::Int)
    tree = []
    center_point = (0.5, 0.5)
    center_disk = disks[string(command.args[1])]
    for i = 2:size(command.args)[1]
        new_center = (center_point[1] + (center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)), center_point[2] + (center_disk.parameters[i-1].radius * cosd(center_disk.parameters[i-1].angle)))
        tree = [tree; disk_compose_single(command.args[i], disks, new_center, leaf_only)]
    end

    return (context(), 
    tree...,
    (context(), circle(center_point[1], center_point[2], center_disk.radius),  fill("bisque")),
    (context(), rectangle()), fill("tomato"))
end

function main()
    all_disks = Dict{String, Disk}()
    all_disks["a"] = Disk("bisque", 0.45, [Parameter_Data(45, 0.235), Parameter_Data(225, 0.20)])
    all_disks["b"] = Disk("orange", 0.2, [Parameter_Data(45, 0.04)])
    all_disks["c"] = Disk("red", 0.225, [Parameter_Data(0, 0.1), Parameter_Data(180, 0.1)])
    all_disks["d"] = Disk("black", 0.1, [])
    all_disks["e"] = Disk("yellow", 0.1, [])
    all_disks["f"] = Disk("lime", 0.05, [])
    compose(context(), disk_compose_single_base(Meta.parse("a(b(d()), c(e(), f()))"), all_disks, 0))
end

main()