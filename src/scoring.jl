"""Compute numbers of triples, doubles, singeltons and totals for a verb.
$(SIGNATURES)
"""
function slashline(vrb, tbl::Table; vcounts = nothing)
    counts = isnothing(vcounts) ? countsbyverb(tbl) : vcounts
	occrncs =  passagesforverb(vrb, tbl)
	psgcounts = counts[vrb]
	triples = filter(occrncs) do seq
		psgcounts[seq] == 3
	end
	doubles = filter(occrncs) do seq
		psgcounts[seq] == 2
	end
	singles = filter(occrncs) do seq
		psgcounts[seq] == 1
	end
	(verb = vrb, threes = length(triples), twos = length(doubles), ones = length(singles), total = length(occrncs))
end