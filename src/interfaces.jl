module Interfaces
include("actions.jl")
import .Actions
import Crayons
function greet()
    if !isfile("list.toml")
        print(Actions.initialwelcome("list.toml"))
    else
        print(Actions.welcome("list.toml"))
    end
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

function random(file::String)
    # Look into showing book covers in certain terminal emulators
    println("Choosing book...")
    function loop(answer)
        book = Actions.random(file)
        print("Here is your book:$(book)Satisfied? Do you want another book (y/n)? ")
        answer = readline()
        if answer == "n"
            print("Alright. Now go and read it!")
        elseif answer == "y"
            loop(answer)
        else
            print("Please answer y or n.")
            loop(answer)
        end
    end
    loop("")
end
end
