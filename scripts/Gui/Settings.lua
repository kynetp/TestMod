TestSettings = {}

local TestSettings_mt = Class(TestSettings, TabbedMenu)

TestSettings.CONTROLS = {"testSettingsPage"}
TestSettings.TAB_UV = {
    SETTINGS_GENERAL = {385, 0, 128, 128},
    SETTINGS_VEHICLE = {0, 209, 65, 65},
    SETTINGS_UNLOAD = {0, 0, 128, 128},
    SETTINGS_LOAD = {0, 129, 128, 128},
    SETTINGS_NAVIGATION = {0, 257, 128, 128},
    SETTINGS_DEBUG = {0, 128, 128, 128},
    SETTINGS_EXPFEAT = {128, 128, 128, 128}
}
function TestSettings:new()
    local o = TabbedMenu:new(nil, TestSettings_mt, g_messageCenter, g_i18n, g_gui.inputManager)
    o.returnScreenName = ""
    o:registerControls(TestSettings.CONTROLS)
    return o
end
function TestSettings:onClickBack()
    self:onClickBackDialogCallback(true)
end
function TestSettings:onClickBackDialogCallback(yes)
    if yes then
        TestSettings:superClass().onClickBack(self)
    end
end

function TestSettings:onClickBackDialogCallback(yes)
    if yes then
        TestSettings:superClass().onClickBack(self)
    end
end

function TestSettings:onGuiSetupFinished()
    TestSettings:superClass().onGuiSetupFinished(self)
    self:setupPages()
end

function TestSettings:setupPages()
    local alwaysEnabled = function()
        return true
    end

    local orderedPages = {
        {self.testSettingsPage, alwaysEnabled, g_autoDriveUIFilename, TestSettings.TAB_UV.SETTINGS_GENERAL, false},
    }

    for i, pageDef in ipairs(orderedPages) do
        g_logManager:info("[TestMod] Processing page %s", i)
        local page, predicate, uiFilename, iconUVs, isAutonomous = unpack(pageDef)
        local normalizedIconUVs = getNormalizedUVs(iconUVs)
        g_logManager:info("[TestMod] Registering Page %s", i)
        self:registerPage(page, i, predicate)
        self:addPageTab(page, uiFilename, normalizedIconUVs) -- use the global here because the value changes with resolution settings
        page.isAutonomous = isAutonomous
        page.headerIcon:setImageFilename(uiFilename)
        page.headerIcon:setImageUVs(nil, unpack(normalizedIconUVs))
        if page.setupMenuButtonInfo ~= nil then
            page:setupMenuButtonInfo(self)
        end
    end
end
--- Define default properties and retrieval collections for menu buttons.
function TestSettings:setupMenuButtonInfo()
    self.defaultMenuButtonInfo = {
        {inputAction = InputAction.MENU_BACK, text = self.l10n:getText("button_back"), callback = self:makeSelfCallback(self.onClickBack), showWhenPaused = true},
        {inputAction = InputAction.MENU_ACCEPT, text = self.l10n:getText("button_apply"), callback = self:makeSelfCallback(self.onClickOK), showWhenPaused = true}
    }
end

function TestSettings:onClickOK()
    TestSettings:superClass().onClickBack(self)
end

function TestSettings:onClickBack()
    self:onClickBackDialogCallback(true)
end

function TestSettings:onClickBackDialogCallback(yes)
    if yes then
        TestSettings:superClass().onClickBack(self)
    end
end

function TestSettings:onOpen()
    TestSettings:superClass().onOpen(self)
    self.inputDisableTime = 200
end
function TestSettings:onClose()
    TestSettings:superClass().onClose(self)
end