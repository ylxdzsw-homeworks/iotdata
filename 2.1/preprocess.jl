using DataFrames

# 读取文件
df = readtable("rawdata.csv.utf8")

# 删除不相关的属性
delete!(df, 1)

# 统一列名
names!(df, [:起始时间, :通信时长, :通信方式, :对方号码, :通信地点, :通信类型, :亲密性, :性别])

# 统一通信时长单位
df[:通信时长] = map(df[:通信时长]) do x
    x = split(x[1:end-1], "分")
    length(x)==2 ? parse(x[1])*60+parse(x[2]) : parse(x[1])
end |> DataVector{Int64}

# 与每个号码的总通话时长
df_time = df[[:对方号码, :通信时长]] |> groupby(:对方号码) |> sum
writetable("总通信时长.csv", df_time)

# 计算各统计量
open("statistics.txt", "w") do f
    i = df[:通信时长]
    print(f, """
    通信时长:
        平均值: $(mean(i))
        标准差: $(std(i))
        最小值: $(quantile(i)[1])
        1/4分位数: $(quantile(i)[2])
        中位数: $(quantile(i)[3])
        3/4分位数: $(quantile(i)[4])
        最大值: $(quantile(i)[5])

    """)
    for i in [:通信方式, :对方号码, :通信地点, :通信类型, :亲密性, :性别]
        print(f, """
        $i:
            众数: $(mode(df[i]))
            异众比率: $(sum(df[i].!=mode(df[i]))/length(df[i])*100)%

        """)
    end
end

# 绘制盒图
using Gadfly
plot(df, x=["全部"], y=:通信时长, Geom.boxplot)
plot(df, x=:通信方式, y=:通信时长, Geom.boxplot)
plot(df, x=:通信地点, y=:通信时长, Geom.boxplot)
plot(df, x=:通信类型, y=:通信时长, Geom.boxplot)
plot(df, x=:亲密性, y=:通信时长, Geom.boxplot)
plot(df, x=:性别, y=:通信时长, Geom.boxplot)

# 输出
writetable("processed.csv", df)
