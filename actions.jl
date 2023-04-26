module Actions
include("util.jl")
import .Util
import TOML
function addbook(book::String, file::String)
    parsedfile = TOML.parsefile(file)
    try
        books = parsedfile["books"]
    catch
        parsedfile["books"] = []
        global books = parsedfile["books"]
    end
    
    addedbooks = [(books...), book]
    open(file, "w") do io
        parsedfile["books"] = addedbooks
        TOML.print(io, parsedfile)
    end
end
    

function initialwelcome(file::String)
    println("Welcome to your To Read List!")
    name = Util.getname()
    open(file, "w") do io
        TOML.print(io, Dict("name" => name))
    end
    "Hello $(Util.getname())!"
end

function welcome(file::String)
    list = TOML.parsefile("list.toml")
    #= In some sort of special case, where the user or something or other has gotten
    rid of the name entry on the TOML file,
    this will fix things.
    =#
    name = get(list, "name", "User")
    "Welcome to your To Read List, $(name)!"
end
end