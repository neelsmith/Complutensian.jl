### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 1bec9264-ec59-448d-835d-7d50459917fe
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.develop(path="..")
	using Revise, Complutensian, Complutensian.Verbs

	Pkg.add("PlutoUI")
	Pkg.add("PlutoPlotly")
	using PlutoPlotly, PlutoUI

	Pkg.add("StatsBase")
	Pkg.add("OrderedCollections")
	using StatsBase, OrderedCollections

	md"""*Unhide this cell to see the Julia environment.*"""
end

# ╔═╡ 3c14d363-6a71-43cb-bbb7-8368c901ae11
TableOfContents()

# ╔═╡ f9628050-c791-11f0-9649-41c62b920373
md"""# Aligning verbs in the Complutensian Bible"""

# ╔═╡ 2108e0e1-c2d1-4f89-83e9-7edfd3c0d6e2
md"""## Overview: frequency of co-occuring values across all 4 versions"""

# ╔═╡ cc7f5644-ffb8-497d-bb59-8f2ca17c7e1b
 md"""*Number to display*: $(@bind maxdisplay Slider(50 : 10 : 500; default=100, show_value=true))"""

# ╔═╡ f754426f-c969-44cd-a943-777235538e43
md"""## Comparisons"""

# ╔═╡ fb42bc2e-e6cd-47ab-946e-1ebdc0463382
md"""Base language: $(@bind baselang Select(["Hebrew", "Latin", "Greek", "Aramaic"]))"""

# ╔═╡ fc40eef4-4760-446c-bd84-ad52a044b281
html"""
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ 10f3876e-1df8-41ad-8611-79d88c21a5d7
md"""> # Implementations"""

# ╔═╡ 2c9ec35b-76e1-4422-abcd-ae33c078f8c7
md"""> ## User selected comparisons"""

# ╔═╡ 6dbd2b37-7806-43e4-ae7e-ed7904971200
"""Compose list of languages to compare with user-chosen language."""
function comparisonlangs(omitlang)
	filter(["Hebrew", "Latin", "Greek", "Aramaic"]) do lang
		lang != omitlang
	end
end

# ╔═╡ c052def0-6fd9-4cd8-bb24-219ea174a424
md"""Compare to: $(@bind complist MultiCheckBox(comparisonlangs(baselang)))"""

# ╔═╡ 765d90b1-34d2-4fba-8876-38e41adfc0f1
"""Construct list of vocabulary for selected language, ordered by frequency."""
function vocabforlang(lang, alignmentdata)
	if lang == "Hebrew"
		hlemms = map(tpl -> tpl.hlemma, alignmentdata) |> countmap |> OrderedDict
		sort!(hlemms; byvalue=true, rev=true)	|> keys |> collect
	elseif lang == "Greek"
		glemms = map(tpl -> tpl.glemma, alignmentdata) |> countmap |> OrderedDict
		sort!(glemms; byvalue=true, rev=true)	|> keys |> collect
	elseif lang == "Latin"
		llemms = map(tpl -> tpl.llemma, alignmentdata) |> countmap |> OrderedDict
		sort!(llemms; byvalue=true, rev=true)	|> keys |> collect
	else
		[]
	end
	
end

# ╔═╡ 7575cbdd-a2bd-44e8-8fca-cbae1460d46a
md"""> ## Load and count overall data"""

# ╔═╡ 39b00ae3-d9e1-4d8c-a28e-d8249a67dfed
f = joinpath(pwd() |> dirname, "data", "torah-verbs-numbered.cex")

# ╔═╡ 50205821-17ce-482a-b5da-3cc370b6363f
aligns = Complutensian.Verbs.readverbaligns(f; stripniqqud=true)


# ╔═╡ f856159c-23f9-4428-84d0-8f54399adb8f
vocab = vocabforlang(baselang, aligns)

# ╔═╡ 6ecdf1c0-4a27-4982-a90c-55261f7dbdeb
md"""Vocab  item: $(@bind vocabitem Select(vocab))"""

# ╔═╡ ac9e7549-a315-408d-bae5-cb862d445761
if isempty(vocabitem)
	md"""*Select a vocabulary item.*"""
else
	md"""### Co-occurrences with $(vocabitem) in $(join(complist,", "))"""
end

# ╔═╡ 0798597a-2974-4dc1-ac35-2643785e0a05
lemmata = map(tpl -> (hlemma = tpl.hlemma, llemma = tpl.llemma, glemma=tpl.glemma, alemma=tpl.alemma ), aligns)

# ╔═╡ 0fc90af3-c3e4-4dc3-b0bf-69ccf3471bf9
uservocabcounts = if baselang == "Hebrew"
	Complutensian.Verbs.cfhebrewlemma(vocabitem, lemmata; includedlangs = complist)
elseif baselang == "Latin"
	Complutensian.Verbs.cflatinlemma(vocabitem, lemmata; includedlangs = complist)
elseif baselang == "Greek"
	Complutensian.Verbs.cfgreeklemma(vocabitem, lemmata; includedlangs = complist)
elseif baselang == "Aramaic"
	Complutensian.Verbs.cfaramaiclemma(vocabitem, lemmata; includedlangs = complist)	
	
end

# ╔═╡ 59b9beac-bd2c-4c23-ab2d-b62d6e304ff6
choiceys = collect(values(uservocabcounts))

# ╔═╡ 4ec435cc-fba0-4a24-aabf-10316b9ef4c1
choicexs = collect(keys(uservocabcounts))

# ╔═╡ ddcf2fd5-bd6a-49b8-a9e2-5f3583afa9e9
plot(
		bar(x = choicexs, y = choiceys)
	)

# ╔═╡ 71957bfa-46c8-423c-95f1-2fe697e21ccd
quadcountsraw = countmap(lemmata) |> OrderedDict

# ╔═╡ a5dbc617-02d8-4c55-bb22-e6435220f4ac
quadcounts = sort(quadcountsraw; rev=true,byvalue=true)

# ╔═╡ 0c510643-66be-41a3-8d8e-1a93710ea940
xs = map(v -> join(v, ", "), collect(keys(quadcounts)))

# ╔═╡ 8242d54d-ccf5-4c25-b412-bdd736049ca9
ys = collect(values(quadcounts))

# ╔═╡ 27d2f82d-f234-4cf0-8cf0-0d11d800ed4b
plot(
		bar(x = xs[1:maxdisplay], y = ys[1:maxdisplay])
	)

# ╔═╡ Cell order:
# ╟─1bec9264-ec59-448d-835d-7d50459917fe
# ╟─3c14d363-6a71-43cb-bbb7-8368c901ae11
# ╟─f9628050-c791-11f0-9649-41c62b920373
# ╟─2108e0e1-c2d1-4f89-83e9-7edfd3c0d6e2
# ╟─cc7f5644-ffb8-497d-bb59-8f2ca17c7e1b
# ╟─27d2f82d-f234-4cf0-8cf0-0d11d800ed4b
# ╟─f754426f-c969-44cd-a943-777235538e43
# ╟─fb42bc2e-e6cd-47ab-946e-1ebdc0463382
# ╟─6ecdf1c0-4a27-4982-a90c-55261f7dbdeb
# ╟─c052def0-6fd9-4cd8-bb24-219ea174a424
# ╟─ac9e7549-a315-408d-bae5-cb862d445761
# ╟─ddcf2fd5-bd6a-49b8-a9e2-5f3583afa9e9
# ╟─fc40eef4-4760-446c-bd84-ad52a044b281
# ╟─10f3876e-1df8-41ad-8611-79d88c21a5d7
# ╟─2c9ec35b-76e1-4422-abcd-ae33c078f8c7
# ╟─59b9beac-bd2c-4c23-ab2d-b62d6e304ff6
# ╟─4ec435cc-fba0-4a24-aabf-10316b9ef4c1
# ╟─0fc90af3-c3e4-4dc3-b0bf-69ccf3471bf9
# ╟─6dbd2b37-7806-43e4-ae7e-ed7904971200
# ╟─765d90b1-34d2-4fba-8876-38e41adfc0f1
# ╟─f856159c-23f9-4428-84d0-8f54399adb8f
# ╟─7575cbdd-a2bd-44e8-8fca-cbae1460d46a
# ╟─39b00ae3-d9e1-4d8c-a28e-d8249a67dfed
# ╟─50205821-17ce-482a-b5da-3cc370b6363f
# ╟─0798597a-2974-4dc1-ac35-2643785e0a05
# ╟─71957bfa-46c8-423c-95f1-2fe697e21ccd
# ╟─a5dbc617-02d8-4c55-bb22-e6435220f4ac
# ╟─0c510643-66be-41a3-8d8e-1a93710ea940
# ╟─8242d54d-ccf5-4c25-b412-bdd736049ca9
