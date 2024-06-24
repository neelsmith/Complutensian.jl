"""Read source data for Vulgate from github, and load as a CitableTextCorpus.
$(SIGNATURES)
"""
function readvulgate()
	srcurl = "https://raw.githubusercontent.com/neelsmith/compnov/main/corpus/compnov.cex"
	corpus = fromcex(srcurl, CitableTextCorpus, UrlReader)
	vulgate = filter(corpus.passages) do psg
		versionid(psg.urn) == "vulgate"
	end |> CitableTextCorpus
end


function readseptuagint(basedir)
	septlatinxml = joinpath(basedir, "editions", "septuagint_latin_genesis.xml")
	septlatinxmlcorpus = readcitable(septlatinxml, CtsUrn("urn:cts:compnov:bible.genesis.sept_latin:"), TEIDivAb, FileReader)
	lxxbldr = normalizedbuilder(; versionid = "lxxlatinnormed")
	septlatin = edited(lxxbldr, septlatinxmlcorpus)
end


function readtargum(basedir)
	targumlatinxml =  joinpath(basedir, "editions", "targum_latin_genesis.xml")
	targbldr = normalizedbuilder(; versionid = "targumlatinnormed")
	targumlatinxmlcorpus = readcitable(targumlatinxml, CtsUrn("urn:cts:compnov:bible.genesis.sept_latin:"), TEIDivAb, FileReader)
	targumlatin = edited(targbldr, targumlatinxmlcorpus)
end

function parser25() 
    p25url = "http://shot.holycross.edu/tabulae/medieval-lat25-current.cex"
    tabulaeStringParser(p25url, UrlReader)
end


function parser23() 
    p23url = "http://shot.holycross.edu/tabulae/medieval-lat23-current.cex"
    tabulaeStringParser(p23url, UrlReader)
end


function parsevulgate(c::CitableTextCorpus; parser = parser25())
    tkns = tokenizedcorpus(c, latin25())
    parsecorpus(tkns, parser)
end


function parsetargum(c::CitableTextCorpus; parser = parser23())
    tkns = tokenizedcorpus(c, latin23())
    parsecorpus(tkns, parser)
end


function parseseptuagint(c::CitableTextCorpus; parser = parser23())
    tkns = tokenizedcorpus(c, latin23())
    parsecorpus(tkns, parser)
end