function count_enhancement(name)
    local count = 0
    for _, card in ipairs(G.playing_cards or {}) do
        if SMODS.has_enhancement(card, name) then
            count = count + 1
        end
    end
    return count
end
SMODS.Joker {
    key = "MoltenGold",
    config = { extra = { x_mult = 3, cards_to_destroy = {} } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        return { vars = { card.ability.extra.x_mult } }
    end,
    in_pool = function(self, args)
        return count_enhancement('m_gold') > 0
    end,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 3,
    atlas = "CasinoJokers",
    pos = { x = 0, y = 2 },
    cost = 8,
    self_ability = { extra = 1 },
    loc_txt = {
        name = "Molten Gold",
        text = {
            "{C:attention}Gold{} cards give {X:mult,C:white}X3{}",
            "Mult when scored, but",
            "are {C:attention}destroyed{} after",
            "being {C:attention}played{}",
        },
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if context.other_card and SMODS.has_enhancement(context.other_card, 'm_gold') and not context.other_card.debuff then
                return {
                    x_mult = card.ability.extra.x_mult,
                    card = card,
                }
            end
        end
        if context.before then
            card.ability.extra.cards_to_destroy = {}
            for _, c in ipairs(context.full_hand or {}) do
                if SMODS.has_enhancement(c, 'm_gold') and not c.debuff then
                    table.insert(card.ability.extra.cards_to_destroy, c)
                end
            end
        end
        if context.destroying_card and not context.blueprint then
            for i, c in ipairs(card.ability.extra.cards_to_destroy or {}) do
                if c == context.destroying_card then
                    return {
                        extra = {
                            message = "Melted!",
                            colour = G.C.MULT,
                            juice_card = c,
                        },
                        remove = true,
                    }
                end
            end
        end
    end
}

