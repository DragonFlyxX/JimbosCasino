SMODS.Joker {
    key = "GoldIdol",
    config = { extra = { base_x_mult = 1.0 } }, 
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 3,
    atlas = "Idol",
    pos = { x = 0, y = 0 },
    cost = 8,

    loc_txt = {
        name = "Gold Idol",
        text = {
            'Each {C:attention}Gold{} card held',
            'in hand gives {X:mult,C:white}X#1#{} Mult.',
            'Gains {X:mult,C:white}X0.1{} Mult when a',
            '{C:attention}Gold{} card is destroyed',
        },
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        return { vars = { card.ability.extra.base_x_mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card and SMODS.has_enhancement(context.other_card, 'm_gold') and not context.other_card.debuff then
                return {
                    x_mult = card.ability.extra.base_x_mult
                }
            end
        end
        if context.remove_playing_cards and not context.blueprint then
            local destroyed_gold = 0
            for _, removed_card in ipairs(context.removed or {}) do
                if SMODS.has_enhancement(removed_card, 'm_gold') then
                    destroyed_gold = destroyed_gold + 1
                end
            end
            if destroyed_gold > 0 then
                card.ability.extra.base_x_mult = card.ability.extra.base_x_mult + (destroyed_gold * 0.1)
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.base_x_mult } }
                }
            end
        end
    end,
}






