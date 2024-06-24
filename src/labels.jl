
"""Load a Dict of labelling strings for verb IDs
from a URL source.
$(SIGNATURES)
"""
function loadlabels()
    lblurl = "http://shot.holycross.edu/complutensian/labels.cex"
	tmplbls = Downloads.download(lblurl)
	lns = readlines(tmplbls)
	rm(tmplbls)
	dict = Dict()
	for ln in lns
		parts = split(ln, "|")
		dict[parts[1]] = string(parts[1], " (", parts[2], ")")
	end
	dict
end

"""Compose a labelling string for a verb lexeme.
$(SIGNATURES)
"""
function labelverb(v; labelsdict = nothing)
    dict = isnothing(labelsdict) ? loadlabels() : labelsdict
	if haskey(dict, v)
		dict[v]
	else
		string(v, " (?)")
	end
end