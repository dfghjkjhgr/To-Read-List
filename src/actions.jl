module Actions
include("util.jl")
import .Util
import TOML
import Random
using Logging
using Crayons
"""

    _books(file::String)

Defines the parsedfile and books variables in a function, to avoid repetitive boilerplate.
"""
macro _books(file)
    return esc(:(parsedfile = TOML.parsefile($file); books = get!(parsedfile, "books", [])))
end

"""

    _hbooks(file::String)

Similar to _books, but defines an hbooks variable, for books in the Hall of Fame
"""
macro _hbooks(file)
    return esc(:(parsedfile = TOML.parsefile($file); hbooks = get!(parsedfile, "hbooks", [])))
end
"Add a book to the list"
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

"Erase all books from the list"
function resetlist(file::String)
    parsedfile = TOML.parsefile(file)
    delete!(parsedfile, "books")
    open(file, "w") do io
        TOML.print(io, parsedfile)
    end
end


"Get the index of a book from it's title"
function _findbook(title, list)
    function loop(title, list, index)
        if list[index]["title"] == title
            index
        else
            loop(title, list, index + 1)
        end
    end
    loop(title, list, 1)
end

"Removes a book from a To Read List file"
function remove(file::String, book::String)
    @_books file
    open(file, "w") do io
        deleteat!(parsedfile["books"], _findbook(book, parsedfile["books"]))
        TOML.print(io, parsedfile)
    end
end

function view(file::String)
    parsedfile = TOML.parsefile(file)
    booktitles = map(x -> x["title"], parsedfile["books"])
    @debug booktitles
    function loop(text, booktitles, position::Int)
        if position >= length(booktitles)
            text
        else
            # Move along in the booktitles list
            @debug text * booktitles[position]
            loop(text * "$(booktitles[position])\n", booktitles, position + 1)
        end
    end
    loop("$(booktitles[1])\n", booktitles, 2)
end

function hview(file::String)
    parsedfile = TOML.parsefile(file)
    booktitles = map(x -> x["title"], parsedfile["hbooks"])
    @debug booktitles
    function loop(text, booktitles, position::Int)
        if position >= length(booktitles)
            text
        else
            # Move along in the booktitles list
            @debug text * booktitles[position]
            loop(text * "$(booktitles[position])\n", booktitles, position + 1)
        end
    end
    # If there is only one element in booktitles,
    # this will prevent the function from returning an empty list
    loop("$(booktitles[1])\n", booktitles, 2)
end
                 
function upgrade(title::String, file::String)
    @_hbooks "list.toml"
    # Save book, since it is going to be removed
    books::Vector{Dict{String, String}} = parsedfile["books"]
    book = books[_findbook(title, books)]
    deleteat!(parsedfile["books"], _findbook(title, parsedfile["books"]))
    # Add our book to the list
    addedbooks = [(hbooks...), book]
    open(file, "w") do io
        parsedfile["hbooks"] = addedbooks
        @debug "parsedfile: $parsedfile"
        TOML.print(io, parsedfile)
    end
end

function demote(title::String, file::String)
    @_hbooks "list.toml"
    # Save our book
    book = hbooks[_findbook(title, hbooks)]
    # Delete it from the hall of fame list
    deleteat!(hbooks, _findbook(title, parsedfile["hbooks"]))
    open(file, "w") do io
        parsedfile["books"] = [parsedfile["books"]..., book]
        @debug "parsedfile: $parsedfile"
        TOML.print(io, parsedfile)
    end
end

function random(file::String)
    @_books file
    book = Random.shuffle(books)[1]
    # Create a little summary
    attributes::String = """$(Crayon(italics=true))$(book["title"])$(Crayon(reset=true))\n"""
    # Since the title is already in the arguments list
    for (k, v) in delete!(book, "title")
        attributes = attributes * "$(titlecase(k)): $(v)\n"
    end
    "$attributes"
end

function hrandom(file::String)
    @_hbooks file
    book = Random.shuffle(hbooks)[1]
    # Create a little summary
    attributes::String = """$(Crayon(italics=true))$(book["title"])$(Crayon(reset=true))\n"""
    # Since the title is already in the arguments list
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
