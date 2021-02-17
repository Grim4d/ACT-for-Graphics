compose(context(), 
            [compose(context(0.25, 0.25, 0.25, 0.25), circle(0.5, 0.5, 0.375), fill("red")), compose(context(), circle(0.5,0.5, 0.25), fill("green"))]...,
            compose(context(), circle(0.5, 0.5, 0.5),  fill("bisque")),
            compose(context(), rectangle()), fill("tomato"))