# Run from repo root.

f = joinpath(pwd(), "data", "torah-verbs-numbered.cex")
rawcols = map(row -> split(row, "|"), readlines(f))

lenn = map(row -> length(row), rawcols)