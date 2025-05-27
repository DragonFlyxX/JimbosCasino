SMODS.Joker {
    key = "Damocles",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    atlas = "CasinoJokers",
    pos = { x = 1, y = 0 },
    cost = 7,
    config = { extra = { x_mult = 2 } },
    self_ability = { extra = 1 },
    loc_vars = function(self, info_queue, center)
        local x_mult = self.ability and self.ability.extra and self.ability.extra.x_mult or 0
        return { vars = { x_mult = x_mult } }
    end,
    loc_txt = {
        name = "Damocles",
        text = {
            '{C:attention}Jacks{} give {X:mult,C:white}X2{} Mult',
            'when scored. Sets hands',
            'to {C:attention}1{} when {C:attention}blind{} is selected',
        },
    },
    calculate = function(self, card, context)
        if card.debuff then return nil end
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if context.other_card and context.other_card.get_id and context.other_card:get_id() == 11 then
                return {
                    x_mult = card.ability.extra.x_mult,
                    card = card,
                }
            end
        end
        local whoami = context.blueprint_card or card
        if context.setting_blind and not whoami.getting_sliced then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    self.hands_sub = G.GAME.round_resets.hands - 1
        ease_hands_played(-self.hands_sub)
                    return true
                end
            }))
        end
    end,
}
