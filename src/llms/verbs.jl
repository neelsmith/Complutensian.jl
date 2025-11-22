
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

function hebrewforms(alignments)
    map(tpl -> (seq = tpl.sequence, passage = tpl.passage, lemma = tpl.hlemma, token = tpl.htoken), alignments)
end


function latinforms(alignments)
    map(tpl -> (seq = tpl.sequence, passage = tpl.passage, lemma = tpl.llemma, token = tpl.ltoken), alignments)
end


function greekforms(alignments)
    map(tpl -> (seq = tpl.sequence, passage = tpl.passage, lemma = tpl.glemma, token = tpl.gtoken), alignments)
end



function aramaicforms(alignments)
    map(tpl -> (seq = tpl.sequence, passage = tpl.passage, lemma = tpl.alemma, token = tpl.atoken), alignments)
end


# Coarse approximation:
function ingreekrange(s)
    #=
    conclusion = true
    for cp in s
        cpval = codepoint(cp)
        #=@info("Cp is $(cp)")
        @info("Type of cp: $(typeof(cp))")
        @info("As codepoint $(cpval)")
        @info(string(cpval, base=16))=#
        if cpval < 0x391 || cpval > 0x1fa7
            conclusion = false
        end

    end
    conclusion
    =#
    tflist = map(collect(s)) do cp
       cpval = codepoint(cp)
       #=@info("Look at $(cp) $(cpval) $(string(cpval, base=16))")
       @info("Greater than x391? $(cpval >= 0x391 )")
       @info("Less than 0x1fa7? $(cpval >= 0x1fa7 )")
=#
  
       decision = ((cpval >=  913) && (cpval <= 074)) ||
       ((cpval >= 0x1F00) && (cpval <= 0x1ffc))
       #@info("Decision $(decision)")
       decision
    end
    #@info("TF list; $(tflist)")
    false in tflist ? false : true
end

# written by claude
function is_all_greek(s::String)::Bool
    for c in s
        cp = Int(c)
        # Greek and Coptic: U+0370 to U+03FF
        # Greek Extended: U+1F00 to U+1FFF
        if !((0x0370 <= cp <= 0x03FF) || (0x1F00 <= cp <= 0x1FFF))
            return false
        end
    end
    return true
end

function is_all_hebrew(s::String)::Bool
    for c in s
        cp = Int(c)
        # Hebrew: U+0590 to U+05FF
        # Alphabetic Presentation Forms (Hebrew): U+FB1D to U+FB4F
        if !((0x0590 <= cp <= 0x05FF) || (0xFB1D <= cp <= 0xFB4F))
            return false
        end
    end
    return true
end


function inhebrewrange(s)
    conclusion = true
    for cp in s
        cpval = codepoint(cp)
       
        if cpval < 0x5C0 || cpval > 0x5f4
            conclusion = false
        end

    end
    conclusion
end

