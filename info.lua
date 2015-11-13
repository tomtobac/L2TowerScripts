--ShowToClient("", tostring(GetTarget():GetId()));
--ShowToClient("", tostring(GetMe():GetMp()));

function mostraMobs()
	local moblist = GetNpcList()
	for mob in moblist.list do
		--	ShowToClient("mob", tostring(mob:GetName()) .. " " .. tostring(mob:GetNpcId()))
		Sleep(500)
		--	ShowToClient("bot", "target mob:npc id")
		Target(mob:GetNpcId())
		--ShowToClient("bot", "target mob:get id")
		--Target(mob:GetId())
		--ShowToClient("bot", "target mob")
		--Target(mob)
		--	ShowToClient("bot", "targetRaw mob:get id")
		TargetRaw(mob:GetId())
		--	ShowToClient("bot", "targetRaw mob:npc id")
		TargetRaw(mob:GetNpcId())
		--ShowToClient("bot", "targetNpc mob:get name, mob:npc id")
		--TargetNpc(mob:GetName(), mob:GetNpcId())
		--ShowToClient("bot", "targetNpc mob:get name, mob:get id")
		--TargetNpc(mob:GetName(), mob:GetId())
	end
	ShowToClient("bot", "done")
end

function mostraSkills()
	local var = GetSkills()
	for skill in var.list do
	ShowToClient("BOT", "Skill name: " .. tostring(skill.name) .. " ID skill: " .. tostring(skill.skillId));
	end
end

function mostraItems()
	local var = ItemDataList()
	--local var = var:GetList()
	if(var == nil) then
	ShowToclient("bot", "nothing to show")
	else
		for obj in var.list do
		ShowToClient("obj", "hola")
		end
	end
end
	

--mostraMobs()
ShowToClient("Bot", "otra")
--mostraSkills()
mostraItems()
--[[
TargetNpc("Plain Grizzly", 21097)
Target(21097)
TargetRaw(21097)
Target("Plain Grizzly")
--Target(21098)
--Target(21099)
--]]
