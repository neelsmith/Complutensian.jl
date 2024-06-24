
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


"""Identify by sequence number passages where a given verb occurs."""
function passagesforverb(vrb, tbl::Table)
	map(filter(r -> r.lexeme == vrb, tbl)) do r
		r.sequence
	end |> unique
end