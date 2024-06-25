using Complutensian
verbdata = loadverbdata()
allverbs = verblist(verbdata)
labels = loadlabels()
labellex(allverbs[1]; labelsdict = labels)
creo = "ls.n11543"
creopassages = passagesforverb(creo, verbdata)
urnforpassage(creopassages[2], verbdata)



verbcountsbylexeme = countsbyverb(verbdata)
verbcountsbylexeme[creo]

documentsforverb(creo, 1, verbdata)
missingforverb(creo, 1, verbdata)

slashline(creo, verbdata)

creoscores = cooccurrencescores(creo, verbdata)

lexids = collect(keys(creoscores))
labellex.(lexids[1:2]; labelsdict = labels)