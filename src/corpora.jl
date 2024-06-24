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