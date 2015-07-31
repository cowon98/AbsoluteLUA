gapCloseList = {
       ['Ahri']        = {true, spell = 'AhriTumble'},
        ['Aatrox']      = {true, spell = 'AatroxQ'},
        ['Akali']       = {true, spell = 'AkaliShadowDance'},
        ['Alistar']     = {true, spell = 'Headbutt'}, 
        ['Diana']       = {true, spell = 'DianaTeleport'}, 
        ['Gragas']      = {true, spell = 'GragasE'},
        ['Graves']      = {true, spell = 'GravesMove'},
        ['Hecarim']     = {true, spell = 'HecarimUlt'},
        ['Irelia']      = {true, spell = 'IreliaGatotsu'}, 
        ['JarvanIV']    = {true, spell = 'JarvanIVDragonStrike'}, 
        ['Jax']         = {true, spell = 'JaxLeapStrike'}, 
        ['Jayce']       = {true, spell = 'JayceToTheSkies'}, 
    ['Katarina']   = {true, spell = 'KatarinaE'},
        ['Khazix']      = {true, spell = 'KhazixW'},
        ['Leblanc']     = {true, spell = 'LeblancSlide'},
        ['LeeSin']      = {true, spell = 'blindmonkqtwo'},
        ['Leona']       = {true, spell = 'LeonaZenithBlade'},
        ['Malphite']    = {true, spell = 'UFSlash'},
        ['Maokai']      = {true, spell = 'MaokaiTrunkLine',},   
    ['MasterYi']  =  {true, spell = 'AlphaStrike',}, 
        ['MonkeyKing']  = {true, spell = 'MonkeyKingNimbus'}, 
        ['Pantheon']    = {true, spell = 'PantheonW'}, 
        ['Pantheon']    = {true, spell = 'PantheonRJump'},
        ['Pantheon']    = {true, spell = 'PantheonRFall' },
        ['Poppy']       = {true, spell = 'PoppyHeroicCharge'},
        --['Quinn']       = {true, spell = 'QuinnE',                  range = 725,   projSpeed = 2000, }, 
        ['Renekton']    = {true, spell = 'RenektonSliceAndDice'},
        ['Sejuani']     = {true, spell = 'SejuaniArcticAssault'},
        ['Shen']        = {true, spell = 'ShenShadowDash'},
        ['Tristana']    = {true, spell = 'RocketJump'},
        ['Tryndamere']  = {true, spell = 'Slash'},
        ['XinZhao']     = {true, spell = 'XenZhaoSweep'}, -- Targeted ability
}

champsToStun = {
                { charName = "Katarina",        spellName = "KatarinaR" ,                  important = 0},
                { charName = "Galio",           spellName = "GalioIdolOfDurand" ,          important = 0},
                { charName = "FiddleSticks",    spellName = "Crowstorm" ,                  important = 1},
                { charName = "FiddleSticks",    spellName = "DrainChannel" ,               important = 1},
                { charName = "Nunu",            spellName = "AbsoluteZero" ,               important = 0},
                { charName = "Shen",            spellName = "ShenStandUnited" ,            important = 0},
                { charName = "Urgot",           spellName = "UrgotSwap2" ,                 important = 0},
                { charName = "Malzahar",        spellName = "AlZaharNetherGrasp" ,         important = 0},
                { charName = "Karthus",         spellName = "FallenOne" ,                  important = 0},
                { charName = "Pantheon",        spellName = "PantheonRJump" ,              important = 0},
        {  charName = "Pantheon",        spellName = "PantheonRFall",               important = 0},
                { charName = "Varus",           spellName = "VarusQ" ,                     important = 1},
                { charName = "Caitlyn",         spellName = "CaitlynAceintheHole" ,        important = 1},
                { charName = "MissFortune",     spellName = "MissFortuneBulletTime" ,      important = 1},
                { charName = "Warwick",         spellName = "InfiniteDuress" ,             important = 0}
}

OnLoop(function()
if KeyIsDown(0x20) then
  PrintChat ("loaded")
  combo()
end

end)

local qrange=600
local wrange=625
local erange=1040
local rrange=700
local target=GetCurentTarget(900, DAMAGE_MAGIC)

function combo()

if ValidTarget(target,1200) then
  if GetDistance(myHero(), target)<540 and CanUseSpell(myHero,_E) == READY  then
    local epred = GetPredictionForPlayer(GetMyHeroPos(),Target,GetMoveSpeed(Target),50,250,1500,80,false,false) 
    CastSkillShot(_E, eprediction.PredPos.x, eprediction.PredPos.y, eprediction.PredPos.z)
  elseif IsInDistance(target, erange) then
    local start = Vector(myHero) - 530 * (Vector(myHero) - Vector(target)):normalized()
    CastSkillShot(_E, start.PredPos.x, start.PredPos.y, start.PredPos.z)
  end
  if IsInDistance(target, qrange) and CanUseSpell(myHero,_Q) == READY then
    CastTargetSpell(target, _Q)
  end
  if IsInDistance(target, wrange) and CanUseSpell(myHero,_W) == READY then
    posw = GetPredictionForPlayer(GetMyHeroPos(),Target,GetMoveSpeed(Target),1750,500,625,300,false,false)
    if isFacing(target,myHero()) then
      pw = Vector(posw) - 150 * (Vector(posw) - Vector(ts.target)):normalized()
    else
    pw = Vector(posw) + 150 * (Vector(posw) - Vector(ts.target)):normalized()
    end
  CastSkillShot(_W,pw.PredPos.x,pw.PredPos.y,pw.PredPos.z)
  end
  
  if IsInDistance(target, _R) and CanUseSpell(myHero,_R) == READY then
    CastSkillShot(_R, GetOrigin(Target).x, GetOrigin(Target).y, GetOrigin(Target).z)
    controlR()
  end
    
end

function controlR(target)
  targetpos=GetOrigin(target)
  if  GetCastName(myHero,_Q) == "viktorchaosstormguide" then
    CastSkillShot(_R, targetpos.x,targetpos.y, targetpos.z)
  end
end

function face(target,myHero())
  local source=GetOrigin(myHero)
  local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
  local sourcePos = Vector(sourceo.x, source.z)
  sourceVector = (sourceVector-sourcePos):normalized()
  sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
  return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= or 90000
end
