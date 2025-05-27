SMODS.Joker {
    key = "Panasco",
    config = {
        extra = {
            earn_amt = 4,
            money_scaling = 4,
            requirement_scaling = 100,
            earned = 0
        }
    },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 4,
    atlas = "CasinoJokers",
    pos = { x = 2, y = 2 },
    soul_pos = { x = 1, y = 2 },
    cost = 20,
    loc_txt = {
        name = "Panasco",
        text = {
            "Played {C:attention}Jacks{} give {C:money}$#1#{} when",
            "scored. Payout increases by",
            "{C:money}$#2#{} after Panasco grants {C:money}$#3#{}",
            "{C:inactive}(Currently earned {C:money}$#4#{C:inactive}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        local extra = card and card.ability and card.ability.extra or {}
        return {
            vars = {
                extra.earn_amt or 4,
                extra.money_scaling or 4,
                extra.requirement_scaling or 100,
                extra.earned or 0,
            }
        }
    end,
    calculate = function(self, card, context)
        if not card.ability or not card.ability.extra then return end
        if context.individual and context.cardarea == G.play then
            local other = context.other_card
            if other and other:get_id() == 11 then
                local earn_amt = card.ability.extra.earn_amt or 4
                local requirement = card.ability.extra.requirement_scaling or 100
                local earned = card.ability.extra.earned or 0
                local scaling = card.ability.extra.money_scaling or 4
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + earn_amt
                earned = earned + earn_amt
                if earned >= requirement then
                    card.ability.extra.earn_amt = earn_amt + scaling
                    card.ability.extra.requirement_scaling = requirement + 100
                    earned = 0
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "Payout increased!",
                        colour = G.C.MONEY
                    })
                end
                card.ability.extra.earned = earned
                return {
                    dollars = earn_amt,
                    card = card,
                }
            end
        end
    end
}
