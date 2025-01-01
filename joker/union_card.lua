SMODS.Joker {
    key = 'union_card',
    loc_txt = {
        name = "Union Card",
        text = {
            "Sell value of all cards is locked",
            "at {C:money}$0{} until this Joker is sold",
            "Gives {X:mult,C:white}X{} Mult equal to the",
            "number of scored {C:diamonds}Diamonds{} or",
            "{C:hearts}Hearts{} in played hand"
        }
    },
    rarity = 3,
    pos = { x = 8, y = 1 },
    atlas = "jokers_atlas",
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    soul_pos = nil,

    add_to_deck = function(self, card, from_debuff)
        for k, v in ipairs(G.jokers.cards) do
            if v.set_cost then
                v.zero_sell_cost = true
                v:set_cost()
            end
        end

        for k, v in ipairs(G.consumeables.cards) do
            if v.set_cost then
                v.zero_sell_cost = true
                v:set_cost()
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        for k, v in ipairs(G.jokers.cards) do
            if v.set_cost then
                v.custom_sell_cost = false
                v:set_cost()
            end
        end

        for k, v in ipairs(G.consumeables.cards) do
            if v.set_cost then
                v.custom_sell_cost = false
                v:set_cost()
            end
        end
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local suitable_cards = 0

            for k, v in ipairs(context.scoring_hand) do
                if v:is_suit("Diamonds") or v:is_suit("Hearts") then
                    suitable_cards = suitable_cards + 1
                end
            end

            if suitable_cards > 1 then
                return {
                    Xmult_mod = suitable_cards,
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { suitable_cards }
                    },
                    card = card
                }
            end
        end
    end
}

local add_to_deck_ref = Card.add_to_deck
Card.add_to_deck = function(self, from_debuff)
    add_to_deck_ref(self, from_debuff)

    if self.set_cost then
        self:set_cost()
    end
end
