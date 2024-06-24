
"""True if analysis has a verb form.
$(SIGNATURES)
"""
function verbform(a::Analysis)
	latform = latinForm(a)
	latform isa LMFFiniteVerb ||
	latform isa LMFInfinitive ||
	latform isa LMFParticiple 
end


"""Extract analyzed tokens for all verb forms in a collection of analzed tokens.
$(SIGNATURES)
"""
function verbs(atc::AnalyzedTokenCollection)
    filter(atc.analyses) do a
	    ! isempty(a.analyses) && verbform(a.analyses[1])
    end
end



"""Get lexeme URN for first analysis for an analyzed token.
$(SIGNATURES)
"""
function at_lex(a::AnalyzedToken)
	a.analyses[1] |> lexemeurn
end

"""Get string values for lexical IDs of verbs in a passage.
$(SIGNATURES)
"""
function passagelexstrings(u::CtsUrn, v::Vector{AnalyzedToken})
	retrieveparses(u,v) .|> at_lex .|> string |> unique
end


"""Retrieve parses from corpus for a given passage reference.
$(SIGNATURES)
"""
function retrieveparses(u::CtsUrn, v::Vector{AnalyzedToken})
	
	if isrange(u)
		"Not handling rnges yet."
	else
		psgref = passagecomponent(u)
		dotted = psgref * "."
		filter(v) do atkn
			psg = atkn |> passage
			checkref = passagecomponent(urn(psg)) 
			groupid(urn(psg)) == groupid(u) &&
			workid(urn(psg)) == workid(u) &&
			(psgref == checkref || startswith(checkref, dotted) )
		end
	end
end