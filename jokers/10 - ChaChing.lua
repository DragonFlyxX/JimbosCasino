SMODS.Joker({
    key = "cha_ching",
    atlas = "CasinoJokers",
    pos = {x = 0, y = 3},
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {retriggers = 1}},
    loc_txt = {
        name = "Cha Ching",
        text = {
            "Gives a retrigger for", 
            "every {C:money}$4{} earned when",
            "a card is {C:attention}first{} scored.",
            "{C:inactive,s:0.8}(Only counts the single highest",
            "{C:inactive,s:0.8}amount earned before calculating)"
        }
    },
   calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
        local target_card = context.other_card
        if target_card and target_card.cha_ching_money_earned then
            local earned = target_card.cha_ching_money_earned
            local retriggers = math.floor(earned / 4)

            if retriggers > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = retriggers,
                    card = card
                }
            end
        end
    end
end

})
-- Hook to track money earned by individual cards
local old_ease = ease_dollars
function ease_dollars(mod, instant)
    old_ease(mod, instant)

    if G.GAME.Casino_Scoring_Active and to_big(mod) > to_big(0) then
        -- Try to find which card caused the earning
        for _, card in ipairs(G.play.cards) do
            if card and not card.fresh_play_scored then
                card.cha_ching_money_earned = (0) + (mod or 0)
            end
        end
    end
end
-- Reset card tracking before each play
local old_eval_play = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play()
    for _, card in ipairs(G.play.cards) do
        if card then
            card.cha_ching_money_earned = 0
        end
    end
    G.GAME.Casino_Scoring_Active = true
    old_eval_play()
    G.GAME.Casino_Scoring_Active = false
end
local old_calculate = Card.calculate
function Card:calculate(context)
    local result = old_calculate(self, context)

    if context.cardarea == G.play and context.repetition and not context.repetition_only then
        if self.cha_ching_money_earned and self.cha_ching_money_earned > 0 then
            self.cha_ching_money_earned = 0
        end
    end

    return result
end

to_big = to_big or function(x)
    return x
end
