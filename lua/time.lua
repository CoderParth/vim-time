M = {}

-- Function to start tracking time (on VimEnter)
M.start_time = function()
	local data_dir = vim.fn.stdpath("data") .. "/vim_time/"
	os.execute("mkdir -p " .. data_dir)
	local file_path = data_dir .. "vim_start_time"
	local start_time = os.time()
	local file = io.open(file_path, "w")
	if file then
		file:write(tostring(start_time))
		file:close()
	else
		print("Failed to create the start time file.")
	end
end

-- Function to read the start time and calculate the total elapsed time
M.calculate_total_elapsed_time = function()
	local data_dir = vim.fn.stdpath("data") .. "/vim_time/"
	local file_path = data_dir .. "vim_start_time"
	local file = io.open(file_path, "r")
	if file then
		local start_time = tonumber(file:read("*a"))
		file:close()
		if start_time then
			local current_time = os.time()
			local elapsed_time = current_time - start_time
			local total_time = 0
			local total_file_path = data_dir .. "total_time_spent"
			local total_file = io.open(total_file_path, "r")
			if total_file then
				total_time = tonumber(total_file:read("*a")) or 0
				total_file:close()
			end
			total_time = total_time + elapsed_time
			local totalHrs = math.floor(total_time / 3600)
			local totalMins = math.floor((total_time % 3600) / 60)
			print("Total Time Spent: " .. totalHrs .. " hours and " .. totalMins .. " minutes.")
			local total_file_write = io.open(total_file_path, "w")
			if total_file_write then
				total_file_write:write(tostring(total_time))
				total_file_write:close()
			else
				print("Failed to write the total time file.")
			end
		else
			print("Failed to read the start time from the file.")
		end
	else
		print("Failed to read the start time from the file.")
	end
end

-- Function to show the total time spent (for the :Time command)
M.show_total_time = function()
	local data_dir = vim.fn.stdpath("data") .. "/vim_time/"
	local total_file_path = data_dir .. "total_time_spent"
	local total_file = io.open(total_file_path, "r")
	if total_file then
		local total_time = tonumber(total_file:read("*a")) or 0
		total_file:close()
		local totalHrs = math.floor(total_time / 3600)
		local totalMins = math.floor((total_time % 3600) / 60)
		print("Total Time Spent: " .. totalHrs .. " hours and " .. totalMins .. " minutes.")
	else
		vim.cmd(
			'echohl ErrorMsg | echo "This is your first time. Quit and start nvim again to get the total time spent." | echohl None'
		)
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		M.start_time()
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		M.calculate_total_elapsed_time()
	end,
})

vim.api.nvim_create_user_command("Time", M.show_total_time, {})

return M
