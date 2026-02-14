local function setup()
	ps.sub("cd", function()
		local cwd = tostring(cx.active.current.cwd)
		if cwd:match("/Downloads$") then
			ya.manager_emit("sort", { "mtime", reverse = true, dir_first = true })
		else
			ya.manager_emit("sort", { "natural", reverse = false, dir_first = true })
		end
	end)
end

return { setup = setup }
