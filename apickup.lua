----------------------------------------------------
-- Auto Pickup Plugin using /pickup action ingame --
-- Developed by SimonHM                           --
-- Any questions, contact me at: www.iprotion.com --
-- Happy gaming !                                 --
-- Note:                                          --
-- 1. Copy this file apickup.lua and alarm.wav    --
--    into l2tower/plugins folder                 --
-- 2. Copy 2 files: aPickup_wanted.txt and        --
--    aPickup_unwanted.txt in l2tower/logs folfer --
-- 3. Restart game client                         --
-- 4. Put /pickup action in short cut 4 1         --
-- 5. Type command to active: /apickup            --
----------------------------------------------------

PickUpStatus = false;
ifound = 0;
PickupRange = 100;

wanted_file = GetDir() .. "\\logs\\aPickup_wanted.txt";
unwanted_file = GetDir() .. "\\logs\\aPickup_unwanted.txt";

LastAlarmTime = 0;
CheckSound = GetDir() .. "\\plugins\\alarm.wav";

-------------

function CheckIfInsideList(Smsg,Rmsglist)
	for x,y in pairs(Rmsglist) do
		if (y == Smsg) then
			return true;
		end;
	end;
	return false;
end;

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb");
  if f then f:close() end;
  return f ~= nil;
end;

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end;
  lines = {};
  for line in io.lines(file) do 
    lines[#lines + 1] = line;
  end;
  return lines;
end;

	
function lines_from1(file)
  if not file_exists(file) then return {} end;
  lines = {};
  for line in io.lines(file) do 
      if (line:find("NAME")~=nil) then
		t = tonumber(line:find("NAME")) - 1;
		item_id = string.sub (line,1,t);
		lines[#lines + 1] = item_id;
	  end;
  end;
  return lines;
end;
	



function OnCreate()
	this:RegisterCommand("apickup", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;

function OnLogout()
	PickUpStatus = false;
end;
 
function OnDestroy()
	PickUpStatus = false;
end;

function LogMessage(message,filename)
	local file = io.open(filename, "r");
	if (file == nil) then
		file = io.open(filename, "w");
	end;
	file:close();
	file = io.open(filename, "a+");
	file:write(message..'\n');
	file:close();
end;

function OnCommand_apickup(vCommandChatType, vNick, vCommandParam)
	if (PickUpStatus == false) then
		PickUpStatus = true;
		ShowToClient("aPickup","Auto Pickup Plugin developed by SimonHM (www.iprotion.com)");
		ShowToClient("aPickup","Auto Pickup Is Activated.");
	else
		PickUpStatus = false;
		ShowToClient("aPickup","Auto Pickup Plugin developed by SimonHM (www.iprotion.com)");
		ShowToClient("aPickup","Auto Pickup Is Deactivated.");	
	end;
end;

function CheckIfMobsInRange()
	target = GetTarget();
	if (GetMe():GetRangeTo(target) <= PickupRange) and (target:IsAlikeDeath()) then
		return true;
	end;
	return false;
end;



function OnLTick1s()
		if (PickUpStatus == true) then
	
			if (CheckIfMobsInRange()) then
		  
				local mgr = GetItemManager();
				i=0;
				ifound=0;
				while (i<mgr:GetCount()) do
					local item = mgr:GetByIdx(i);
					i = i+1;
					if (item:GetRangeFixedTo(GetMe()) <= PickupRange) then
					
						-- get list of wanted items from file aPickup_wanted.txt
						local ListPickup_wanted = lines_from(wanted_file);
					
						if (CheckIfInsideList(tostring(item:GetNameId()),ListPickup_wanted)) and (item:GetQuantity() < 100000) then

								ifound=ifound+1;
								ShowToClient("aPickup","ID "..tostring(item:GetNameId()).." - "..tostring(item:GetQuantity()).." "..tostring(item:GetName()));	
								
						else
								-- detecting unwanted item				
								-- get list of unwanted items from file aPickup_unwanted.txt
								local ListPickup_unwanted = lines_from1(unwanted_file);		
								if not (CheckIfInsideList(tostring(item:GetNameId()),ListPickup_unwanted)) then
									ShowToClient("aPickup","ALERT !!! Found an unwanted item ID "..tostring(item:GetNameId()).." - "..tostring(item:GetQuantity()).." "..tostring(item:GetName()));
									if (LastAlarmTime + 35 < os.time()) then
										PlaySound(CheckSound);
										LastAlarmTime = os.time();
									end;
									LogMessage(tostring(item:GetNameId()).."NAME: "..tostring(item:GetQuantity()).." "..tostring(item:GetName()),unwanted_file);						
								end;
								-- end detecting						
						end;
					end;
				end;
				
				if (ifound < 1) then
					if (IsPaused() == true) then
						SetPause(false);
					end;
				else
					if (IsPaused() ~= true) then
						SetPause(true);
						Command('/useshortcut 4 1');
					end;
					Command('/useshortcut 4 1');
				end;
			else
				if (IsPaused() == true) then
					SetPause(false);
				end;
				
			end; --/check mobs
			
		end;		
end;
