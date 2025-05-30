JIMBOCASINO = SMODS.current_mod
SMODS.current_mod.optional_features = {
    retrigger_joker = true,  -- for card reader
}

SMODS.Atlas {
    key = "modicon",
    path = "JimboCasinoIcon.png",
    px = 34,
    py = 34,
}

SMODS.Atlas {
    key = "CasinoJokers",
    path = "CasinoJokers.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "Idol",
    path = "Oops.png",
    px = 71,
    py = 95,
}

local subdir_cards = "jokers"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir_cards)
for _, filename in pairs(cards) do
    assert(SMODS.load_file(subdir_cards .. "/" .. filename))()
end
