Casino = Casino or {}
function Casino.rank_from_deck(seed)
	local ranks = {}
	seed = seed or 'gilded_heart'
	for _, card in pairs(G.playing_cards) do
		ranks[card.base.value] = card.base.value
	end
	local chosen = pseudorandom_element(ranks, pseudoseed(seed))
	return chosen
end
SMODS.Joker({
	key = "gilded_heart",
	atlas = "CasinoJokers",
	pos = {x = 2, y = 0},
	rarity = 2,
	cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	loc_txt = {
		name = "Gilded Heart",
		text = {
			"Retrigger each {C:attention}Gold{}",
			"{C:attention}#2#{} of {C:red}hearts{} {C:attention}3{}",
			"additional times when",
			"played or in hand",
			"{s:0.8}Rank changes each round",
		}},
	config = {extra = {repetitions = 1, rank = 'Jack'}},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		return {vars = {card.ability.extra.repetitions, localize(card.ability.extra.rank, 'ranks')}}
	end,
	set_ability = function(self, card)
		if G.playing_cards and #G.playing_cards > 0 then
			card.ability.extra.rank = Casino.rank_from_deck('gilded_heart')
		end
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.extra.rank = Casino.rank_from_deck('gilded_heart')
			card:juice_up()
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = localize(card.ability.extra.rank, 'ranks')
			})
		end
		if (context.cardarea == G.play or context.cardarea == G.hand) and context.repetition and not context.repetition_only then
			local c = context.other_card
			if c
			and c.base.value == card.ability.extra.rank
			and SMODS.has_enhancement(c, "m_gold")
			and c:is_suit("Hearts")
			and not c.debuff then
				return {
					card = card,
					repetitions = 3, --Upset this shit works ngl, I was trying way too hard
					message = localize('k_again_ex')}
			end
		end
	end
})



