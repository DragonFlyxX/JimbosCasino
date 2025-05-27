SMODS.Joker({
    key = "JadeElephant",
    atlas = "CasinoJokers",
    pos = {x = 3, y = 0},
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = { odds = 2 }
    },
    loc_txt = {
        name = "Jade Elephant",
        text = {
            "{C:green}#1# in 2{} chance for a",
            "played {C:attention}8{} to give {C:attention}10%{} of",
            "{C:money}$total{} when scored",
            "{C:inactive}(max of {C:money}$16{}{C:inactive}){}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {G.GAME and G.GAME.probabilities.normal or 1}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 8 then
                local odds = card.ability.extra.odds or 2
                local chance = G.GAME.probabilities.normal / odds
                local roll = pseudorandom('jadeelephant')
                if roll < chance then
                    local total_money = (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)
                    local reward = math.max(math.min(math.floor(total_money * 0.10), 16), 1)
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + reward
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                    return {
                        dollars = reward,
                        card = card,
                    }
                end
            end
        end
    end
})



