
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
function verblist(tbl::Table; skiplist = ["ls.n46529"])
    verblistraw = map(r -> r.lexeme, tbl) |> unique
    filter(v -> (v in skiplist) == false, verblistraw)
end

"""Compile a dictionary of counts for verbs keyed by lexeme.
The value for each lexeme is a further dictionary of counts per passage.
$(SIGNATURES)
"""
function countsbyverb(tbl::Table; verbs = nothing)
    countableverbs = isnothing(verbs) ? verblist(tbl) : verbs
	counts = OrderedDict()
	for verb in countableverbs
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
function lexemesforpsg(seq::Int, tbl::Table)
	map(filter(r -> r.sequence == seq, tbl)) do r
		r.lexeme
	end |> unique
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
function urnforpsg(seq::Int, tbl::Table)::Union{CtsUrn, Nothing}
    matches = map(filter(r -> r.sequence == seq, tbl)) do r
        r.urn
    end |> unique
	if isempty(matches)
		@warn("`urnforpsg`: no passage $(seq)")
		nothing
	else
		matches[1] |> CtsUrn
	end
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
