return SMODS.Joker {
    key = "777",
    config = { extra = { odds = 7, repetitions = 7 } },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 1,
    atlas = "CasinoJokers",
    pos = { x = 1, y = 1 },
    cost = 6,
    loc_txt = {
        name = "777",
        text = {
            "{C:green}#1# in 7{} chance for a",
            "scored {C:attention}7{} to retrigger",
            "{C:attention}7{} additional times",
        },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { G.GAME and G.GAME.probabilities.normal or 1 }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:get_id() == 7 then
                local roll = pseudorandom('777')
                local chance = G.GAME.probabilities.normal / card.ability.extra.odds
                if roll < chance then
                    return {
                        message = "Jackpot",
                        repetitions = card.ability.extra.repetitions,
                        card = card,
                        sound = 'foil1',
                    }
                end
            end
        end
    end
}


