function love.conf(t)
	t.title = "i sort of wish this was a mech game but it isn't"
	t.identity = "mech"

	--t.screen.width = 1024
	--t.screen.height = 896
	t.screen.width  = 900
	t.screen.height = 500
	t.screen.fullscreen = false
	t.screen.vsync = true
	t.screen.fsaa = 0

	--Do not edit pls
	-- t.modules.joystick = false
	t.modules.physics = false
end
