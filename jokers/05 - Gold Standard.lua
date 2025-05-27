SMODS.Joker {
    key = "GoldStandard",
    config = { extra = { x_mult_per_card = 0.4 } },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    atlas = "CasinoJokers",
    pos = { x = 4, y = 1 },
    cost = 7,
    loc_txt = {
        name = "Gold Standard",
        text = {
            'Each played {C:attention}9{} gives an',
            'additional {X:mult,C:white}X0.4{} Mult, for',
            'every {C:attention}Gold{} card held in',
            'hand, when scored',
            '{C:inactive}(Starts at {X:mult,C:white}1X{}{C:inactive} Mult)',
        },
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        return { vars = { card.ability.extra.x_mult_per_card } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local gold_count = 0
            for _, c in ipairs(G.hand and G.hand.cards or {}) do
                if SMODS.has_enhancement(c, 'm_gold') then
                    gold_count = gold_count + 1
                end
            end
            card.ability.extra.total_x_mult = 1 + (gold_count * card.ability.extra.x_mult_per_card)
        end
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            local played_card = context.other_card
            if played_card and played_card:get_id() == 9 and not played_card.debuff then
                return {
                    x_mult = card.ability.extra.total_x_mult or 1,
                    card = card
                }
            end
        end
    end
}



