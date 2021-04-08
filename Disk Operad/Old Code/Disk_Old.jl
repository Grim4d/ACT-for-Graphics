#=
    OLD OUT DATED CODE
=#

struct Disk_old
    identifier::String
    color::String
    location::Tuple{Float64, Float64}
    radius::Float64
    parameters::Vector{Disk_old}
end

"""
    add_disk(rt::Disk_old, parent, child = [])

The basic tree creation for disk operads. Specifying the new Disk_old, the parent identifier, and any potential children.
"""
function add_disk(rt::Disk_old, parent, child = [])
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