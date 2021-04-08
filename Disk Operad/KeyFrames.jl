using Colors, Compose
using Cairo, Fontconfig
using Plots
import FileIO

using Compose: circle, rectangle

include("Assisting Files/Disk.jl")

set_default_graphic_size(10cm, 10cm)

function main()

    num_steps = 5

    expression = "a(b(), c())"

    Frame1 = Dict{String, Disk}()
    Frame1["a"] = Disk(colorant"rgba(0,0,0,0)", [0.7], [complex(0.8 * cosd(20), 0.8 * sind(20)), complex(0.8 * cosd(-20), 0.8 * sind(-20))])
    Frame1["b"] = Disk("orange", [0.2], [])
    Frame1["c"] = Disk("red", [0.2], [])

    Frame2 = deepcopy(Frame1)
    Frame2["a"] = Disk(colorant"rgba(0,0,0,0)", [0.7], [complex(0.8 * cosd(200), 0.8 * sind(200)), complex(0.8 * cosd(160), 0.8 * sind(160))])

    Transition = deepcopy(Frame1)

    mkpath("Saved Images/Disk Operad")

    for j in 1:60
        frame = compose(context(), 
                        compose(context(), Compose.text(0.1, 0.1, string(floor(j/60 * 100), "%"), hcenter, vcenter), fontsize(5)),
                        compose(context(), circle(0.5, 0.5, Transition["a"].radius[1]*0.5),  fill("yellow")),
                        compose(context(), rectangle(), fill(colorant"white")))
        for i in 0:(60/(num_steps-1)):60
            #file_path = string("Saved Images/Disk Operad/", string(i), ".png")

            new1_angle1 = (((60 - i)/60) * angle(Frame1["a"].parameters[1])) + ((i/60) * angle(Frame2["a"].parameters[1]))
            new1_radius1 = (((60 - i)/60) * abs(Frame1["a"].parameters[1])) + ((i/60) * abs(Frame2["a"].parameters[1]))
            new1_angle2 = ((((60 - i)/60) * angle(Frame1["a"].parameters[2])) + ((i/60) * angle(Frame2["a"].parameters[2])))
            new1_angle2 = new1_angle2 - (2*pi)
            new1_radius2 = (((60 - i)/60) * abs(Frame1["a"].parameters[2])) + ((i/60) * abs(Frame2["a"].parameters[2]))
            polar1 = Disk(colorant"rgba(0,0,0,0)", [0.7], [complex( new1_radius1 * cos(new1_angle1) + 0.2, new1_radius1 * sin(new1_angle1)), complex( new1_radius2 * cos(new1_angle2 - 2 *(new1_angle2 + deg2rad(20))) - 0.2, new1_radius2 * sin(new1_angle2 - 2 *(new1_angle2 + deg2rad(20))))])
            
            polar2 = Disk(colorant"rgba(0,0,0,0)", [0.7], [(((60 - i)/60) * Frame1["a"].parameters[1]) + ((i/60) * Frame2["a"].parameters[1]), (((60 - i)/60) * Frame1["a"].parameters[2]) + ((i/60) * Frame2["a"].parameters[2])])
            polar2 = Disk(colorant"rgba(0,0,0,0)", [0.7], [complex( abs(polar2.parameters[1]) * cos(angle(polar2.parameters[1])) + 0.2, abs(polar2.parameters[1]) * sin(angle(polar2.parameters[1]))), complex( abs(polar2.parameters[2]) * cos(angle(polar2.parameters[2])) - 0.2, abs(polar2.parameters[2]) * sin(angle(polar2.parameters[2])))])

            Transition["a"] = Disk(colorant"rgba(0,0,0,0)", [0.7], [( ((60-j)/60) * polar1.parameters[1] ) + ( ((j)/60) * polar2.parameters[1] ), ( ((60-j)/60) * polar1.parameters[2] ) + ( ((j)/60) * polar2.parameters[2] )])

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
        for i in 0:(60/(num_steps-1)):60
            #file_path = string("Saved Images/Disk Operad/", string(i), ".png")
            
            new1_angle1 = (((60 - i)/60) * angle(Frame1["a"].parameters[1])) + ((i/60) * angle(Frame2["a"].parameters[1]))
            new1_radius1 = (((60 - i)/60) * abs(Frame1["a"].parameters[1])) + ((i/60) * abs(Frame2["a"].parameters[1]))
            new1_angle2 = ((((60 - i)/60) * angle(Frame1["a"].parameters[2])) + ((i/60) * angle(Frame2["a"].parameters[2])))
            new1_angle2 = new1_angle2 - (2*pi)
            new1_radius2 = (((60 - i)/60) * abs(Frame1["a"].parameters[2])) + ((i/60) * abs(Frame2["a"].parameters[2]))
            polar1 = Disk(colorant"rgba(0,0,0,0)", [0.7], [complex( new1_radius1 * cos(new1_angle1) + 0.2, new1_radius1 * sin(new1_angle1)), complex( new1_radius2 * cos(new1_angle2 - 2 *(new1_angle2 + deg2rad(20))) - 0.2, new1_radius2 * sin(new1_angle2 - 2 *(new1_angle2 + deg2rad(20))))])
            
            polar2 = Disk(colorant"rgba(0,0,0,0)", [0.7], [(((60 - i)/60) * Frame1["a"].parameters[1]) + ((i/60) * Frame2["a"].parameters[1]), (((60 - i)/60) * Frame1["a"].parameters[2]) + ((i/60) * Frame2["a"].parameters[2])])
            polar2 = Disk(colorant"rgba(0,0,0,0)", [0.7], [complex( abs(polar2.parameters[1]) * cos(angle(polar2.parameters[1])) + 0.2, abs(polar2.parameters[1]) * sin(angle(polar2.parameters[1]))), complex( abs(polar2.parameters[2]) * cos(angle(polar2.parameters[2])) - 0.2, abs(polar2.parameters[2]) * sin(angle(polar2.parameters[2])))])

            Transition["a"] = Disk(colorant"rgba(0,0,0,0)", [0.7], [( ((60-j)/60) * polar2.parameters[1] ) + ( ((j)/60) * polar1.parameters[1] ), ( ((60-j)/60) * polar2.parameters[2] ) + ( ((j)/60) * polar1.parameters[2] )])

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
    
end

main()