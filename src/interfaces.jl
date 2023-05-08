module Interfaces
include("actions.jl")
import .Actions
import Crayons
import TOML
function greet()
    if !isfile("list.toml")
        print(Actions.initialwelcome("list.toml"))
    else
        print(Actions.welcome("list.toml"))
    end
end        

"""
    yn(yes::Function, no::Function, prompt::String)

Create a prompt that asks the user for a yes or no answer, and reprompts
them if they don't give one.  
"""
@inline function yn(yes::Function, no::Function, prompt::String="Are you sure?")
    function loop(answer)
        print(prompt)
        x = readline()
        if x == "n"
            no()
        elseif x == "y"
            yes()
        else
            print("Please answer y or n.")
            loop(answer)
        end
    end
    loop("")
end

function addbook(file::String)
    print("What is the title of the book you want to read? Enter in a Goodreads URL for extra functionality. ")
    # TODO: Add Goodreads integration
    title = readline()
    function loop(answer)
        print("Do you want to add any other information (y/n)? ")
        x = readline()
        if x == "n"
            print("Adding book... ")
            Actions.addbook(Dict("title" => title), file)
            print("DONE!")
        elseif x == "y"
            print("Who wrote $(title)? ")
            author = readline()
            print("What is the genre of $(title)? ")
            genre = readline()
            Actions.addbook(Dict("title" => title, "genre" => genre, "author" => author), file)
        else
            print("Please answer y or n.")
            loop(answer)
        end
    end
    loop("")
end

function resetlist(file::String)
    print("Are you sure you want to delete your To Read List? ")
    if readline() == "y" Actions.resetlist(file); print("Deleted.") else print("Aborted reset.") end
end

"Get a random book from a TOML file (our to read list)"
function random(file::String)
    # Look into showing book covers in certain terminal emulators
    println("Choosing book...")
    book = ""
    try
        book = Actions.random(file)
    catch BoundsError
        print("There are no books to choose from!")
        return
    end
    print("Here is your book:\n$(book)")
end

function remove(file::String)
    print("What book do you want to remove? ")
    book = readline()
    function loop()
        print("Are you sure (y/n)? ")
        answer = readline()
        if answer == "y"
            try
                Actions.remove(file, book)
            catch BoundsError
                print("There is no such book with that title!")
            end
        elseif answer == "n"
            print("Aborted deletion.")
        else
            print("Please answer yes or no.")
            loop()
        end
    end
    loop()
end

function view(file::String)
    if get(TOML.parsefile("list.toml"), "books", []) == []
        print("There are no books to view!")
    else
        println("Here are all of your books:")
        print(Actions.view(file))
    end
end

function hview(file::String)
    if get(TOML.parsefile("list.toml"), "hbooks", []) == []
        print("You have no books in the Hall of Fame!")
    else
        println("Here are all of your Hall of Fame books:")
        print(Actions.hview(file))
    end
end

function upgrade(file::String)
    print("Which book do you want to upgrade?")
    title = readline()
    Actions.upgrade(title, file)
    print("Alright, upgraded $(title)!")
end

function demote(file::String)
    print("Which book do you want to demote?")
    title = readline()
    yn(() -> print("Aborted demote")) do
        println("Demoting book...")
        Actions.demote(title, file)
        println("Demoted.")
    end
end
end

    
