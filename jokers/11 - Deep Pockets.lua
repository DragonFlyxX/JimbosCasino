SMODS.Joker {
    key = "DeepPocket",
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 3,
    atlas = "CasinoJokers",
    pos = { x = 3, y = 1 },
    cost = 8,
    config = { extra = { slots = 2, threshold = 100 } }, 
    loc_txt = {
        name = "Deep Pockets",
        text = {
            '{C:attention}+#1#{} Joker slots if',
            'you have over {C:money}$#2#{}',
        },
    },
    loc_vars = function(self, info_queue, card)
        local extra = card.ability.extra or {}
        return { vars = { extra.slots or 2, extra.threshold or 100 } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card._deep_pockets_applied = false
        if card.shop_edition or card.shop_cost then return end  -- Ignore shop previews
        if G.GAME.dollars > card.ability.extra.threshold then
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
            card._deep_pockets_applied = true
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card._deep_pockets_applied then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
            card._deep_pockets_applied = false
        end
    end,
    update = function(self, card)
    if not card.ability or not card.ability.extra then return end
    if not G.jokers or not G.jokers.cards then return end
    local owned = false
    for _, c in ipairs(G.jokers.cards) do
        if c == card then
            owned = true
            break
        end
    end
    if not owned then return end
    local has_money = G.GAME.dollars > card.ability.extra.threshold
    local applied = card._deep_pockets_applied
    if has_money and not applied then
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
        card._deep_pockets_applied = true
    elseif not has_money and applied then
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
        card._deep_pockets_applied = false
    end
end
}



