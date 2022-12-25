const digs = ['=', '-', '0', '1', '2']
value(v) = indexin(v, digs)[1] - 3

from_snafu(num) = isempty(num) ? 0 : value(last(num)) + 5 * from_snafu(num[1:end - 1])
to_snafu(num) = num == 0 ? "" :  to_snafu((num + 2) ÷ 5) * string(digs[(num + 2) % 5 + 1])

readlines(stdin) .|> from_snafu |> sum |> to_snafu |> println
