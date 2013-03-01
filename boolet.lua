Class = require "hump.class"
lvec = require "hump.vector-light"
Ringbuffer = require "hump.ringbuffer"
Consts = require "balance"

local Boolets = {}
local bnum = 0

--copies table 1 into table 2, table 2 is given precedence in conflicts
local function combo(tab1, tab2)
	for k,v in pairs(tab1) do
		if not tab2[k] then
			tab2[k] = v
		end
	end
	return tab2
end

local types = {
	default = {
		name = "rapidfire",
		speed = Consts.bulletspeed,
		cost = Consts.bulletcost,
		dmg = Consts.bulletdmg,
		size = 5,
		decay = 2,
		rate = Consts.bulletrate,
		number = 3
	},
	bomb = {
		name = "bomb",
		number = 1,
		cost = Consts.bulletcost * 3,
		dmg = Consts.bulletdmg * 3,
		size = 100,
		speed = 0, 
		decay = 10,
		draw = function(self)
			local g = love.graphics
			local rc = self.owner.CDcolor
			g.setColor(rc)
			g.circle('fill', self.x, self.y, self.btype.size)
		end
	}
}
--NOTE: you have to do this for every type, deal /w it nerd
combo(types.default, types.bomb)
 
local Boolet = Class{
	name = "bullet",
	function(self, owner, btype)
		assert(owner)
		self.owner = owner
		self.btype = btype or owner.ammotype
		self.x = owner.x
		self.y = owner.y
		bnum = bnum+1
		self.hsh = string.format("b%d", bnum)
		Boolets[self.hsh] = self
		self.t = self.btype.decay
	end
}

Boolet.types = types

function Boolet.reset()
	Boolets = {}
	bnum = 0
end

function Boolet.updateall(dt, me, you)
	for k, v in pairs(Boolets) do
		v:update(dt, me, you)
	end
end

function Boolet.drawall()
	for k, v in pairs(Boolets) do
		v:draw()
	end
end

function Boolet:point(xx, yy)
	local v = Vec(xx, yy)
	v:normalize_inplace()
	local vx, vy = v:unpack()
	local s = self.btype.speed
	self.vx = vx*s
	self.vy = vy*s
end

function Boolet:update(dt, me, you)
	self.x = self.x + self.vx
	self.y = self.y + self.vy
	if self:isTouching(me) and me ~= self.owner then
		
		me:hurt(self.btype.dmg)
		Boolets[self.hsh] = nil
	end
	
	if self:isTouching(you) and you ~= self.owner then
		you:hurt(self.btype.dmg)
		Boolets[self.hsh] = nil
	end
	
	self.t = self.t - dt
	if self.t < dt then
		Boolets[self.hsh] = nil
	end
end

function Boolet:isTouching(dude)
	assert(dude.w)
	return lvec.len2(self.x - dude.x, self.y - dude.y) < (dude.w * dude.w + self.btype.size * self.btype.size)
end

function Boolet:draw()
	if self.btype.draw then self.btype.draw(self) return end
	local g = love.graphics
	local rc = self.owner.idlecolor
	g.setColor(rc)
	g.circle('fill', self.x, self.y, self.btype.size)
end

return Boolet