SMODS.Joker {
    key = "SnakeEyes",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    cost = 7,
    atlas = "CasinoJokers",
    pos = { x = 4, y = 2 },
    config = {
        extra = {
            earn_amt = 2,
            scaling = 2
        }
    },
    loc_txt = {
        name = "Snake Eyes",
        text = {
            "Played {C:attention}Aces{} give {C:money}$#1#{} when",
            "scored. Payout increases by",
            "{C:money}$#2#{} if {C:attention}first hand{} of round",
            "only has {C:attention}2{} Aces.",
            "{s:0.9,C:inactive}(Resets at end of ante)",
        },
    },
    loc_vars = function(self, info_queue, card)
        local extra = card and card.ability and card.ability.extra or {}
        return {
            vars = {
                string.format("%.0f", extra.earn_amt or 2),
                string.format("%.0f", extra.scaling or 2),
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.main_eval then
            if G.GAME.blind.boss then
                card.ability.extra.earn_amt = 2
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end
        if context.first_hand_drawn and card.area == G.jokers then
            juice_card_until(card, function()
                return G.GAME.current_round.hands_played == 0
            end, true)
        end
        local extra = card.ability.extra or {}
        extra.earn_amt = extra.earn_amt or 2
        extra.scaling = extra.scaling or 2
        if context.individual and context.cardarea == G.play then
            local scored_card = context.other_card
            if scored_card and scored_card:get_id() == 14 then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + extra.earn_amt
                return {
                    dollars = extra.earn_amt,
                    card = card,
                    juice_card = card
                }
            end
        end
        if context.joker_main and G.GAME.current_round and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            local played = G.play and G.play.cards or {}
            if #played == 2 then
                local is_double_aces = true
                for _, c in ipairs(played) do
                    if not c or c:get_id() ~= 14 then
                        is_double_aces = false
                        break
                    end
                end
                if is_double_aces then
                    extra.earn_amt = extra.earn_amt + extra.scaling
                    card.ability.extra.earn_amt = extra.earn_amt
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MONEY
                    })
                end
            end
        end
    end
}

