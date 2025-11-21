
"""Read verb alignment data from a file.
"""
function readverbaligns(f)
    alignments = []
    # Skip header line:
    for ln in readlines(f)[2:end]
        cols = split(ln, "|")
        if length(cols) < 14
            @error("Line is too short. Only $(length(cols)) columns in $(ln).")
        else
           datatuple = (
            sequence = parse(Int, cols[1]),
            passage = cols[2],
            htoken = cols[3],
            hform = cols[4],
            hlemma = cols[5],
            ltoken = cols[6],
            lform = cols[7],
            llemma = cols[8],
            gtoken = cols[9],
            gform = cols[10], 
            glemma = cols[11],
            atoken = cols[12],
            aform = cols[13],
            alemma = cols[14]
            )
            push!(alignments, datatuple)
        end
    end
    alignments
end


function alignmentcounts(v1::Vector, vlist::Vector[Vector])
    @info("Length of vlist is $(lengthvlist)")
end

