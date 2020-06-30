# Test for duplicate data in examples, which could be generated
# because of a bug in NONMEM.
using Pumas, CSV

function locate_duplicate(data, fullpath)
    unique_rows = Set()
    for i = 1:size(data, 1)
        row = data[i, :]
        if row in unique_rows
            error("Row $i in $fullpath is a duplicate!")
        else
            push!(unique_rows, row)
        end
    end
end

dir = joinpath(dirname(pathof(Pumas)), "..", "examples")
for (rootpath, dirs, files) in walkdir(dir)
    for file in files
        if lowercase(file[end-2:end]) == "csv"
            fullpath = joinpath(rootpath, file)
            data = Matrix(DataFrame(CSV.File(fullpath)))
            locate_duplicate(data, fullpath)
        end
    end
end
