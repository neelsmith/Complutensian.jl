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


"""Read source data for Latin glosses on the Septuagint from a clone of the github repo in basedir.
$(SIGNATURES)
"""
function readseptuagintglosses(basedir)
	septlatinxml = joinpath(basedir, "editions", "septuagint_latin_genesis.xml")
	septlatinxmlcorpus = readcitable(septlatinxml, CtsUrn("urn:cts:compnov:bible.genesis.sept_latin:"), TEIDivAb, FileReader)
	lxxbldr = normalizedbuilder(; versionid = "lxxlatinnormed")
	septlatin = edited(lxxbldr, septlatinxmlcorpus)
end



"""Read source data for Latin glosses on the Targum Onkelos from a clone of the github repo in basedir.
$(SIGNATURES)
"""
function readtargumglosses(basedir)
	targumlatinxml =  joinpath(basedir, "editions", "targum_latin_genesis.xml")
	targbldr = normalizedbuilder(; versionid = "targumlatinnormed")
	targumlatinxmlcorpus = readcitable(targumlatinxml, CtsUrn("urn:cts:compnov:bible.genesis.sept_latin:"), TEIDivAb, FileReader)
	targumlatin = edited(targbldr, targumlatinxmlcorpus)
end


"""Compile a current parser in 25-character Latin orthography.
$(SIGNATURES)
"""
function parser25() 
    p25url = "http://shot.holycross.edu/tabulae/medieval-lat25-current.cex"
    tabulaeStringParser(p25url, UrlReader)
end

"""Compile a current parser in 23-character Latin orthography.
$(SIGNATURES)
"""
function parser23() 
    p23url = "http://shot.holycross.edu/tabulae/medieval-lat23-current.cex"
    tabulaeStringParser(p23url, UrlReader)
end


"""Parse the Latin Vulgate using by default a parser for 25-character Latin orthography.
$(SIGNATURES)
"""
function parsevulgate(c::CitableTextCorpus; parser = parser25())
    tkns = tokenizedcorpus(c, latin25())
    parsecorpus(tkns, parser)
end



"""Parse the Latin glosses on the Targum Onkelos using by default a parser for 23-character Latin orthography.
$(SIGNATURES)
"""
function parsetargumglosses(c::CitableTextCorpus; parser = parser23())
    tkns = tokenizedcorpus(c, latin23())
    parsecorpus(tkns, parser)
end


"""Parse the Latin glosses on the Septuagint using by default a parser for 23-character Latin orthography.
$(SIGNATURES)
"""
function parseseptuagintglosses(c::CitableTextCorpus; parser = parser23())
    tkns = tokenizedcorpus(c, latin23())
    parsecorpus(tkns, parser)
end