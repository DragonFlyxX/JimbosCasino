-- Save the old ease_dollars
local ed = ease_dollars
function ease_dollars(mod, x)
    ed(mod, x)
    for i = 1, #G.jokers.cards do
        local effects = G.jokers.cards[i]:calculate_joker({ ROE_ease_dollars = to_big(mod) })
    end
end
SMODS.Joker{
    key = "root_of_all_evil",
    atlas = "CasinoJokers",
    config = {
        extra = {
            scaling = 0.05,
            x_mult = 0        
        }
    },
    loc_txt = {
        name = "Root Of All Evil",
        text = {
            "Played {C:attention}Lucky{}, and",
            "{C:attention}Gold{} cards give {X:mult,C:white}X#1#{}",
            "Mult when scored",
            "{s:0.8}Gains {X:mult,C:white,s:0.8}X0.05{} {s:0.8}Mult when money is earned"
        }
    },
    pos = {x = 0, y = 1},
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        return { vars = { string.format("%.2f", card.ability.extra.x_mult or 0) } }
    end,
    calculate = function(self, card, context)
        if context.ROE_ease_dollars and not context.blueprint then
            if context.ROE_ease_dollars > to_big(0) then
                card.ability.extra = card.ability.extra or {}
                card.ability.extra.scaling = card.ability.extra.scaling or 0.05
                card.ability.extra.x_mult = (card.ability.extra.x_mult or 0) + card.ability.extra.scaling

                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MONEY,
                    card = card
                })
            end
        end
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if context.other_card and not context.other_card.debuff then
                if SMODS.has_enhancement(context.other_card, 'm_gold') or
                   SMODS.has_enhancement(context.other_card, 'm_lucky') then
                    return {
                        x_mult = card.ability.extra.x_mult,
                        card = card,
                    }
                end
            end
        end
    end
}



















