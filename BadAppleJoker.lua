--- STEAMODDED HEADER
--- MOD_NAME: Bad Apple Joker
--- MOD_ID: BadApple
--- MOD_AUTHOR: [JamestheJellyfish]
--- MOD_DESCRIPTION: Adds the Bad Apple Joker to the game

----------------------------------------------
------------MOD CODE -------------------------

local localization = {
    bad_apple_joker = {
        name = "Bad Apple Joker",
        text = {
            "You aren't quite sure what this",
            "does. But it sure is intriguing to look at.",
        }
    },
}

--[[SMODS.Joker:new(
    name, slug,
    config,
    spritePos, loc_txt,
    rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat
)
]]
local jokers = {
    bad_apple_joker = SMODS.Joker:new(
        "Bad Apple Joker", "",
        {},
        {}, "",
        3, 10, true, true, false, true
    ),
}

-- Blacklist individual Jokers here
local jokerBlacklists = {
    bad_apple_joker = false
}

local challenges = {
	{
		name = 'Bad Apple Start',
			id = 'c_bad_apple_1',
			rules = {
				custom = {
				},
				modifiers = {
				}
			},
			jokers = {
				{id = 'j_bad_apple_joker'},
			},
			consumeables = {
			},
			vouchers = {
			},
			deck = {
				type = 'Challenge Deck'
			},
			restrictions = {
				banned_cards = {
				},
				banned_tags = {
				},
				banned_other = {
				}
			}
		},
	}

function SMODS.INIT.BadApple()
    sendDebugMessage("Loaded BadAppleJoker~")
	for i=1, #challenges do
        table.insert(G.CHALLENGES, #G.CHALLENGES+1,challenges[i])
        G.localization.misc.challenge_names[challenges[i].id] = challenges[i].name
    end

    -- Localization
    init_localization()

    -- Add Jokers to center
    for k, v in pairs(jokers) do
        if not jokerBlacklists[k] then
            v.slug = "j_" .. k
            v.loc_txt = localization[k]
            v.spritePos = { x = 0, y = 0 }
            v:register()
            SMODS.Sprite:new("BadApple", SMODS.findModByID("BadApple").path, v.slug..".png", 71, 95, "animation_atli", 6555):register()
        end
    end



end


function love.errhand(msg)
	if G.F_NO_ERROR_HAND then return end
	msg = tostring(msg)

	local error = msg
	local file = string.sub(msg, 0,  string.find(msg, ':'))
	local function_line = string.sub(msg, string.len(file)+1)
	function_line = string.sub(function_line, 0, string.find(function_line, ':')-1)
	file = string.sub(file, 0, string.len(file)-1)
	local trace = debug.traceback()
	local boot_found, func_found = false, false
	for l in string.gmatch(trace, "(.-)\n") do
		if string.match(l, "boot.lua") then
			boot_found = true
		elseif boot_found and not func_found then
			func_found = true
			trace = ''
			function_line = string.sub(l, string.find(l, 'in function')+12)..' line:'..function_line
		end

		if boot_found and func_found then 
			trace = trace..l..'\n'
		end
	end
	sendDebugMessage("Error: " .. error)
	sendDebugMessage("File: " .. file)
	sendDebugMessage("function_line: " .. function_line)
	sendDebugMessage("Trace: " .. trace)

	if G.SETTINGS.crashreports and _RELEASE_MODE and G.F_CRASH_REPORTS then 
		local http_thread = love.thread.newThread([[
			local https = require('https')
			CHANNEL = love.thread.getChannel("http_channel")

			while true do
				--Monitor the channel for any new requests
				local request = CHANNEL:demand()
				if request then
					https.request(request)
				end
			end
		]])
		local http_channel = love.thread.getChannel('http_channel')
		http_thread:start()
		local httpencode = function(str)
			local char_to_hex = function(c)
				return string.format("%%%02X", string.byte(c))
			end
			str = str:gsub("\n", "\r\n"):gsub("([^%w _%%%-%.~])", char_to_hex):gsub(" ", "+")
			return str
		end
		

		local error = msg
		local file = string.sub(msg, 0,  string.find(msg, ':'))
		local function_line = string.sub(msg, string.len(file)+1)
		function_line = string.sub(function_line, 0, string.find(function_line, ':')-1)
		file = string.sub(file, 0, string.len(file)-1)
		local trace = debug.traceback()
		local boot_found, func_found = false, false
		for l in string.gmatch(trace, "(.-)\n") do
			if string.match(l, "boot.lua") then
				boot_found = true
			elseif boot_found and not func_found then
				func_found = true
				trace = ''
				function_line = string.sub(l, string.find(l, 'in function')+12)..' line:'..function_line
			end

			if boot_found and func_found then 
				trace = trace..l..'\n'
			end
		end

		http_channel:push('https://958ha8ong3.execute-api.us-east-2.amazonaws.com/?error='..httpencode(error)..'&file='..httpencode(file)..'&function_line='..httpencode(function_line)..'&trace='..httpencode(trace)..'&version='..(G.VERSION))
	end

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20)

	love.graphics.setBackgroundColor(G.C.BLACK)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.clear(love.graphics.getBackgroundColor())
	love.graphics.origin()


	local p = 'Oops! Something went wrong:\n'..msg..'\n\n'..(not _RELEASE_MODE and debug.traceback() or G.SETTINGS.crashreports and
		'Since you are opted in to sending crash reports, LocalThunk HQ was sent some useful info about what happened.\nDon\'t worry! There is no identifying or personal information. If you would like\nto opt out, change the \'Crash Report\' setting to Off' or
		'Crash Reports are set to Off. If you would like to send crash reports, please opt in in the Game settings.\nThese crash reports help us avoid issues like this in the future')

	local function draw()
		local pos = love.window.toPixels(70)
		love.graphics.clear(love.graphics.getBackgroundColor())
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end

	while true do
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return
			elseif e == "keypressed" and a == "escape" then
				return
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end


local set_sprites_ref = Card.set_sprites
function Card:set_sprites(_center, _front)
	if _center then
		if _center.name == 'Bad Apple Joker' then
			self.children.center = AnimatedSprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ANIMATION_ATLAS['BadApple'], self.config.center.pos)
			self.children.center.states.hover = self.states.hover
			self.children.center.states.click = self.states.click
			self.children.center.states.drag = self.states.drag
			self.children.center.states.collide.can = false
			self.children.center.framerate_override = 30
			self.children.center:set_role({major = self, role_type = 'Glued', draw_major = self})
			if not self.children.back then
				self.children.back = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["centers"], self.params.bypass_back or (self.playing_card and G.GAME[self.back].pos or G.P_CENTERS['b_red'].pos))
				self.children.back.states.hover = self.states.hover
				self.children.back.states.click = self.states.click
				self.children.back.states.drag = self.states.drag
				self.children.back.states.collide.can = false
				self.children.back:set_role({major = self, role_type = 'Glued', draw_major = self})
			end
			return
		end
	end
    set_sprites_ref(self, _center, _front)
end

function AnimatedSprite:animate()
	local FPS = G.ANIMATION_FPS
	if self.framerate_override then FPS = self.framerate_override end
    local new_frame = math.floor(FPS*(G.TIMERS.REAL - self.offset_seconds))%self.current_animation.frames
    local frame_length = math.floor(self.image_dims[1] / self.animation.w)
	if new_frame ~= self.current_animation.current then
        self.current_animation.current = new_frame % frame_length
        self.frame_offset = math.floor(self.animation.w*(self.current_animation.current))
        self.sprite:setViewport( 
            self.frame_offset,
            self.animation.h*(self.animation.y + math.floor(new_frame / frame_length)),
            self.animation.w,
            self.animation.h)
    end
    if self.float then 
        self.T.r = 0.02*math.sin(2*G.TIMERS.REAL+self.T.x)
        self.offset.y = -(1+0.3*math.sin(0.666*G.TIMERS.REAL+self.T.y))*self.shadow_parrallax.y
        self.offset.x = -(0.7+0.2*math.sin(0.666*G.TIMERS.REAL+self.T.x))*self.shadow_parrallax.x
    end
end

-- UIBox garbage / Copied from LushMod. Thanks luscious!
local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self)
    local card_type, hide_desc = self.ability.set or "None", nil
    local loc_vars = nil
    local main_start, main_end = nil, nil
    local no_badge = nil

    if self.config.center.unlocked == false and not self.bypass_lock then    -- For everyting that is locked
    elseif card_type == 'Undiscovered' and not self.bypass_discovery_ui then -- Any Joker or tarot/planet/voucher that is not yet discovered
    elseif self.debuff then
    elseif card_type == 'Default' or card_type == 'Enhanced' then
    elseif self.ability.set == 'Joker' then
        local customJoker = false

        if self.ability.name == 'Bad Apple Joker' then
            customJoker = true
        end

        if customJoker then
            local badges = {}
            if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                badges.card_type = card_type
            end
            if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                badges.force_rarity = true
            end
            if self.edition then
                if self.edition.type == 'negative' and self.ability.consumeable then
                    badges[#badges + 1] = 'negative_consumable'
                else
                    badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                end
            end
            if self.seal then
                badges[#badges + 1] = string.lower(self.seal) .. '_seal'
            end
            if self.ability.eternal then
                badges[#badges + 1] = 'eternal'
            end
            if self.pinned then
                badges[#badges + 1] = 'pinned_left'
            end

            if self.sticker then
                loc_vars = loc_vars or {};
                loc_vars.sticker = self.sticker
            end

            local center = self.config.center
            return generate_card_ui(center, nil, loc_vars, card_type, badges, hide_desc, main_start, main_end)
        end
    end
    return generate_UIBox_ability_tableref(self)
end


G.FUNCS.draw_from_deck_to_hand = function(e)
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and
        G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then 
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
        return true
    end

    local hand_space = e or math.min(#G.deck.cards, G.hand.config.card_limit - #G.hand.cards)
    if G.GAME.blind.name == 'The Serpent' and
        not G.GAME.blind.disabled and
        (G.GAME.current_round.hands_played > 0 or
        G.GAME.current_round.discards_used > 0) then
            hand_space = math.min(#G.deck.cards, 3)
    end
    delay(0.3)
	local override_cards = {}
    for i=1, hand_space do --draw cards from deck
		local card = nil
		if next(find_joker("Bad Apple Joker")) then
			if pseudorandom('bad_apple') <= 0.28 then
				sendDebugMessage("Bad Apple Found!" .. tostring(#G.deck.cards))
				for j=1,math.floor(#G.deck.cards/2) do
					local v = pseudorandom_element(G.deck.cards, pseudoseed('bad_apple_draw'))
					local already_drawn = false
					for k=1,#override_cards do
						if v == override_cards[k] then already_drawn = true end
					end
					if not card and not already_drawn then card = v end
					if card and card:get_chip_bonus() + 1 < v:get_chip_bonus() and not already_drawn then
						card = v
					end
				end

				if card then
					override_cards[#override_cards + 1] = card 
					sendDebugMessage("Overriding card drawn to be a: " .. tostring(card:get_id())) 
				end
			end
		end
        if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK then 
			if card then draw_card(G.deck,G.hand, i*100/hand_space,'up', true, card)
			else draw_card(G.deck,G.hand, i*100/hand_space,'up', true) end
        else
            if card then draw_card(G.deck,G.hand, i*100/hand_space,'up', true, card)
			else draw_card(G.deck,G.hand, i*100/hand_space,'up', true) end
        end
    end
end

