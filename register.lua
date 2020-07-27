--
-- Mod: AutoDrive
--
-- Author: Stephan
-- Email: Stephan910@web.de
-- Date: 02.02.2019
-- Version: 1.0.0.0

-- #############################################################################

TestModRegister = {}
TestModRegister.version = g_modManager:getModByName(g_currentModName).version

source(Utils.getFilename("scripts/TestMod.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/Gui/Settings.lua", g_currentModDirectory))
source(Utils.getFilename("scripts/Gui/TestSettingsPage.lua", g_currentModDirectory))

if g_specializationManager:getSpecializationByName("TestMod") == nil then
	g_specializationManager:addSpecialization("TestMod", "TestMod", Utils.getFilename("scripts/TestMod.lua", g_currentModDirectory), nil)

	if TestMod == nil then
		g_logManager:error("[TestMod] Unable to add specialization 'TestMod'")
		return
	end

	local TestModSpec = g_currentModName .. ".TestMod"

	for vehicleType, typeDef in pairs(g_vehicleTypeManager.vehicleTypes) do
		if typeDef ~= nil and vehicleType ~= "locomotive" then
			if TestMod.prerequisitesPresent(typeDef.specializations) then
				g_logManager:info('[TestMod] Attached to vehicleType "%s"', vehicleType)
				if typeDef.specializationsByName["TestMod"] == nil then
					g_vehicleTypeManager:addSpecialization(vehicleType, TestModSpec)
					typeDef.hasTestSettingSpec = true
				end
			end
		end
	end
end

function TestModRegister:loadMap(name)
	g_logManager:info("[TestMod] Loaded mod version %s", self.version)
end

addModEventListener(TestModRegister)