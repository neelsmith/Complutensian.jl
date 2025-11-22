
"""Read verb alignment data from a file.
"""
function readverbaligns(f; stripniqqud=true)
    alignments = []
    # Skip header line:
    for ln in readlines(f)[2:end]
        cols = split(ln, "|")
        if length(cols) < 14
            @error("Line is too short. Only $(length(cols)) columns in $(ln).")
        else
           if stripniqqud
            htoken = BiblicalHebrew.unpointed(cols[3])
            hlemma = BiblicalHebrew.unpointed(cols[5])
            atoken = BiblicalHebrew.unpointed(cols[12])
            alemma = BiblicalHebrew.unpointed(cols[14])
           else 
            htoken = cols[3]
            hlemma = cols[5]
            atoken = cols[12]
            alemma = cols[14]
           end
           datatuple = (
            sequence = parse(Int, cols[1]),
            passage = cols[2],
            htoken = htoken,
            hform = cols[4],
            hlemma = hlemma,
            ltoken = cols[6],
            lform = cols[7],
            llemma = cols[8],
            gtoken = cols[9],
            gform = cols[10], 
            glemma = cols[11],
            atoken = atoken,
            aform = cols[13],
            alemma = alemma
            )
            push!(alignments, datatuple)
        end
    end
    alignments
end


"""Read verb alignment data from github.
"""
function readverbaligns(; stripniqqud=true)
    u = "https://github.com/neelsmith/Complutensian.jl/raw/refs/heads/main/data/torah-verbs-numbered.cex"
    tmp = Downloads.download(u)
    alignments = readverbaligns(tmp; stripniqqud=stripniqqud)
    rm(tmp)
    alignments
end


function alignmentcounts(v1, vlist)
    @info("Length of vlist is $(length(vlist))")
end

