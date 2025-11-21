# If run from repo root:
f = joinpath(pwd(), "data", "torah-verbs-numbered.cex")

rawcols = map(row -> split(row,"|"), readlines(f)[2:end])


longies = filter(row -> length(row) > 17, rawcols)

shorties = filter(row -> length(row) < 14, rawlcols)

nogood = filter(row -> length(row) < 14 || length(row) > 17, rawcols)