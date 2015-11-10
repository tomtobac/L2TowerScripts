--ShowToClient("", tostring(GetTarget():GetId()));
--ShowToClient("", tostring(GetMe():GetMp()));

mostraMobs()

function mostraMobs()
	local moblist = GetMonsterList();
	for mob in moblist.list do
	ShowToClient("mob", tostring(mob:GetId()))
	end
end

function mostraSkills()
	local var = GetSkills();
	
	for skill in var.list do
	ShowToClient("BOT", "Skill name: " .. tostring(skill.name) .. " ID skill: " .. tostring(skill.skillId));
	end;
end
