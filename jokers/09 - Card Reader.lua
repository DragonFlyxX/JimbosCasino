SMODS.Joker {
    key = "Cardreader",
    config = { extra = 1 },
    unlocked = true,
    discovered = true, 
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 3,
    atlas = "CasinoJokers",
    pos = { x = 2, y = 1 },
    cost = 10,
    loc_txt = {
        name = "Card Reader",
        text = {
            'Retrigger all {C:attention}Jokers{}',
            'with an {C:dark_edition}edition{}; said',
            '{C:attention}Jokers{} cost {C:money}$4{}',
            'when triggered',
            '{s:0.8,C:inactive}(Cannot retrigger Card Reader)',
        },
    },
    calculate = function(self, card, context)
        local edition = context.other_card and context.other_card.edition and context.other_card.edition.key
        local is_valid_edition = edition == "e_foil"
                            or edition == "e_holo"
                            or edition == "e_polychrome"
                            or edition == "e_negative"
                            or edition == "e_base" -- Supposed to retrigger any joker, but I don't care to find how to refer to base jokers
        if context.retrigger_joker_check and
            context.other_card.config.center.key ~= self.key and
            context.other_ret and context.other_ret.jokers and context.other_ret.jokers.was_blueprinted == nil and
            is_valid_edition then
            ease_dollars(-4) -- Retrigger Cost
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "Scanned Joker",
                colour = G.C.RED,
                delay = 1.5,
            })
            return {
                message = localize("k_again_ex"),
                repetitions = 1,
                message_card = context.blueprint_card or card,
                was_blueprinted = context.blueprint
            }
        elseif context.repetition and not context.repetition_only and 
            context.other_card and is_valid_edition then
            return {
                message = localize("k_again_ex"),
                repetitions = 1,
                card = card,
                was_blueprinted = context.blueprint
            }
        end
    end
}

