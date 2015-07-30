--[[
       ♛ Absolute Kassadin ♛
            Author : Ken
           29 - 07 - 2015
]]

pcall( require, GetObjectName(GetMyHero()) )

Menu = scriptConfig("AbsoluteK", "Absolute Kassadin")
    Menu.addParam("HQ", "Use E in Harrass", SCRIPT_PARAM_ONOFF, true)
    Menu.addParam("HE", "Use E in Harrass", SCRIPT_PARAM_ONOFF, true)
    Menu.addParam("Skill", "Use Skill to LastHit", SCRIPT_PARAM_ONOFF, true)
    Menu.addParam("FQ", "Use Q to LastHit", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("FW", "Use W to LastHit", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("Q", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("W", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("E", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("R", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("Harrass", "Harrass", SCRIPT_PARAM_KEYDOWN, string.byte("V"), false)
	Menu.addParam("THarrass", "Toggle Harrass", SCRIPT_PARAM_ONOFF, true)
	Menu.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))

PrintChat("<font color='#C1073F'>Absolute</font> <font color='#C5C4E6'>Kassadin</font> <font color='#525162'>:</font> <font color='#ECE6FE'>loaded.</font>")

minionTable = {}
local myHero = GetMyHero()
local maxmana = GetMaxMana(myHero)
local manadmg = maxmana/100*3
local lvl = GetLevel(myHero)
local ad = GetBaseDamage(myHero)
local bap = GetBonusAP(myHero) -- 비에이피 Best Absolute Perfect
local maxRiftwalkStacks = 4
local ultStacks = 0
local lastUlt = 0
local os_clock = GetTickCount()
local clQ = GetCastLevel(myHero,_Q)
local clW = GetCastLevel(myHero,_W)
local clR = GetCastLevel(myHero,_R)
Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))

-- Skill Damage

spellDmg =  
	{
	[_Q] = {dmg = function () return 70 + 15*clQ + 0.7*bap(myHero) end, },
	[_W] = {dmg = function () return 40 + 25*clW + ad + 0.6*bap(myHero)  end, },
	--[_E] = {dmg = function () return 90 + 25*clE + 0.7*bap(myHero) end, },
	--[_R] = {dmg = function () return 80 + 20*clR + manadmg + 30 + 10*ultStacks end, },
	}

OnLoop(function(myHero)
	myHeroPos = GetOrigin(myHero)
	local target = GetCurrentTarget()

-- RiftStacks Buff

    function OnCreateObj(obj)
        if obj ~= nil and string.find(obj.name, "Riftwalk_Flashback") then
                                lastUlt = os_clock
                                ultStacks = ultStacks + 1
                        end
        end
    end

--RiftStacks Count Update

    function updateUltStacks()
        if ultStacks ~= 0 and GetTickCount() > lastUlt + 8200 then
                ultStacks = 0
        end
    end

-- © Inspired for minion functions

    function GetAllMinions(team)
    local result = {}
    for _,k in pairs(minionTable) do
        if k and not IsDead(k) then
            if not team or GetTeam(k) == team then
                result[_] = k
            end
        else
            minionTable[_] = nil
        end
    end
    return result
    end

    function GetLowestMinion(pos, range, team)
        local minion = nil
        for k,v in pairs(GetAllMinions()) do 
            local objTeam = GetTeam(v)
            if not minion and v and objTeam == team and GetDistanceSqr(GetOrigin(v),pos) < range*range then minion = v end
                if minion and v and objTeam == team and GetDistanceSqr(GetOrigin(v),pos) < range*range and GetCurrentHP(v) < GetCurrentHP(minion) then
                   minion = v
                end
            end
        return minion
    end

-- Skill LastHit

    if Menu.Skill and not Menu.Combo then
    	local 
    	if CanUseSpell(myHero, _Q) == READY and Menu.FQ then
    		if (GetCurrentHP(v)+1 <= spellDmg[_Q].dmg(), GetOrigin(v) > range) then
    			CastTargetSpell((v), _Q)
    		end
    	end

    	if CanUseSpell(myHero, _W) == READY and Menu.FW then
    		if (GetCurrentHP(v)+1 <= spellDmg[_W].dmg(), GetOrigin(v) > range)
    			CastTargetSpell(myHero,_W)
                DelayAction(function() AttackUnit end)
            end
        end
    end

-- Harrass
    	
    if Menu.Harrass or Menu.THarrass then

    	if CanUseSpell(myHero, _Q) == READY and Menu.HQ then
			if ValidTarget(target, GetCastRange(myHero, _Q)) then
				CastTargetSpell(target, _Q)
			end

		if CanUseSpell(myHero, _E) == READY and Menu.HE then
			if ValidTarget(target, GetCastRange(myHero, _E-10)) then 
				local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target), 1500, 0, GetCastRange(myHero, _E), 145, true, true)				
				if EPred.HitChance == 1 then
					CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
				end
			end
		end
	end

-- Combo

	if Menu.Combo then

				if CanUseSpell(myHero, _R) == READY and Menu.R then
			if ValidTarget(target, GetCastRange(myHero, _R)) then
				local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target), 1500, 0, GetCastRange(myHero, _R), 490, false, false)
				if RPred.HitChance == 1 then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
			end
		end
	
	    	if CanUseSpell(myHero, _Q) == READY and Menu.Q then
			if ValidTarget(target, GetCastRange(myHero, _Q)) then
				CastTargetSpell(target, _Q)
			end
		    end
		
		 if  CanUseSpell(myHero, _W) == READY and IsInDistance(target, 195) and Menu.W then
		 	DelayAction(function() AttackUnit end)
                        CastTargetSpell(myHero,_W)
            DelayAction(function() AttackUnit end)
         end
		
		if CanUseSpell(myHero, _E) == READY and Menu.E then
			if ValidTarget(target, GetCastRange(myHero, _E-10)) then 
				local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target), 1500, 0, GetCastRange(myHero, _E), 145, true, true)				
				if EPred.HitChance == 1 then
					CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
				end
			end
		end
	end
end
end)
