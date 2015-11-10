--ShowToClient("", tostring(GetTarget():GetId()));
--ShowToClient("", tostring(GetMe():GetMp()));

function mostraMobs()
	local moblist = GetMonsterList()
	for mob in moblist.list do
		ShowToClient("mob", tostring(mob:GetName()) .. tostring(mob:GetNpcId()))
	end
end

function mostraSkills()
	local var = GetSkills()
	for skill in var.list do
	ShowToClient("BOT", "Skill name: " .. tostring(skill.name) .. " ID skill: " .. tostring(skill.skillId));
	end
end

--mostraMobs()
ShowToClient("Bot", "asdas")
TargetNpc("Plain Grizzly", 21097)
Target(21097)
TargetRaw(21097)
Target("Plain Grizzly")
--Target(21098)
--Target(21099)
