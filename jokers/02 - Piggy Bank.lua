return SMODS.Joker {
    key = "PiggyBank",
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    rarity = 1,
    atlas = "CasinoJokers",
    pos = { x = 4, y = 0 },
    cost = 6,
    config = { extra = { break_chance = 6 } },
    loc_txt = {
        name = "Piggy Bank",
        text = {
            'Adds half of {C:money}$total{}',
            'to both {C:blue}Chips{} and {C:red}Mult{}',
            '{C:green}#1# in #2#{} chance to break',
            'after hand is played',
            '{C:inactive}(Currently {C:tarot}+#3#{} {C:inactive}Chips and Mult)'
        },
    },
    loc_vars = function(self, info_queue, card)
        local break_chance = card and card.ability.extra.break_chance or 8
        local normal_prob = G.GAME and G.GAME.probabilities.normal or 1
        local chance_num = normal_prob
        local chance_denom = break_chance
        local dollars = G.GAME and G.GAME.dollars or 0
        if info_queue and info_queue.context == 'shop_joker' and card then
            dollars = dollars + (card.cost or 0)
        end
        local half_amount = math.floor(dollars / 2)
        return {
            vars = {
                chance_num,
                chance_denom,
                half_amount
            }
        }
    end,
    calculate = function(self, card, context)
        if card.debuff then return end
        if context.joker_main and context.scoring_hand then
            local dollars = G.GAME and G.GAME.dollars or 0
            local amount = math.floor(dollars / 2)
            return {
                message = localize{type='variable', key='a_chips', vars={amount}} .. " & " .. localize{type='variable', key='a_mult', vars={amount}},
                chips = amount,
                mult_mod = amount
            }
        end
        if context.after and not context.repetition and not context.game_over and not context.blueprint and not context.individual then
            local base_prob = G.GAME and G.GAME.probabilities.normal or 1
            local odds = card.ability.extra.break_chance or 6
            local roll = pseudorandom('piggy_break')
            if roll < base_prob / odds then
                G.E_MANAGER:add_event(Event{
                    func = function()
                        play_sound('glass3')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event{
                            trigger = 'after',
                            delay = 0.5,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                return true
                            end
                        })
                        return true
                    end
                })
                return {
                    message = "Broken",
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}


