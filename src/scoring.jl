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

"""Count occurrences of other verbs in documents where a verb found in one or two documents does not appear.
$(SIGNATURES)
"""
function cooccurencescores(v, tbl::Table; skiplist = [Complutensian.SUM])
	#docids = ["septuagint", "targum", "vulgate"]
	allalignments = []
	psgs = passagesforverb(v, tbl)
	
	for psg in psgs
        @debug("Psg: $(psg)")
		records = filter(r -> r.sequence == psg, tbl)
		appearsin = documentsforverb(v, psg, tbl)
        @debug("Appears in $(appearsin)")
		missingdocs = filter(r ->  r.sequence == psg && (r.document in appearsin) == false, tbl)
        @debug("Missing docs: $(missingdocs)")
		otherlexx = map(r -> r.lexeme, missingdocs)
		for l in otherlexx
			if l in skiplist
			else
				push!(allalignments, l)
			end
		end
	end
	
	dict = allalignments |> countmap |> OrderedDict
	sort(dict, byvalue=true, rev=true)
	
end
