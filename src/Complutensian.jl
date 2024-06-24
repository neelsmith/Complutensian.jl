module Complutensian
using Downloads
using CitableBase, CitableText, CitableCorpus
using Tabulae
using CitableParserBuilder
using Orthography, LatinOrthography
using CitableTeiReaders
using EditionBuilders
using StatsBase, OrderedCollections

using TypedTables
using CSV

using Documenter, DocStringExtensions

export readvulgate, parsevulgate
export readtargumglosses, parsetargumglosses
export readseptuagintglosses, parseseptuagintglosses

export verbs

export loadlabels, labelverb


export loadverbdata
export passagesforverb, verblist, countsbyverb
export lexemesforpsg

include("labels.jl")
include("corpora.jl")
include("analysis.jl")
include("verbs.jl")


end # module Complutensian
