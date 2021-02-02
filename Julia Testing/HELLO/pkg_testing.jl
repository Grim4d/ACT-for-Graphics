using Pkg;
Pkg.add("Catlab")
Pkg.add("AlgebraicPetri")
Pkg.add("AlgebraicRelations")
Pkg.add("IJulia")

using IJulia;

print("Hello")
IJulia.notebook()