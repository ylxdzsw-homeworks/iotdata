const namelist = let
    names = open(readline, "../data/cs-training.csv") |> chomp
    split(names, ',')[3:end]
end

const nodereg = r"(\d+):\[f(\d+)([<>].+)\] yes=(\d+),no=(\d+),missing=(\d+)"
const leafreg = r"(\d+):leaf=(-?[\d\.]+)"
const treereg = r"booster\[(\d+)\]"
const linetypes = (:node=>nodereg, :leaf=>leafreg, :tree=>treereg)

const graphtail = "}"
const graphhead = """
    digraph booster {
        node [fontsize=20 fontname=Consolas]
        edge [fontsize=20 fontname=Consolas]

    """

lines = open(readlines, "dump.txt")
lines = map(strip, lines)
lines = map(lines) do x
    x = strip(x)

    for (k, reg) in linetypes
        m = match(reg, x)
        m == nothing || return k, m.captures...
    end

    error("parsing $x")
end

graphs = let
    buffers = IOBuffer[]
    output(x...) = println(buffers[end], "    ", x...)

    for line in lines
        if line[1] == :tree
            push!(buffers, IOBuffer())
        elseif line[1] == :node
            _, self, feature, condition, yes, no, missing = line
            feature = namelist[parse(feature)]
            output('n', self, " [label=\"", feature, condition, "\" shape=box]")
            output('n', self, " -> ", 'n', yes, " [label=Y]")
            output('n', self, " -> ", 'n', no,  " [label=N]")
        elseif line[1] == :leaf
            _, self, probability = line
            output('n', self, " [label=\"", probability, "\"]")
        end
    end

    map(x -> graphhead * readall(seekstart(x)) * graphtail, buffers)
end

for (i,g) in enumerate(graphs)
    open("graphs/$i.gv", "w") do x
        write(x, g)
    end
    run(`bash -c "dot -Tsvg -o graphs/$i.svg graphs/$i.gv"`)
end

import Restful.JLT

open("graphs/index.html", "w") do x
    write(x, JLT.render("template.jlt"))
end
