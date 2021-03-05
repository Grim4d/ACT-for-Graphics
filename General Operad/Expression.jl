using Colors, Compose
using Cairo, Fontconfig
using Plots
import FileIO

using Compose: circle, rectangle

set_default_graphic_size(10cm, 20cm)

struct Parameter_Data
    angle::Float64
    radius::Float64
end

struct Disk
    color::String
    radius::Float64
    parameters::Vector{Parameter_Data}
end

struct Animation

end

"""
    draw_disk(to_draw, origin, dash)
Basics for drawing a disk. The origin is what the disk will be relative to, and dash will be used for circles with outlines
"""
function draw_disk(to_draw::Disk, value::String, position::Tuple{Float64,Float64}, dash::Int = 0, relative_size::Float64 = 0.5)
    return compose(context(), Compose.text(position[1], position[2], value, hcenter, vcenter), fill(to_draw.color), fontsize(20))
end

function height_width_calc(command::Expr)
    if size(command.args)[1] == 1
        return (1, 1)
    end

    height = 1;
    width = 0;
    for i = 2:size(command.args)[1]
        new_values = height_width_calc(command.args[i])

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
function disk_compose_tree(command::Expr, disks)
    center_point = (0.5, 0.5)
    cur_disk = disks[string(command.args[1])]
    if size(command.args)[1] == 1
        return [draw_disk(cur_disk, string(command.args[1]), center_point)]
    end

    tree = []
    height,width = height_width_calc(command)
    cur_w = 0

    for i = 2:size(command.args)[1]
        this_h, this_w = height_width_calc(command.args[i])
        tree = [tree; compose(context(cur_w/width, 1/height, this_w/width, this_h/height), 
                disk_compose_tree(command.args[i], disks))]
        cur_w = cur_w + this_w
    end

    (context(),
    tree...,
    compose(context(0, 0, 1/width, 1/height), draw_disk(cur_disk, string(command.args[1]), center_point)))
end

"""
    disk_compose_tree_base(root)
"""
function disk_compose_tree_base(command::Expr, disks)
    center_point = (0.5, 0.5)
    cur_disk = disks[string(command.args[1])]

    tree = []
    height,width = height_width_calc(command)
    cur_w = 0

    for i = 2:size(command.args)[1]
        this_h, this_w = height_width_calc(command.args[i])
        tree = [tree; compose(context(cur_w/width, 1/height, this_w/width, this_h/height), 
                disk_compose_tree(command.args[i], disks))]
        cur_w = cur_w + this_w
    end

    return (context(),
    tree...,
    compose(context(0, 0, 1/width, 1/height), draw_disk(cur_disk, string(command.args[1]), center_point)),
    compose(context(), rectangle()), fill("black"))
end

function main()
    all_disks = Dict{String, Disk}()
    all_disks["a"] = Disk("bisque", 0.95, [Parameter_Data(45, 0.5), Parameter_Data(225, 0.5)])
    all_disks["b"] = Disk("orange", 0.7, [Parameter_Data(45, 0.5)])
    all_disks["c"] = Disk("red", 0.95, [Parameter_Data(45, 0.5), Parameter_Data(225, 0.5)])
    all_disks["*"] = Disk("teal", 0.9, [])
    all_disks["1"] = Disk("yellow", 0.7, [])
    all_disks["+"] = Disk("lime", 0.8, [])
    expression = "a(c() * c() + b()) + (a(c() * c()) + b())"
    #compose(context(), disk_compose_single_base(Meta.parse(expression), all_disks, 0))
    
    compose(context(0, 0, 1, 1), disk_compose_tree_base(Meta.parse(expression), all_disks))

    # Animation Code
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