using Colors, Compose
using Cairo, Fontconfig
using Plots
import FileIO

using Compose: circle, rectangle

set_default_graphic_size(10cm, 10cm)

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
    compose(context(), circle(center_point[1], center_point[2], center_disk.radius[1]*0.5),  fill(center_disk.color)))
    #compose(context(), rectangle()), fill(colorant"white"))
end

function animater(disks::Dict{String, Disk}, animations::Dict{String, Vector{String}})
    for i in keys(disks)
        eval(Meta.parse(string(i, "_r = ", disks[i].radius[1])))
        for j in 1:size(disks[i].parameters)[1]
            eval(Meta.parse(string(i, j,"_pos = ", disks[i].parameters[j])))
        end
    end

    for i in keys(disks)
        disks[i].radius[1] = eval(Meta.parse(animations[i][1]))
    end

    for i in keys(disks)
        for j in 1:size(disks[i].parameters)[1]
            disks[i].parameters[j] = eval(Meta.parse(animations[i][j+1]))
        end
    end
end

function main()
    expression = "a(b(), c())"

    Frame1 = Dict{String, Disk}()
    Frame1["a"] = Disk(colorant"rgba(0,0,0,0)", [0.9], [complex(0.8 * cosd(20), 0.8 * sind(20)), complex(0.8 * cosd(20), 0.8 * sind(-20))])
    Frame1["b"] = Disk("orange", [0.2], [])
    Frame1["c"] = Disk("red", [0.2], [])

    Frame2 = deepcopy(Frame1)
    Frame2["a"] = Disk(colorant"rgba(0,0,0,0)", [0.9], [complex(0.8 * cosd(200), 0.8 * sind(200)), complex(0.8 * cosd(160), 0.8 * sind(160))])

    Transition = deepcopy(Frame1)

    for j in 1:60
        frame = compose(context(), 
                        compose(context(), Compose.text(0.1, 0.1, string(floor(j/60 * 100), "%"), hcenter, vcenter), fontsize(5)),
                        compose(context(), circle(0.5, 0.5, Transition["a"].radius[1]*0.5),  fill("yellow")),
                        compose(context(), rectangle(), fill(colorant"white")))
        for i in 0:15:60
            #file_path = string("Saved Images/Disk Operad/", string(i), ".png")

            new1_angle1 = (((60 - i)/60) * angle(Frame1["a"].parameters[1])) + ((i/60) * angle(Frame2["a"].parameters[1]))
            new1_radius1 = (((60 - i)/60) * abs(Frame1["a"].parameters[1])) + ((i/60) * abs(Frame2["a"].parameters[1]))
            new1_angle2 = ((((60 - i)/60) * angle(Frame1["a"].parameters[2])) + ((i/60) * angle(Frame2["a"].parameters[2])))
            new1_angle2 = new_angle2 - (2*pi)
            new1_radius2 = (((60 - i)/60) * abs(Frame1["a"].parameters[2])) + ((i/60) * abs(Frame2["a"].parameters[2]))
            polar1 = Disk(colorant"rgba(0,0,0,0)", [0.9], [complex( new1_radius1 * cos(new1_angle1), new1_radius1 * sin(new1_angle1)), complex( new1_radius2 * cos(new1_angle2), new1_radius2 * sin(new1_angle2))])
            
            new2_angle1 = (((60 - i)/60) * angle(Frame1["a"].parameters[1])) + ((i/60) * angle(Frame2["a"].parameters[1]))
            new2_radius1 = (((60 - i)/60) * abs(Frame1["a"].parameters[1])) + ((i/60) * abs(Frame2["a"].parameters[1]))
            new2_angle2 = ((((60 - i)/60) * angle(Frame1["a"].parameters[2])) + ((i/60) * angle(Frame2["a"].parameters[2])))
            new2_angle2 = new_angle2 - (2*pi)
            new2_radius2 = (((60 - i)/60) * abs(Frame1["a"].parameters[2])) + ((i/60) * abs(Frame2["a"].parameters[2]))
            polar2 = Disk(colorant"rgba(0,0,0,0)", [0.9], [complex( new2_radius1 * cos(new2_angle1), new2_radius1 * sin(new2_angle1)), complex( new2_radius2 * cos(new2_angle2 - 2*(new2_angle2 + deg2rad(20))), new2_radius2 * sin(new2_angle2 - 2*(new2_angle2 + deg2rad(20))))])
            
            Transition["a"] = Disk(colorant"rgba(0,0,0,0)", [0.9], [( ((60-j)/60) * polar1.parameters[1] ) + ( ((j)/60) * polar2.parameters[1] ), ( ((60-j)/60) * polar1.parameters[2] ) + ( ((j)/60) * polar2.parameters[2] )])

            frame = compose(context(), disk_compose_single_base(Meta.parse(expression), Transition, 0), frame)
            #draw(PNG(file_path, 10cm, 10cm, dpi=250), frame)
        end
        file_path = string("Saved Images/Disk Operad/", string(j), ".png")
        draw(PNG(file_path, 10cm, 10cm, dpi=250), frame)
    end

    for j in 1:60
        frame = compose(context(), 
                        compose(context(), Compose.text(0.1, 0.1, string(floor(j/60 * 100), "%"), hcenter, vcenter), fontsize(5)),
                        compose(context(), circle(0.5, 0.5, Transition["a"].radius[1]*0.5),  fill("yellow")),
                        compose(context(), rectangle(), fill(colorant"white")))
        for i in 0:15:60
            #file_path = string("Saved Images/Disk Operad/", string(i), ".png")

            new1_angle1 = (((60 - i)/60) * angle(Frame1["a"].parameters[1])) + ((i/60) * angle(Frame2["a"].parameters[1]))
            new1_radius1 = (((60 - i)/60) * abs(Frame1["a"].parameters[1])) + ((i/60) * abs(Frame2["a"].parameters[1]))
            new1_angle2 = ((((60 - i)/60) * angle(Frame1["a"].parameters[2])) + ((i/60) * angle(Frame2["a"].parameters[2])))
            new1_angle2 = new_angle2 - (2*pi)
            new1_radius2 = (((60 - i)/60) * abs(Frame1["a"].parameters[2])) + ((i/60) * abs(Frame2["a"].parameters[2]))
            polar1 = Disk(colorant"rgba(0,0,0,0)", [0.9], [complex( new1_radius1 * cos(new1_angle1), new1_radius1 * sin(new1_angle1)), complex( new1_radius2 * cos(new1_angle2), new1_radius2 * sin(new1_angle2))])
            
            new2_angle1 = (((60 - i)/60) * angle(Frame1["a"].parameters[1])) + ((i/60) * angle(Frame2["a"].parameters[1]))
            new2_radius1 = (((60 - i)/60) * abs(Frame1["a"].parameters[1])) + ((i/60) * abs(Frame2["a"].parameters[1]))
            new2_angle2 = ((((60 - i)/60) * angle(Frame1["a"].parameters[2])) + ((i/60) * angle(Frame2["a"].parameters[2])))
            new2_angle2 = new_angle2 - (2*pi)
            new2_radius2 = (((60 - i)/60) * abs(Frame1["a"].parameters[2])) + ((i/60) * abs(Frame2["a"].parameters[2]))
            polar2 = Disk(colorant"rgba(0,0,0,0)", [0.9], [complex( new2_radius1 * cos(new2_angle1), new2_radius1 * sin(new2_angle1)), complex( new2_radius2 * cos(new2_angle2 - 2*(new2_angle2 + deg2rad(20))), new2_radius2 * sin(new2_angle2 - 2*(new2_angle2 + deg2rad(20))))])
            
            Transition["a"] = Disk(colorant"rgba(0,0,0,0)", [0.9], [( ((60-j)/60) * polar2.parameters[1] ) + ( ((j)/60) * polar1.parameters[1] ), ( ((60-j)/60) * polar2.parameters[2] ) + ( ((j)/60) * polar1.parameters[2] )])

            frame = compose(context(), disk_compose_single_base(Meta.parse(expression), Transition, 0), frame)
            #draw(PNG(file_path, 10cm, 10cm, dpi=250), frame)
        end
        file_path = string("Saved Images/Disk Operad/", string(j + 60), ".png")
        draw(PNG(file_path, 10cm, 10cm, dpi=250), frame)
    end

    anim = @animate for i in 1:120
        file_path = string("Saved Images/Disk Operad/", string(i), ".png")
        image = FileIO.load(file_path)
        plot(image, axis = nothing, background_color=:transparent)
    end

    gif(anim, "Saved Images/Rotating Cicles.gif", fps = 30)
    #=
    expression = "a(b(d()), c(e(), f()))"

    Frame1 = Dict{String, Disk}()
    Frame1["a"] = Disk(colorant"rgba(0,0,0,0)", [0.9], [complex(0.5/sqrt(2), 0.5/sqrt(2)), complex(-0.5/sqrt(2), -0.5/sqrt(2))])
    Frame1["b"] = Disk("orange", [0.5], [complex(0.8/sqrt(2), -0.8/sqrt(2))])
    Frame1["c"] = Disk("red", [0.4], [complex(0.5/sqrt(2), 0.5/sqrt(2)), complex(-0.5/sqrt(2), -0.5/sqrt(2))])
    Frame1["d"] = Disk("black", [0.2], [])
    Frame1["e"] = Disk("yellow", [0.3], [])
    Frame1["f"] = Disk("lime", [0.4], [])

    Frame2 = deepcopy(Frame1)
    Frame2["b"] = Disk("orange", [0.5], [complex(-0.8/sqrt(2), 0.8/sqrt(2))])

    Frame3 = deepcopy(Frame1)
    Frame3["b"] = Disk("orange", [0.5], [complex(-0.5/sqrt(2), -0.5/sqrt(2))])

    Transition = deepcopy(Frame1)

    for i in 1:60
        file_path = string("Saved Images/Disk Operad/", string(i), ".png")

        Transition["b"] = Disk("orange", [0.5], [( ((60-i)/60) * Frame1["b"].parameters[1] ) + ( ((i)/60) * Frame2["b"].parameters[1] )])

        frame = compose(context(), disk_compose_single_base(Meta.parse(expression), Transition, 0))
        draw(PNG(file_path, 10cm, 10cm, dpi=250), frame)
    end

    for i in 1:60
        file_path = string("Saved Images/Disk Operad/", string(i + 60), ".png")

        new_angle = (((60 - i)/60) * angle(Frame2["b"].parameters[1])) + ((i/60) * angle(Frame1["b"].parameters[1]))
        new_radius = (((60 - i)/60) * abs(Frame2["b"].parameters[1])) + ((i/60) * abs(Frame1["b"].parameters[1]))
        Transition["b"] = Disk("orange", [0.5], [complex( new_radius * cos(new_angle), new_radius * sin(new_angle))])

        frame = compose(context(), disk_compose_single_base(Meta.parse(expression), Transition, 0))
        draw(PNG(file_path, 10cm, 10cm, dpi=250), frame) 
    end

    anim = @animate for i in 1:120
        file_path = string("Saved Images/Disk Operad/", string(i), ".png")
        image = FileIO.load(file_path)
        plot(image, axis = nothing, background_color=:transparent)
    end

    gif(anim, "Saved Images/Rotating Cicles.gif", fps = 30)
    =#

    #=
    all_disks = Dict{String, Disk}()
    all_disks["a"] = Disk("bisque", [0.9], [complex(0.5/sqrt(2), 0.5/sqrt(2)), complex(-0.5/sqrt(2), -0.5/sqrt(2))])
    all_disks["b"] = Disk("orange", [0.5], [complex(0.5/sqrt(2), 0.5/sqrt(2))])
    all_disks["c"] = Disk("red", [0.4], [complex(0.5/sqrt(2), 0.5/sqrt(2)), complex(-0.5/sqrt(2), -0.5/sqrt(2))])
    all_disks["d"] = Disk("black", [0.9], [])
    all_disks["e"] = Disk("yellow", [0.3], [])
    all_disks["f"] = Disk("lime", [0.4], [])
    =#

    #=
    disk_animations = Dict{String, Vector{String}}()
    disk_animations["a"] = ["a_r * 1", "a1_pos * im ^ (4/360)", "a2_pos * im ^ (4/360)"]
    disk_animations["b"] = ["b_r * 1", "complex(( (1 - (d_r/1)) * cos(angle(b1_pos)) ), ( (1 - (d_r/1))) * sin(angle(b1_pos)) )"]
    disk_animations["c"] = ["c_r * 1", "c1_pos * im ^ (-4/360)", "c2_pos * im ^ (-4/360)"]
    disk_animations["d"] = ["(sin(angle(a1_pos))/4) + 0.5"]
    disk_animations["e"] = ["e_r * 1"]
    disk_animations["f"] = ["f_r * 1"]

    expression = "a(b(d()), c(e(), f()))"

    for i in 1:361
        file_path = string("Saved Images/Disk Operad/", string(i), ".png")
        animater(all_disks, disk_animations)
        frame = compose(context(), disk_compose_single_base(Meta.parse(expression), all_disks, 0))
        draw(PNG(file_path, 10cm, 10cm, dpi=250), frame) 
    end

    anim = @animate for i in 2:361
        file_path = string("Saved Images/Disk Operad/", string(i), ".png")
        image = FileIO.load(file_path)
        plot(image, axis = nothing, background_color=:transparent)
    end

    gif(anim, "Saved Images/Rotating Cicles.gif", fps = 30)
    =#
end

main()