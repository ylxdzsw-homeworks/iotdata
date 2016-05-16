using Gadfly
using DataFrames

A = @data [19, 18, 18, 15, 18, 11, 16, 19, 17, 17, 20, 17, 19, 20, 20, 15, 15, 16]
B = @data [19, 15, 20, 20, 17, 18, 18, 15, 16, 18, 15, 19, 20, 19, 19, 16, 17, 13, 15]

# count score
dfa = DataFrame(score=A, count=1) |> groupby(:score) |> sum
dfb = DataFrame(score=B, count=1) |> groupby(:score) |> sum

# join two class
df = join(dfa, dfb, kind=:outer, on=:score)
names!(df, [:score, :A, :B])

# replace missing values with 0
df[:A] = each_replacena(df[:A], 0) |> collect
df[:B] = each_replacena(df[:B], 0) |> collect

# reformat data to plot
dfa_for_plot = DataFrame(score=df[:score], count=df[:A], class=:A)
dfb_for_plot = DataFrame(score=df[:score], count=df[:B], class=:B)
df_for_plot = [dfa_for_plot; dfb_for_plot]
sort!(df_for_plot)

# plot histogram
plot(df_for_plot, x=:score, y=:count, color=:class,
     Scale.x_discrete, Geom.bar(position=:dodge),
     Theme(bar_spacing=2mm), Guide.title("Histogram"))

# calc quantiles
qq = [0:1/length(A):1; 0:1/length(B):1] |> unique

# q-q plot
plot(x=quantile(A, qq), y=quantile(B, qq),
     Geom.point, Geom.smooth(smoothing=0.99),
     Guide.title("q-q plot"))

