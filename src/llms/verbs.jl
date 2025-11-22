
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
            ltoken = Unicode.normalize(cols[6]; stripmark=true),
            lform = cols[7],
            llemma = Unicode.normalize(cols[8]; stripmark = true),
            gtoken = Unicode.normalize(cols[9],:NFKC),
            gform = cols[10], 
            glemma = Unicode.normalize(cols[11],:NFKC),
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


"""Count frequencies of stuff."""
function alignmentcounts(alignments; includedlangs = [])
    #@info("Look for freqs in $(includedlangs)")
    stringlists = map(alignments) do tpl
        if isempty(includedlangs)
            # include all
            join(tpl, ", ")
        else
            itemlist = []
            if "Hebrew" in includedlangs
                push!(itemlist, tpl.hlemma)
            end
            if "Greek" in includedlangs
                push!(itemlist, tpl.glemma)
            end
            if "Latin" in includedlangs
                push!(itemlist, tpl.llemma)    
            end
            if "Aramaic" in includedlangs
                push!(itemlist, tpl.alemma)                    
            end
            join(itemlist, ", ")
        end
    end
    results = countmap(stringlists) |> OrderedDict
    sort!(results; byvalue = true, rev = true)
end




function lemmaquads(alignments)
    map(tpl -> (hlemma = tpl.hlemma, llemma = tpl.llemma, glemma = tpl.glemma, alemma = tpl.alemma), alignments)
end



function cflatinlemma(lemma, alignments; includedlangs = [])
    matchingquads = filter(tpl -> tpl.llemma == lemma, alignments)
    alignmentcounts(matchingquads; includedlangs = includedlangs)
end

function cfgreeklemma(lemma, alignments; includedlangs = [])
    matchingquads = filter(tpl -> tpl.glemma == lemma, alignments)
    alignmentcounts(matchingquads; includedlangs = includedlangs)
end



function cfhebrewlemma(lemma, alignments; includedlangs = [])
    matchingquads = filter(tpl -> tpl.hlemma == lemma, alignments)
    alignmentcounts(matchingquads; includedlangs = includedlangs)
end

function cfaramaiclemma(lemma, alignments; includedlangs = [])
    matchingquads = filter(tpl -> tpl.alemma == lemma, alignments)
    alignmentcounts(matchingquads; includedlangs = includedlangs)
end