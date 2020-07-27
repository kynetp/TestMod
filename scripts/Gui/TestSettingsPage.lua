--
-- AutoDrive GUI
-- V1.0.0.0
--
-- @author Stephan Schlosser
-- @date 08/04/2019

TestSettingsPage = {}

local TestSettingsPage_mt = Class(TestSettingsPage, TabbedMenuFrameElement)

TestSettingsPage.CONTROLS = {"settingsContainer", "ingameMenuHelpBox", "headerIcon"}

function TestSettingsPage:new(target)
    local o = TabbedMenuFrameElement:new(target, TestSettingsPage_mt)
    o.returnScreenName = ""
    o.settingElements = {}
    o:registerControls(TestSettingsPage.CONTROLS)
    return o
end

function TestSettingsPage:onFrameOpen()
    TestSettingsPage:superClass().onFrameOpen(self)
end

function TestSettingsPage:onFrameClose()
    TestSettingsPage:superClass().onFrameClose(self)
end
