moves = require "moves"
Consts = require "balance"

local Dude = Class{
	name = "dude",
	function(self, x, y)
		self.x = x or 100
		self.y = y  or 100
		self.w = 50
		
		self.joyx = 0
		self.joyy = 0
		self.hp = Consts.health
		self.ammo = 0
		self.ammotype = Boolet
		
		self.move = moves.cooldown(self, Consts.initialcountdown)
		self.boolets = {}
		self.bnum = 0
	end
}

function Dude:setmove(move)
	if move.priority > self.move.priority then
		self.move = move
	else
		self.rq = move
	end
end

function Dude:update(dt)
	self.ammo = math.min(self.ammo + 1, Consts.maxammo)
	self.move:update(dt)
end

function Dude:draw()
	self.move:draw()
end

function Dude:hurt(pain)
	self.hp = self.hp - (pain or Consts.bulletdmg)
	love.audio.stop(hert)
	love.audio.play(hert)
	if self.hp <= 0 then
		printf("%s win the viddy gam :D", self.other.name)
		self.other.wins = self.other.wins + 1
		justlikemakegame()
	end
end

return Dude