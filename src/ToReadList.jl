
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

options = Dict(
    1 => Interfaces.random,
    2 => Interfaces.addbook,
    3 => Interfaces.remove,
    4 => Interfaces.view,
    5 => Interfaces.upgrade,
    7 => Interfaces.demote,
    8 => Interfaces.resetlist,
    9 => _ -> "exit"
)
function loop()
    option = TerminalMenus.request("\n$(Crayon(foreground = :blue))Choose action:$(Crayon(reset=true))", choice_menu)
    # After the user has done whatever they need to do,
    # let them finish other business, or exit.
    if options[option]("list.toml") != "exit" loop() end
end
loop()
end
