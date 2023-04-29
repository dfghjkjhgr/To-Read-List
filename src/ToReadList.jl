module ToReadList
import TOML
import REPL.TerminalMenus
using Crayons
include("actions.jl")
include("interfaces.jl")
include("util.jl")
import .Actions
import .Interfaces

Interfaces.greet()
choice_menu = TerminalMenus.RadioMenu(
    [
        "Get random book from To Read List",
        "Add book",
        "Remove book",
        "View To Read List",
        "Upgrade book",
        "Get random upgraded book",
        "Demote upgraded book",
        "Reset List",
        "Exit"
    ]
)

optionfunctions = Dict(
    1 => Interfaces.random,
    2 => Interfaces.addbook,
    #3 => Interfaces.remove
    #4 => Interfaces.view
    8 => Interfaces.resetlist,
    9 => x -> exit(0)
)

option = TerminalMenus.request("\n$(Crayon(foreground = :blue))Choose action:$(Crayon(reset=true))", choice_menu)
optionfunctions[option]("list.toml")

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
end
