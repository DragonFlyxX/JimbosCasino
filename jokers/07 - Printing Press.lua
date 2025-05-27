SMODS.Joker {
    key = "PrintingPress",
    config = { extra = {} },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 2,
    atlas = "CasinoJokers",
    pos = { x = 3, y = 2 },
    cost = 7,
    loc_txt = {
        name = "Printing Press",
        text = {
            "If {C:attention}first hand{} of round only",
            "has {C:attention}1{} card, and it doesn't",
            "have an {C:dark_edition}edition{}, give it",
            "a random {C:dark_edition}edition{}",
        },
    },
    loc_vars = function(self, info_queue, center)
        if not center.edition or (center.edition and not center.edition.polychrome) then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        end
        if not center.edition or (center.edition and not center.edition.holo) then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        end
        if not center.edition or (center.edition and not center.edition.foil) then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        end
        return {
            vars = {
                center.ability.extra.mult,
                center.ability.extra.xmult,
                center.ability.extra.chips
            }
        }
    end,
    calculate = function(self, card, context)
    if context.first_hand_drawn and card.area == G.jokers then
        juice_card_until(card, function()
            return G.GAME.current_round.hands_played == 0
        end, true)
    end
    if context.joker_main and G.GAME.current_round.hands_played == 0 then
        local played_cards = G.play and G.play.cards or {}

        if #played_cards == 1 then
            local target_card = played_cards[1]

            if not target_card.edition then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        local edition = poll_edition('printingpress', nil, true, true)
                        target_card:set_edition(edition, true)
                        return true
                    end
                }))
            end
        end
    end
end

}



