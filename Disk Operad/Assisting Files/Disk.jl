struct Disk
    color
    radius::Vector{Float64}
    parameters::Vector{Complex}
end

"""
    draw_disk(to_draw, origin, dash)
Basics for drawing a disk. The origin is what the disk will be relative to, and dash will be used for circles with outlines
"""
function draw_disk(to_draw::Disk, position::Tuple{Float64,Float64}, dash::Int, relative_size::Float64 = 0.5)
    return compose(context(), circle(position[1], position[2], to_draw.radius[1]*relative_size), fill(to_draw.color))
end

"""
    disk_compose_single(root, origin, leaf_only::Int)
"""
function disk_compose_single(command::Expr, disks::Dict{String, Disk}, center_point, leaf_only::Int)
    tree = []

    center_disk = disks[string(command.args[1])]
    relative_radius = center_disk.radius[1] * 0.5

    if size(command.args)[1] == 1
        return [draw_disk(center_disk, center_point, leaf_only)]
    else
        
        for i = 2:size(command.args)[1]
            new_center = (0.5 + (0.5*real(center_disk.parameters[i-1])), 0.5 + (0.5*imag(center_disk.parameters[i-1])))
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
    relative_radius = center_disk.radius[1] * 0.5

    for i = 2:size(command.args)[1]
        new_center = (0.5 + (0.5*real(center_disk.parameters[i-1])), 0.5 + (0.5*imag(center_disk.parameters[i-1])))
        tree = [tree; compose(context(center_point[1]-relative_radius, center_point[2]-relative_radius, 2*relative_radius, 2*relative_radius), 
            disk_compose_single(command.args[i], disks, new_center, leaf_only)...)]
    end

    return (context(), 
    tree...,
    compose(context(), circle(center_point[1], center_point[2], center_disk.radius[1]*0.5), fill(center_disk.color)),
    compose(context(), rectangle()), fill(colorant"rgba(0,0,0,0)"))
end