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


export readvulgate, parsevulgate
export readtargum, parsetargum
export readseptuagint, parseseptuagint

export verbs

include("corpora.jl")
include("analysis.jl")

end # module Complutensian
