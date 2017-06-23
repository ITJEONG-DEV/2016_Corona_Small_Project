local notifications = require "plugin.notifications"

local notificationListener = function( e )
	if e.type == "remote" then
	elseif e.type == "local" then
	end
end

Runtime:addEventListener( "notification",, listener )