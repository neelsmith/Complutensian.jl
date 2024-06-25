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

export parser23, parser25

export verbs

export loadlabels, labellex


export loadverbdata, passages, documentsforpassage
export misaligned
export recordsforpsg, urnforpassage
export documentsforverb, missingforverb, verbsfordocument
export passagesforverb, verblist 
export countsbyverb
export lexemesforpassage
export slashline,cooccurrencescores
export align, alignverb

export verbform


include("constants.jl")
include("labels.jl")
include("corpora.jl")
include("analysis.jl")
include("verbs.jl")
include("scoring.jl")
include("datacompiler.jl")

end # module Complutensian
