"""Get string values for lexical IDs of verbs in a passage.
$(SIGNATURES)
"""
function passagelexstrings(u::CtsUrn, v::Vector{AnalyzedToken})
	retrieveparses(u, v) .|> at_lex .|> string |> unique
end


"""Compile a table of verb occurrences by document for each passage of
text.
$(SIGNATURES)
"""
function compileverbtable(repo)
    vulgate = readvulgate()
    vparses = parsevulgate(vulgate)

    targumlatin = readtargumglosses(repo)
    lxxlatin = readseptuagintglosses(repo)

    p23 = parser23()
    tparses = parsetargumglosses(targumlatin; parser = p23)
    sparses = parseseptuagintglosses(lxxlatin; parser = p23)

    lxxverbs = filter(sparses.analyses) do a
        ! isempty(a.analyses) && verbform(a.analyses[1])
    end
    targumverbs = filter(tparses.analyses) do a
        ! isempty(a.analyses) && verbform(a.analyses[1])
    end
    vulgateverbs = filter(vparses.analyses) do a
        ! isempty(a.analyses) && verbform(a.analyses[1])
    end

    reflistraw = map(p -> dropversion(urn(p)), targumlatin.passages) 
    reflist = filter(reflistraw) do u
        ! endswith(passagecomponent(u), "title")
    end

    seq = []
	urns = []
	docs = []
	lexemes = []
	for (i,u) in enumerate(reflist)
		if i % 5 == 0
			@info("Passage $(i)/$(length(reflist))...")
		end
		for lex in passagelexstrings(u, vulgateverbs)
			push!(seq, i)
			push!(urns, u)
			push!(docs,"vulgate")
			push!(lexemes, lex)
		end
		for lex in passagelexstrings(u, targumverbs)
			push!(seq, i)
			push!(urns, u)
			push!(docs,"targum")
			push!(lexemes, lex)
		end
		for lex in passagelexstrings(u, lxxverbs)
			push!(seq, i)
			push!(urns, u)
			push!(docs,"septuagint")
			push!(lexemes, lex)
		end
	end
    Table(sequence = seq, urn = urns, document = docs, lexeme = lexemes)
end