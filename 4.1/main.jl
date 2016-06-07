using Base.Collections

include("util.jl")
include("Graph.jl")

include("BFS.jl")
include("DFS.jl")
include("IDS.jl")

include("HIT.data")
include("Romania.data")

BFS!(HIT, "正心楼", "诚意楼")
