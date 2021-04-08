using Colors, Compose
using Cairo, Fontconfig
using Plots
import FileIO

using Compose: circle, rectangle

include("Assisting Files/Disk.jl")

set_default_graphic_size(10cm, 10cm)

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
    all_disks = Dict{String, Disk}()
    all_disks["a"] = Disk("bisque", [0.9], [complex(0.5/sqrt(2), 0.5/sqrt(2)), complex(-0.5/sqrt(2), -0.5/sqrt(2))])
    all_disks["b"] = Disk("orange", [0.5], [complex(0.5/sqrt(2), 0.5/sqrt(2))])
    all_disks["c"] = Disk("red", [0.4], [complex(0.5/sqrt(2), 0.5/sqrt(2)), complex(-0.5/sqrt(2), -0.5/sqrt(2))])
    all_disks["d"] = Disk("black", [0.9], [])
    all_disks["e"] = Disk("yellow", [0.3], [])
    all_disks["f"] = Disk("lime", [0.4], [])

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
end

main()