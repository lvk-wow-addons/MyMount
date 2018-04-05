MyMount_FlyingMounts = {
    ["Cabbot/Discipline"] = "Twilight Drake",
    ["Cabbot/Holy"] = "Albino Drake",
    ["Cabbot/Shadow"] = "Twilight Drake",

    ["Arxas/Fire"] = "Bronze Drake",
    ["Arxas/Frost"] = "Twilight Drake",
    ["Praxis"] = "Twilight Drake",
    ["Cabbeth"] = "Winged Steed of the Ebon Blade",

    ["default"] = "Twilight Drake",
}

MyMount_GroundMounts = {
    -- ["Cabbot/Discipline"] = "",
    ["Cabbot/Holy"] = "Swift White Ram",
    -- ["Cabbot/Shadow"] = "",

    ["Arxas"] = "Llothien Prowler",

    ["Praxis"] = "Felsaber",
    ["Cabbeth"] = "Acherus Deathcharger",

    ["default"] = "Headless Horseman's Mount",
}

function MyMount_ChatPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[MyMount] "..str, 0.25, 1.0, 0.25)
end

function MyMount_ErrorPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[MyMount] "..str, 1.0, 0.5, 0.5)
end

function MyMount_DebugPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[MyMount] "..str, 0.75, 1.0, 0.25)
end

function MyMount_DoIt()
	if IsMounted() then
		Dismount()
		return
	end

    if IsAltKeyDown() then
        if MyMount_TrySummonMount("Grand Expedition Yak") then
            return
        end
    end

    if IsSwimming() then
        if not IsControlKeyDown() then
            if MyMount_TrySummonMount("Subdued Seahorse") then
                return
            end
        end
    end

    local lib = LibStub("LibFlyable")
    local isFlyable = lib:IsFlyableArea()
    if isFlyable then
        if IsShiftKeyDown() then
            if MyMount_TrySummonMount(MyMount_GetGroundMount()) then
                return
            end
        else
            if MyMount_TrySummonMount(MyMount_GetFlyingMount()) then
                return
            end
        end

        if MyMount_TrySummonMount(MyMount_GetFlyingMount()) then
            return
        end
    end
    
    if (IsShiftKeyDown()) then
        if MyMount_TrySummonMount(MyMount_GetFlyingMount()) then
            return
        end
    end

    if MyMount_TrySummonMount(MyMount_GetGroundMount()) then
        return
    end
end

function MyMount_GetKey()
    local spec = GetSpecialization()
    local id, name, description, icon, background, role = GetSpecializationInfo(spec)

    return UnitName("player") .. "/" .. name
end

function MyMount_GetKey()
    local name = UnitName("player")
    local spec = GetSpecialization()
    local id, specName, description, icon, background, role = GetSpecializationInfo(spec)

    local key = name .. "/" .. specName

    return key
end

function MyMount_GetGroundMount()
    if IsControlKeyDown() then
        return "Sandstone Drake"
    end

    local key = MyMount_GetKey()
    return MyMount_GroundMounts[key] or MyMount_GroundMounts[UnitName("player")] or MyMount_GroundMounts["default"]
end

function MyMount_IsFriend(name)
    if name == "Dionarys" then
        return true
    end
    if name == "Darionarys" then
        return true
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

function MyMount_GetFlyingMount()
    if IsInGroup() or IsInRaid() or IsControlKeyDown() then
        return "Sandstone Drake"
    end

    if MyMount_InPartyWithFriend() then
        return "Sandstone Drake"
    end

    local key = MyMount_GetKey()
    return MyMount_FlyingMounts[key] or MyMount_FlyingMounts[UnitName("player")] or MyMount_FlyingMounts["default"]
end

function MyMount_TrySummonMount(name)
	local mounts = C_MountJournal.GetMountIDs()
	for i=1,#mounts do
		local creatureName, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mounts[i])
		if isUsable then
			-- MyMount_DebugPrint("Mount #" .. tostring(i) .. ": " .. creatureName)
			if creatureName == name then
				C_MountJournal.SummonByID(mounts[i])
				return true
			end
		end
	end
	
	return false
end