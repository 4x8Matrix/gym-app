return function(thread: thread, callback: () -> ())
	return task.spawn(function()
		while true do
			if coroutine.status(thread) == "dead" then
				callback()

				return
			end

			task.wait(0.1)
		end
	end)
end
