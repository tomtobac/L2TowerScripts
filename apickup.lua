
-- 1. Type command to active: /apickup            --
----------------------------------------------------
-- http://forum.l2tower.eu/thread-free-plugin-apickup-using-ingame-pickup-action-with-filtering-lists

PickUpStatus = false;
ifound = 0;
PickupRange = 100;

-------------
function OnCreate()
	this:RegisterCommand("apickup", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;

function OnLogout()
	PickUpStatus = false;
end;
 
function OnDestroy()
	PickUpStatus = false;
end;

function OnCommand_apickup(vCommandChatType, vNick, vCommandParam)
	if (PickUpStatus == false) then
		PickUpStatus = true;
		ShowToClient("aPickup","Auto Pickup Is Activated.");
	else
		PickUpStatus = false;
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

						if (item:GetQuantity() < 100000) then

							ifound=ifound+1;
							ShowToClient("aPickup","ID "..tostring(item:GetNameId()).." - "..tostring(item:GetQuantity()).." "..tostring(item:GetName()));	
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
						Command('/pickup');
					end;
					Command('/pickup');
				end;
			else
				if (IsPaused() == true) then
					SetPause(false);
				end;
				
			end; --/check mobs
			
		end;		
end;
