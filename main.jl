import TOML
import REPL.TerminalMenus
using Crayons
include("actions.jl")
include("util.jl")

function greet()
    # TODO: Make this function more functional and small. Split it up into multiple functions, maybe
    if !isfile("list.toml")
        print(Actions.initialwelcome("list.toml"))
    else
        print(Actions.welcome("list.toml"))
    end
end        

greet()
choice_menu = TerminalMenus.RadioMenu(
    [
        "Get random book from To Read List",
        "Add book",
        "Remove book",
        "View To Read List",
        "Upgrade book",
        "Get random upgraded book",
        "Demote upgraded book",
        "Reset List"
    ]
)

option = TerminalMenus.request("\n$(Crayon(foreground = :blue))>>> Choose action:$(Crayon(foreground = :white))", choice_menu)


#=print("""\nWhat do you want to do?
Enter: Get Random Book from To Read List
1: Add Book
2: Remove Book
3: View List
4: Upgrade Book to Hall of Fame
5: Get Random Book from the Hall of Fame
6: View Hall of Fame
    """)
=#