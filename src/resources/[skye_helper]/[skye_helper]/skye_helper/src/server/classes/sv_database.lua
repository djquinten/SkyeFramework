databaseClass = {}

function databaseClass:Execute(Query, Wait, Data, Cb)
	local RtnData = {}
	local Waiting = true
	local Wait = Wait or false
	exports['oxmysql']:query(Query, Data, function(ReturnData)
		if Cb and not Wait then
			Cb(ReturnData)
		end
		RtnData = ReturnData
		Waiting = false
	end)
	if Wait then
		while Waiting do
			Citizen.Wait(5)
		end
		if Cb and Wait then
			Cb(RtnData)
		end
	end
	return RtnData
end

function databaseClass:Insert(Query, Wait, Data, Cb)
	local RtnData = {}
	local Waiting = true
	localWait = Wait or false
	exports['oxmysql']:insert(Query, Data, function(ReturnData)
		if Cb and not Wait then
			Cb(ReturnData)
		end
		RtnData = ReturnData
		Waiting = false
	end)
	if Wait then
		while Waiting do
			Citizen.Wait(5)
		end
		if Cb and Wait then
			Cb(RtnData)
		end
	end
	return RtnData
end

function databaseClass:Update(Query, Wait, Data, Cb)
	local RtnData = {}
	local Waiting = true
	local Wait = Wait or false
	exports['oxmysql']:update(Query, Data, function(ReturnData)
		if Cb and not Wait then
			Cb(ReturnData)
		end
		RtnData = ReturnData
		Waiting = false
	end)
	if Wait then
		while Waiting do
			Citizen.Wait(5)
		end
		if Cb and Wait then
			Cb(RtnData)
		end
	end
	return RtnData
end