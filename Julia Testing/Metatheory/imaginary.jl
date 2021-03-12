using Metatheory
using Metatheory.EGraphs
using Metatheory.Library

@metatheory_init

comm_monoid = commutative_monoid(:(*), 1)

comm_group = @theory begin
    
    a => a / 1
    (a / 1) * (a / 1) == a / 2
    (a / 2) * (a / 1) == a / 3
    (a / 3) * (a / 1) == a / 4
    (a / 4) * (a / 1) == a / 5
    (a / 5) == a
    (a / b) == a / b
    (a / b) == (a / (b - 1)) * (a / 1)

end

distrib = @theory begin
    a * (b + c) => (a * b) + (a * c)
end

t = comm_monoid ∪ comm_group ∪ distrib

@areequal t ((a / 6) * (a / 1)) (a / 7)