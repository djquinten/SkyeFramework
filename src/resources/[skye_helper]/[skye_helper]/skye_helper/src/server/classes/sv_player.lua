playerClass = {}

playerClass.players = {}

function playerClass:login(source, citizenId, newCharData)
	if not source then return loggerClass:console('error', 'player/login', "The source wans't found") end
	local player = {}
	if citizenId then
		player = getPlayerData(citizenId)

		while player == nil do
			Citizen.Wait(0)
		end

		playerClass.players[source] = player

		local done = playerClass:validatePlayer(source)
		while not done do
			Citizen.Wait(0)
		end

		playerClass:updatePlayer(source)
	else
		player.userdata = {}
		player.userdata.firstname = newCharData.firstname
		player.userdata.lastname = newCharData.lastname
		player.userdata.gender = newCharData.gender
		player.userdata.birhtdate = newCharData.birhtdate
		player.userdata.skill = newCharData.skill

		playerClass.players[source] = player

		local done = playerClass:validatePlayer(source)
		while not done do
			Citizen.Wait(0)
		end

		playerClass:savePlayer(source)
	end

	playerClass:createPlayerFunctions(source)
	return true
end

function playerClass:validatePlayer(source)
	local player = playerClass.players[source] or {}

	-- Validate playerdata
	player.name = GetPlayerName(source)
	player.steam = player.steam or playerClass:getIdentifierByType(source, 'steam')
	player.license = player.license or playerClass:getIdentifierByType(source, 'license')
	player.citizenid = player.citizenid or playerClass:createCitID()

	player.userdata = player.userdata or {}
	player.userdata.firstname = player.userdata.firstname or playerClass:dropPlayer(source) -- [TODO] Moet nog een export komen naar anticheat
	player.userdata.lastname = player.userdata.lastname or playerClass:dropPlayer(source) -- [TODO] Moet nog een export komen naar anticheat
	player.userdata.gender = player.userdata.gender or playerClass:dropPlayer(source) -- [TODO] Moet nog een export komen naar anticheat
	player.userdata.birhtdate = player.userdata.birhtdate or playerClass:dropPlayer(source) -- [TODO] Moet nog een export komen naar anticheat
	player.userdata.skill = player.userdata.skill or playerClass:dropPlayer(source) -- [TODO] Moet nog een export komen naar anticheat

	player.money = player.money or {}
	player.money["cash"] = player.money["cash"] or 500
	player.money["bank"] = player.money["bank"] or 500

	player.status = player.status or {}
	player.status.health = player.status.health or 100
	player.status.armor = player.status.armor or 0
	player.status.location = player.status.location or {x = 0, y = 0, z = 0} -- [TODO] Moet nog uit de config gehaald worden
	player.status.hunger = player.status.hunger or 100
	player.status.thirst = player.status.thirst or 100

	player.jobs = player.jobs or {}
	player.jobs[1] = player.jobs[1] or {job = 'unemployed', grade = 0, duty = true, xp = 0}

	player.metadata = player.metadata or {} -- [TODO] Moet nog data voor komen

	-- Save playerdata in variable
	playerClass.players[source] = player
	TriggerClientEvent('skye_helper:public:updatePlayerData', source, playerClass.players[source])
	return true
end

function playerClass:dropPlayer(source)
	return "dit moet nog weg"
end

function playerClass:savePlayer(source)
	local player = playerClass.players[source]
	TriggerClientEvent('skye_helper:public:updatePlayerData', source, playerClass.players[source])
	databaseClass:Insert("INSERT INTO server_players (name, steam, license, citizenid, userdata, money, status, jobs, metadata) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", true, {
		player.name,
		player.steam,
		player.license,
		player.citizenid,
		json.encode(player.userdata),
		json.encode(player.money),
		json.encode(player.status),
		json.encode(player.jobs),
		json.encode(player.metadata),
	})
end

function playerClass:updatePlayer(source)
	local player = playerClass.players[source]
	TriggerClientEvent('skye_helper:public:updatePlayerData', source, playerClass.players[source])
	databaseClass:Insert("UPDATE server_players SET name = ?, steam = ?, license = ?, citizenid = ?, userdata = ?, money = ?, status = ?, jobs = ?, metadata = ?", true, {
		player.name,
		player.steam,
		player.license,
		player.citizenid,
		json.encode(player.userdata),
		json.encode(player.money),
		json.encode(player.status),
		json.encode(player.jobs),
		json.encode(player.metadata),
	})
end

function getPlayerData(citizenid)
	local player = {}
	databaseClass:Execute("SELECT * FROM server_players WHERE citizenid = @citizenid", true, {['@citizenid'] = citizenid}, function(players)
		if players[1] then
			local data = players[1]
			
			player.name = data.name
			player.steam = data.steam
			player.license = data.license
			player.citizenid = data.citizenid
			player.userdata = json.decode(data.userdata)
			player.money = json.decode(data.money)
			player.status = json.decode(data.status)
			player.jobs = json.decode(data.jobs)
			player.metadata = json.decode(data.metadata)
			return player
		else
			return false
		end
	end)
end

function playerClass:getPlayerBySource(source)
	return playerClass.players[source]
end

function playerClass:getIdentifierByType(source, type)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, type) then
            return identifier
        end
    end
    return nil
end

-- All player functions
function playerClass:createPlayerFunctions(source)
	local self = playerClass.players[source]
	self.Functions = {}

	-- Player functions
	self.Functions.updatePlayer = function()
		playerClass:updatePlayer(source)
	end

	self.Functions.validatePlayer = function()
		playerClass:validatePlayer(source)
	end

	-- Userdata functions
	self.Functions.getUserdata = function(userdataType)
		if userdataType then
			if self.userdata[userdataType] then
				return self.userdata[userdataType]
			end
		end
		return self.userdata
	end

	-- Money functions
	self.Functions.getMoney = function(moneyType)
		return self.money[moneyType]
	end

	self.Functions.setMoney = function(moneyType, amount)
		self.money[moneyType] = amount
		playerClass:updatePlayer(source)
	end

	self.Functions.addMoney = function(moneyType, amount)
		self.money[moneyType] = self.money[moneyType] + amount
		playerClass:updatePlayer(source)
	end

	self.Functions.removeMoney = function(moneyType, amount)
		if self.money[moneyType] > amount then
			self.money[moneyType] = self.money[moneyType] - amount
			playerClass:updatePlayer(source)
		end
	end

	-- Status functions
	self.Functions.getStatus = function(statusType)
		if statusType then
			if self.status[statusType] then
				return self.status[statusType]
			end
		end

		return self.status
	end

	self.Functions.setStatus = function(statusType, value)
		if statusType then
			if self.status[statusType] then
				self.status[statusType] = value
				playerClass:updatePlayer(source)
				
				return self.status[statusType]
			end
		end

		return false
	end

	self.Functions.addStatus = function(statusType, amount)
		if statusType then
			if self.status[statusType] and statusType ~= "location" then
				self.status[statusType] = self.status[statusType] + amount
				playerClass:updatePlayer(source)

				return self.status[statusType]
			end
		end

		return false
	end

	self.Functions.removeStatus = function(statusType, amount)
		if statusType then
			if self.status[statusType] and statusType ~= "location" then
				if self.status[statusType] > amount then
					self.status[statusType] = self.status[statusType] - amount
					playerClass:updatePlayer(source)

					return self.status[statusType]
				end
			end
		end

		return false
	end

	-- Job functions
	self.Functions.getJobIndex = function(jobName)
		for index, job in pairs(self.jobs) do
			if job.job == jobName then
				return index
			end
		end

		return false
	end

	self.Functions.getJobs = function(jobName)
		local index = self.Functions.getJobIndex(jobName)

		if index >= 1 and index <= #self.jobs then
			local returnJob = {}

			returnJob.name = sharedJobs[self.jobs[index].job].label
			returnJob.grade = sharedJobs[self.jobs[index].job].grades[self.jobs[index].grade].label
			returnJob.duty = self.jobs[index].duty
			returnJob.salary = sharedJobs[self.jobs[index].job].grades[self.jobs[index].grade].salary
			returnJob.xp = self.jobs[index].xp

			return returnJob
		end

		local returnJobs = {}
		for jobIndex, job in pairs(self.jobs) do
			local returnJob = {}

			returnJob.name = sharedJobs[self.jobs[jobIndex].job].label
			returnJob.grade = sharedJobs[self.jobs[jobIndex].job].grades[self.jobs[jobIndex].grade].label
			returnJob.duty = self.jobs[index].duty
			returnJob.salary = sharedJobs[self.jobs[jobIndex].job].grades[self.jobs[jobIndex].grade].salary
			returnJob.xp = self.jobs[index].xp

			table.insert(returnJobs, returnJob)
		end

		return returnJobs
	end

	self.Functions.setJob = function(index, job, grade)
		if index >= 1 then
			if sharedJobs[job] then
				if sharedJobs[job].grades[grade] then
					self.jobs[index] = {
						job = job,
						grade = grade,
						xp = 0
					}

					playerClass:updatePlayer(source)

					return true
				end
			end
		else
			local newJob = {
				job = job,
				grade = grade,
				xp = 0
			}

			table.insert(self.jobs, newJob)
			playerClass:updatePlayer(source)

			return true
		end

		return false
	end

	self.Functions.getJobXp = function(jobName)
		local jobIndex = self.getJobIndex(jobName)

		if jobIndex then
			return self.jobs[index].xp
		end

		return false
	end

	self.Functions.setJobXp = function(jobName, amount)
		local jobIndex = self.getJobIndex(jobName)

		if jobIndex then
			self.jobs[index].xp = amount
			playerClass:updatePlayer(source)

			return self.jobs[index].xp
		end

		return false
	end

	self.Functions.addJobXp = function(jobName, amount)
		local jobIndex = self.getJobIndex(jobName)

		if jobIndex then
			self.jobs[index].xp = self.jobs[index].xp + amount
			playerClass:updatePlayer(source)

			return self.jobs[index].xp
		end

		return false
	end

	self.Functions.removeJobXp = function(jobName, amount)
		local jobIndex = self.getJobIndex(jobName)

		if jobIndex then
			if self.jobs[index].xp > amount then
				self.jobs[index].xp = self.jobs[index].xp - amount
				playerClass:updatePlayer(source)

				return self.jobs[index].xp
			end
		end

		return false
	end

	TriggerClientEvent('skye_helper:public:updatePlayerData', source, self)
	playerClass.players[source] = self
end

-- Extra functions
function playerClass:createCitID()
	local idCharacters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

	local found, citizenid = false, ""
	while not found do
		citizenid = ""
		for i = 1, 8 do
			citizenid = citizenid .. idCharacters[math.random(1, #idCharacters)]
		end

		databaseClass:Execute("SELECT * FROM server_players WHERE citizenid = ?", true, {citizenid}, function(data)
			if not data[1] then
				found = true
			end
		end)
	end

	return citizenid
end