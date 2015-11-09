function checkPlayers()
    local white_list = {"one", "two"}; -- White List.
    local save_distance = 2000; -- Safe distance.
    local playerlist = GetPlayerList();
    local party_members = GetPartyList();
    local unlisted_players = "UNLISTED PLAYERS \n ";
    for player in playerlist.list do
        local check = false;
        if (player:GetDistance() < save_distance) then
        check = true; -- We don't care about him, its far away.
        end;
            -------- CHECK IF THE PLAYER IS IN THE PARTY MEMBER LIST --------
            for party in party_members.list do
                if (player = party) then
                check = true; -- he is a party member.
                end;
            end;
            -------- CHECK IF THE PLAYER IS IN THE WHITE_LIST --------
            for white in white_list.list do
                if (player = white) then
                check = true; -- he is in white list member.
                end;
            end;
            if (not check) then
            distance = player:GetRangeTo(GetMe());
            unlisted_players = unlisted_players .. player:GetName() .. " at " .. distance/100 .. "\n";
            end;
    end;
    return false;
end;

----------------- PLAYER LIST ---------------------------
    
repeat
Sleep 1000;
if (checkPlayers() ~= nil) then
ShowToClient("BOT", checkPlayers());
PlaySound(GetDir() .. "alarm.wav"); -- Play sound
end;
until false;
