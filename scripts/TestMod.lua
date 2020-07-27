TestMod = {}
TestMod.directory = g_currentModDirectory

g_autoDriveUIFilename = TestMod.directory .. "textures/GUI_Icons.dds"

TestMod.actions = {
	{"TMTestAction", true, 2}
}
TestMod.actionsToInputs = {
    TMTestAction = "input_testaction"
}

TestMod.inputsToIds = {}

TestMod.idsToInputs = {}


function TestMod.onActionCall(vehicle, actionName)
    local input = TestMod.actionsToInputs[actionName]
    if type(input) ~= "string" or input == "" then
        g_logManager:devError("[TestMod] Action '%s' = '%s'", actionName, input)
        return
    end

    TestMod:onInputCall(vehicle, input)
end

function TestMod:onInputCall(vehicle, input, sendEvent)
    local func = self[input]
    if type(func) ~= "function" then
        g_logManager:devError("[TestMod] Input '%s' = '%s'", input, type(func))
        return
    end

    if sendEvent == nil or sendEvent == true then
        local inputId = self.inputsToIds[input]
        if inputId ~= nil then
            -- nothing to do, multiplayer command
            return
        end
    end

    func(TestMod, vehicle)
end
function TestMod:load()
    for k, v in pairs(self.inputsToIds) do
        self.idsToInputs[v] = k
    end
end
function TestMod:loadMap()
    TestMod.gui = {}
	g_logManager:info("[TestMod] Created Settings Instance")
    TestMod.gui.TestSettings = TestSettings:new()
    
	g_logManager:info("[TestMod] Created Settings Page Instance")
    TestMod.gui.TestSettingsPage = TestSettingsPage:new()
    
	g_logManager:info("[TestMod] Loading Settings Page")
    g_gui:loadGui(TestMod.directory .. "gui/settingsPage.xml", "TestSettingsPage", TestMod.gui.TestSettingsPage, true)
    
	g_logManager:info("[TestMod] Loading Settings gui")
    g_gui:loadGui(TestMod.directory .. "gui/settings.xml", "TestSettings", TestMod.gui.TestSettings)
    
	g_logManager:info("[TestMod] Mapping actions")
    TestMod:load()
    
	g_logManager:info("[TestMod] Finished loading Map")
end

function TestMod:input_testaction()
	if TestMod.gui.TestSettings.isOpen then
		TestMod.gui.TestSettings:onClickBack()
	elseif g_gui.currentGui == nil then
		g_gui:showGui("TestSettings")
	end
end
function TestMod.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(Motorized, specializations) and SpecializationUtil.hasSpecialization(Drivable, specializations) and SpecializationUtil.hasSpecialization(Enterable, specializations)
end

function TestMod:onRegisterActionEvents(_, isOnActiveVehicle)
    local registerEvents = isOnActiveVehicle
    if self.ad ~= nil then
        registerEvents = registerEvents or self == g_currentMission.controlledVehicle
    end

    -- only in active vehicle
    if registerEvents then
        -- attach our actions
        local _, eventName
        local toggleButton = false
        local showF1Help = true -- TestMod.getSetting("showHelp")
        for _, action in pairs(TestMod.actions) do
            _, eventName = InputBinding.registerActionEvent(g_inputBinding, action[1], self, TestMod.onActionCall, toggleButton, true, false, true)
            g_inputBinding:setActionEventTextVisibility(eventName, action[2] and showF1Help)
            if showF1Help then
                g_inputBinding:setActionEventTextPriority(eventName, action[3])
            end
        end
    end
end


function TestMod:onLoad(savegame)
    -- This will run before initial MP sync
    self.ad = {}
end

function TestMod:onPostLoad(savegame)
    -- This will run before initial MP sync
    --print("Running post load for vehicle: " .. self:getName())
end

function TestMod.registerEventListeners(vehicleType)
    for _, n in pairs({"onRegisterActionEvents"}) do
        SpecializationUtil.registerEventListener(vehicleType, n, TestMod)
    end
end
addModEventListener(TestMod)
