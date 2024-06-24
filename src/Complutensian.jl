module Complutensian

using CitableBase, CitableText, CitableCorpus
using Tabulae
using CitableParserBuilder
using Orthography, LatinOrthography
using CitableTeiReaders
using EditionBuilders
using StatsBase, OrderedCollections

using TypedTables
using CSV


export readvulgate
export readtargum
export readseptuagint

include("corpora.jl")

end # module Complutensian
