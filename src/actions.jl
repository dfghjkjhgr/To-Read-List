module Actions
include("util.jl")
import .Util
import TOML
import Random
using Logging
using Crayons
"""

    _books(file::String)

Defines the parsedfile and books variables, to avoid repetitive boilerplate.
"""
macro _books(file)
    return esc(:(parsedfile = TOML.parsefile($file); books = get!(parsedfile, "books", [])))
end
function addbook(book::Dict{String, String}, file::String)
    @_books "list.toml"
    # Add our book to the list
    addedbooks = [(books...), book]
    open(file, "w") do io
        parsedfile["books"] = addedbooks
        @debug "parsedfile: $parsedfile"
        TOML.print(io, parsedfile)
    end
end

function resetlist(file::String)
    parsedfile = TOML.parsefile(file)
    delete!(parsedfile, "books")
    open(file, "w") do io
        TOML.print(io, parsedfile)
    end
end

function random(file::String)
    @_books file
    book = Random.shuffle(books)[1]
    # Create a little summary
    attributes::String = """$(Crayon(italics=true))$(book["title"])$(Crayon(reset=true))\n"""
    for (k, v) in delete!(book, "title")
        attributes = attributes * "$(titlecase(k)): $(v)\n"
    end
    """

$attributes
"""
end
    
function initialwelcome(file::String)
    name = Util.getname()
    open(file, "w") do io
        TOML.print(io, Dict("name" => name))
    end
    "Hello $(name)!"
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
