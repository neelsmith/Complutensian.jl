### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 1bec9264-ec59-448d-835d-7d50459917fe
begin
	using Pkg
	Pkg.develop(path="..")
	using Revise, Complutensian, Complutensian.Verbs
end

# ╔═╡ ab19567d-5ea9-4fd1-a8ac-d884d7b5aed6
md"""*Unhide the following cell to see the Julia environment.*"""

# ╔═╡ f9628050-c791-11f0-9649-41c62b920373
md"""# Aligning verbs in the Complutensian Bible"""

# ╔═╡ 39b00ae3-d9e1-4d8c-a28e-d8249a67dfed
f = joinpath(pwd() |> dirname, "data", "torah-verbs-numbered.cex")

# ╔═╡ 50205821-17ce-482a-b5da-3cc370b6363f
aligns = Complutensian.Verbs.readverbaligns(f; stripniqqud=true)


# ╔═╡ Cell order:
# ╟─ab19567d-5ea9-4fd1-a8ac-d884d7b5aed6
# ╠═1bec9264-ec59-448d-835d-7d50459917fe
# ╟─f9628050-c791-11f0-9649-41c62b920373
# ╠═39b00ae3-d9e1-4d8c-a28e-d8249a67dfed
# ╠═50205821-17ce-482a-b5da-3cc370b6363f
