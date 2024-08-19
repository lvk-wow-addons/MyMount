MyMount_FlyingMounts = {
    ["Cabbot/Discipline"] = "Twilight Drake",
    ["Cabbot/Holy"] = "Albino Drake",
    ["Cabbot/Shadow"] = "Twilight Drake",

    ["Mage"] = {"Archmage's Prismatic Disc"},
    ["Praxis"] = "Twilight Drake",
    ["Cabbeth"] = "Winged Steed of the Ebon Blade",
    ["Phimi/Restoration"] = "Hearthsteed",
    ["Aerie Peak/Cabboth"] = { "High Priest's Lightsworn Seeker" },
    ["Kazzak/Cabboth"] = "Twilight Drake",
    ["Death Knight"] = "Amalgam of Rage",

    ["default"] = {"Twilight Drake", "Black Drake", "Headless Horseman's Mount", "Violet Spellwing"},
}

MyMount_GroundMounts = {
    -- ["Cabbot/Discipline"] = "",
    ["Cabbot/Holy"] = "Swift White Ram",
    -- ["Cabbot/Shadow"] = "",

    ["Mage"] = "Archmage's Prismatic Disc",

    ["Praxis"] = "Felsaber",
    ["Cabbeth"] = "Acherus Deathcharger",
    ["Phimi/Restoration"] = "Hearthsteed",
    ["Cabboth"] = "High Priest's Lightsworn Seeker",

    ["Kazzak/Cabboth"] = "Black Skeletal Horse",
    ["Death Knight"] = "Acherus Deathcharger",

    ["default"] = {"Headless Horseman's Mount", "Hearthsteed"},
}

MyMount_DragonFlightMounts = {
    ["default"] = "Cliffside Wylderdrake"
}

MyMount_Friends = {
    "Starblade",
    "kithkin",
    "Kristian Dovik",
    "Dionarys",
    "Darionarys",
    "Éärwen"
}

function MyMount_DoIt()
	if IsMounted() then
		Dismount()
		return
    end

    if IsSwimming() and IsAltKeyDown() then
        if IsShiftKeyDown() then
            if MyMount_TrySummonMount("Azure Water Strider") then
                return
            end
        end
        if MyMount_TrySummonMount("Subdued Seahorse") then
            return
        end
    end

    if IsAltKeyDown() then
        if IsShiftKeyDown() then
            if MyMount_TrySummonMount("Traveler's Tundra Mammoth") then
                return
            end
        end

        if MyMount_TrySummonMount("Grand Expedition Yak") then
            return
        end
    end
    
    -- local lib = LibStub("LibFlyable")
    local isFlyable = IsFlyableArea()
    if isFlyable and (UnitLevel("player") >= 30) then
        if IsShiftKeyDown() then
            if MyMount_TrySummonMount(MyMount_GetMount(MyMount_GroundMounts)) then
                return
            end
        else
            if MyMount_TrySummonMount(MyMount_GetMount(MyMount_FlyingMounts)) then
                return
            end
        end

        if MyMount_TrySummonMount(MyMount_GetMount(MyMount_FlyingMounts)) then
            return
        end
    end
    
    if (IsShiftKeyDown()) then
        if C_Spell.IsSpellUsable(368896) then
            if MyMount_TrySummonMount(MyMount_GetMount(MyMount_GroundMounts)) then
                return
            end
            if MyMount_TrySummonMount(MyMount_GetMount(MyMount_DragonFlightMounts)) then
                return
            end
        end
        if MyMount_TrySummonMount(MyMount_GetMount(MyMount_FlyingMounts)) then
            return
        end
    end
    if C_Spell.IsSpellUsable(368896) then
        if MyMount_TrySummonMount(MyMount_GetMount(MyMount_DragonFlightMounts)) then
            return
        end
    end

    if MyMount_TrySummonMount(MyMount_GetMount(MyMount_GroundMounts)) then
        return
    end
end

function MyMount_GetKeys()
    local class = UnitClass("player")
    local realm = GetRealmName()
    local name = UnitName("player")
    local faction = UnitFactionGroup("player")
    local spec = GetSpecialization()
    local id, specName, description, icon, background, role = GetSpecializationInfo(spec)

    return {
        realm .. "/" .. faction .. "/" .. class .. "/" .. name .. "/" .. specName,
        realm .. "/" .. faction .. "/" .. class .. "/" .. name,
        realm .. "/" .. faction .. "/" .. class .. "/" .. specName,
        realm .. "/" .. faction .. "/" .. class,
        realm .. "/" .. faction .. "/" .. name .. "/" .. specName,
        realm .. "/" .. faction .. "/" .. name,
        realm .. "/" .. faction .. "/" .. specName,
        realm .. "/" .. faction,
        realm .. "/" .. class .. "/" .. name .. "/" .. specName,
        realm .. "/" .. class .. "/" .. name,
        realm .. "/" .. class .. "/" .. specName,
        realm .. "/" .. class,
        realm .. "/" .. name .. "/" .. specName,
        realm .. "/" .. name,
        realm .. "/" .. specName,
        realm,
        faction .. "/" .. class .. "/" .. name .. "/" .. specName,
        faction .. "/" .. class .. "/" .. name,
        faction .. "/" .. class .. "/" .. specName,
        faction .. "/" .. class,
        faction .. "/" .. name .. "/" .. specName,
        faction .. "/" .. name,
        faction .. "/" .. specName,
        faction,
        class .. "/" .. name .. "/" .. specName,
        class .. "/" .. name,
        class .. "/" .. specName,
        class,
        name .. "/" .. specName,
        name,
        specName,
        "default"
    }
end

function MyMount_GetMount(mounts)
    if IsControlKeyDown() then
        return "Sandstone Drake"
    end

    if MyMount_InPartyWithFriend() then
        return "Sandstone Drake"
    end

    local keys = MyMount_GetKeys()
	for i=1,#keys do
        local key = keys[i]
        local mount = mounts[key]
        if type(mount) == "table" then
            mount = mount[math.random(#mount)]
        end
        
        if mount then
            LVK:Debug("|g|" .. key .. "|<| = |g|" .. mount)
            return mount
        end
    end
end

function MyMount_IsFriend(name)
    for index, value in ipairs(MyMount_Friends) do
        if value == name then
            return true
        end
    end

    return false
end

function MyMount_InPartyWithFriend()
    if UnitExists("party1") and MyMount_IsFriend(GetUnitName("party1")) then
        return true
    end
    if UnitExists("party2") and MyMount_IsFriend(GetUnitName("party2")) then
        return true
    end
    if UnitExists("party3") and MyMount_IsFriend(GetUnitName("party3")) then
        return true
    end
    if UnitExists("party4") and MyMount_IsFriend(GetUnitName("party4")) then
        return true
    end
    return false
end

function MyMount_TrySummonMount(mounts)
    if type(mounts) == "string" then
        return MyMount_TrySummonMountByName(mounts)
    end

    return MyMount_TrySummonMountByName(mounts[math.random(#mounts)])
end

function MyMount_TrySummonMountByName(name)
	local mounts = C_MountJournal.GetMountIDs()
	for i=1,#mounts do
		local creatureName, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mounts[i])
		if isUsable then
			-- LVK:Debug("Mount #" .. tostring(i) .. ": " .. creatureName)
			if creatureName == name then
				C_MountJournal.SummonByID(mounts[i])
				return true
			end
		end
	end
	
	return false
end

LVK:AnnounceAddon("MyMount");