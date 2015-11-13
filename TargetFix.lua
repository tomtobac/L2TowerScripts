--[[

PLUGGIN.
/targetfix - enables plugin
source: http://forum.l2tower.eu/thread-off-topic-free-pack-of-scripts

--]]


TimeTillRequestChangeTarget = 1000*30 ; -- in mile seconds
TimeTillTryFixMovement = 1000*5 ; -- in mile seconds


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TargetFixStatus = false;
unstuckingstatus = false;
mytargetid = 0;
MyTargetTimeStamp = GetTime();
unstuckmovementstamp = GetTime();


function OnCreate()
    this:RegisterCommand("targetfix", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;


function OnCommand_targetfix(vCommandChatType, vNick, vCommandParam)
    if (TargetFixStatus == false) then
TargetFixStatus = true;
ShowToClient("TargetFix plugin","TargetFix is now ON!");
    else
TargetFixStatus = false;
ShowToClient("TargetFix plugin","TargetFix is now OFF!");    
    end;
end;



function OnChatSystemMessage(id, msg)
    if (TargetFixStatus == true) then
if (id == 181) then
if (GetMe():GetTarget() ~= 0) then 
-- ShowToClient("TargetFix plugin","Can't see target! Changing target...");
GetTarget():SetBlock(true);
CancelTargets();
end;
end;
    end;
end;


function OnLTick1s()
    if (TargetFixStatus == true) then
if (mylastcordcheck ~= nil) then
if (IsMoving() == false) then
if (GetTarget() ~= nil) and (GetMe():GetTarget() ~= 0) then
if (GetTarget():IsAlikeDeath() == false) and (GetTarget():IsMonster()) then
if (mytargetid ~= GetTarget():GetId()) then
mytargetid = GetTarget():GetId();
MyTargetTimeStamp = GetTime(); 
end; 
end; 
end;
else
MyTargetTimeStamp = GetTime();
end;
end;
    if (GetTarget() ~= nil) and (GetMe():GetTarget() ~= 0) then
if GetTarget():IsMonster() and (GetTarget():IsAlikeDeath() == false) then
if (MyTargetTimeStamp + TimeTillRequestChangeTarget < GetTime()) then
-- ShowToClient("TargetFix plugin","Player don't move and hit " .. tostring(TimeTillRequestChangeTarget/1000) .. " sec, so changing target!");
GetTarget():SetBlock(true);
CancelTargets(); 
elseif (MyTargetTimeStamp + TimeTillTryFixMovement < GetTime()) and (unstuckingstatus == false) then
SetPause(true);
unstuckmovementstamp = GetTime();
unstuckingstatus = true;
MovePerpendicularlyFromUser(GetTarget(),200);
end;
end;
    end;
    end;

mylastcordcheck = GetMe():GetLocation();

    if (GetTarget() == nil) or (GetMe():GetTarget() == 0) or (GetMe():IsBlocked(true)) then
MyTargetTimeStamp = GetTime();
    end;

    if (unstuckmovementstamp +2000 < GetTime()) and (unstuckingstatus == true) then
unstuckingstatus = false;
SetPause(false);
-- ShowToClient("TargetFix plugin","Trying to move around obstacle...");
    end;
end;


function MovePerpendicularlyFromUser(user,dist) 
    YQ = user:GetLocation().Y
    YP = GetMe():GetLocation().Y
    XQ = user:GetLocation().X
    XP = GetMe():GetLocation().X
    Mp = -1/((YQ-YP)/(XQ-XP)) 
if ((-2*XP-2*Mp*Mp*XP)*(-2*XP-2*Mp*Mp*XP) -4*(Mp*Mp+1)*(Mp*Mp*XP*XP + XP*XP-dist*dist) > 0) then
undersqrt = (-2*XP-2*Mp*Mp*XP)*(-2*XP-2*Mp*Mp*XP) -4*(Mp*Mp+1)*(Mp*Mp*XP*XP + XP*XP-dist*dist);
else
undersqrt = (-2*XP-2*Mp*Mp*XP)*(-2*XP-2*Mp*Mp*XP) -4*(Mp*Mp+1)*(Mp*Mp*XP*XP + XP*XP+dist*dist);
end; 
    XN = (-1*(-2*XP-2*Mp*Mp*XP)+math.sqrt(undersqrt))/(2*(Mp*Mp+1));
    YN = YP + Mp*(XN-XP) 
    MoveToNoWait(XN,YN,GetMe():GetLocation().Z);
end;



function IsMoving()
    if (GetDistanceVector(GetMe():GetLocation(),mylastcordcheck) > 100) then
return true;
    end;
return false;
end;



function OnMagicSkillUse(user, target, skillId, skillvl, skillHitTime, skillReuse)
    if (user:IsMe()) then
MyTargetTimeStamp = GetTime();
    end;
end;



function OnAttack(user, target)
    if (user:IsMe()) or (target:IsMe()) then
MyTargetTimeStamp = GetTime();
    end;
end;



function CancelTargets()
    ClearTargets();
    CancelTarget(true);
end;
