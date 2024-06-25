
"""Read contents of a URL into a string
without leaving messy temporary files behind.
$(SIGNATURES)
"""
function readurl(u)
	tmp = Downloads.download(u)
	s = read(tmp, String)
	rm(tmp)
	s
end


"""Load verb data into a Table from URL source.
$(SIGNATURES)
"""
function loadverbdata()
    url = "http://shot.holycross.edu/complutensian/verblexemes-current.csv"
    dataraw = CSV.File(IOBuffer(readurl(url))) |> Table
end


"""Identify by sequence number passages where a given verb occurs.
$(SIGNATURES)
"""
function passagesforverb(vrb, tbl::Table)
	map(filter(r -> r.lexeme == vrb, tbl)) do r
		r.sequence
	end |> unique
end



"""Compile list of verb IDs in data table, skipping *sum* by default.
$(SIGNATURES)
"""
function verblist(tbl::Table; skiplist = [Complutensian.SUM])
    verblistraw = map(r -> r.lexeme, tbl) |> unique
    filter(v -> (v in skiplist) == false, verblistraw)
end

"""Compile a dictionary of counts for verbs keyed by lexeme.
The value for each lexeme is a further dictionary of counts per passage.

By default, omit the verb *sum* from the counts; optionally, supply a (possibly empty) list of verbs to skip.

$(SIGNATURES)
"""
function countsbyverb(tbl::Table; verbs = nothing, skiplist = [Complutensian.SUM])
    verblistraw = isnothing(verbs) ? verblist(tbl) : verbs
	verbstocount = filter(v -> (v in skiplist) == false, verblistraw)

	counts = OrderedDict()
	for verb in verbstocount
		subcounts = OrderedDict()
		psgs = passagesforverb(verb, tbl)
		for psg in psgs
			count = filter(r -> r.sequence == psg && r.lexeme == verb, tbl) |> length
            subcounts[psg] = count
		end
		counts[verb] = subcounts
	end
	counts
end



"""Find the set of unique lexemes in a passage identified by sequence number.
$SIGNATURES
"""
function lexemesforpassage(seq::Int, tbl::Table; skiplist = [Complutensian.SUM])
	rawmatches = map(filter(r -> r.sequence == seq, tbl)) do r
		r.lexeme
	end |> unique
	filter(lex -> (lex in skiplist) == false, rawmatches)
		
end

"""Find occurence records for a passage identified by sequence number.
$(SIGNATURES)
"""
function recordsforpsg(seq::Int, tbl::Table)
    filter(r -> r.sequence == seq, tbl)
end

"""Find CTS URN for a passage identified by sequence number.
$(SIGNATURES)
"""
function urnforpassage(seq::Int, tbl::Table)::Union{CtsUrn, Nothing}
    matches = map(filter(r -> r.sequence == seq, tbl)) do r
        r.urn
    end |> unique
	if isempty(matches)
		@warn("`urnforpassage`: no passage $(seq)")
		nothing
	else
		matches[1] |> CtsUrn
	end
end


"""Get set of documents where verb does not appear in a passage identified by sequence number.
$(SIGNATURES)
"""
function missingforverb(vrb, psg::Int, tbl::Table)
	alldocs = ["targum", "septuagint", "vulgate"]
	present = documentsforverb(vrb, psg, tbl)
	@info("Presnet: $(present)")
	absent = filter(doc -> (doc in present) == false, alldocs)
	absent
end



"""Get set of documents where verb appears in a passage identified by sequence number.
$(SIGNATURES)
"""
function documentsforverb(vrb, psg::Int, tbl::Table)
	map(filter(r -> r.lexeme == vrb && r.sequence == psg, tbl)) do r
		r.document
	end |> unique
end


"""Get set of all documents where a verb appears in a data table.
$(SIGNATURES)
"""
function documentsforverb(vrb, tbl::Table)
	map(filter(r -> r.lexeme == vrb, tbl)) do r
		r.document
	end |> unique
end


"""Get set of documents where verb appears in a passage identified by sequence number.
$(SIGNATURES)
"""
function verbsfordocument(doc, psg::Int, tbl::Table; skiplist = [Complutensian.SUM])
	rawmatches = map(filter(r -> r.document == doc && r.sequence == psg, tbl)) do r
		r.lexeme
	end |> unique
	filter(v -> (v in skiplist) == false, rawmatches)
end