-- MenuButton.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 11/29/2019, 2:59:16 PM

---- LUA
local pairs = pairs

---- WOW
local CreateFrame = CreateFrame
local CloseDropDownMenus = CloseDropDownMenus
local ToggleDropDownMenu = ToggleDropDownMenu
local EasyMenu_Initialize = EasyMenu_Initialize

---- UI
local DropDownList1 = DropDownList1
local UIParent = UIParent

---@type ns
local ns = select(2, ...)

---@class tdBag2MenuButton: Button
---@field private EnterBlocker Frame
local MenuButton = ns.Addon:NewClass('UI.MenuButton', 'Button')
MenuButton.GenerateName = ns.NameGenerator('tdBag2DropMenu')

function MenuButton:ToggleMenu()
    if self:IsMenuOpened() then
        CloseDropDownMenus(1)
    else
        ToggleDropDownMenu(1, nil, self:GetDropMenu(), self, 0, 0, self:CreateMenu())
        self:OnMenuOpened()
    end
end

function MenuButton:CloseMenu()
    if self:IsMenuOpened() then
        CloseDropDownMenus(1)
    end
end

function MenuButton:IsMenuOpened()
    return self.DropMenu and UIDROPDOWNMENU_OPEN_MENU == self.DropMenu and DropDownList1:IsShown()
end

function MenuButton:GetDropMenu()
    if not self.DropMenu then
        local frame = CreateFrame('Frame', self:GenerateName(), UIParent, 'UIDropDownMenuTemplate')
        frame.displayMode = 'MENU'
        frame.initialize = EasyMenu_Initialize
        frame.onHide = function(id)
            if id <= 2 then
                self:OnMenuClosed()
            end
        end

        if self.menuOffset then
            for k, v in pairs(self.menuOffset) do
                frame[k] = v
            end
        end

        self:GetType().DropMenu = frame
    end
    return self.DropMenu
end

local function OnEnter(self)
    self:GetParent():LockHighlight()
end

local function OnLeave(self)
    self:GetParent():UnlockHighlight()
end

function MenuButton:OnMenuOpened()
    if not self.EnterBlocker then
        self.EnterBlocker = CreateFrame('Frame', nil, self)
        self.EnterBlocker:Hide()
        self.EnterBlocker:SetAllPoints(true)
        self.EnterBlocker:SetFrameLevel(self:GetFrameLevel() + 10)
        self.EnterBlocker:SetScript('OnEnter', OnEnter)
        self.EnterBlocker:SetScript('OnLeave', OnLeave)
        self.EnterBlocker:SetMouseClickEnabled(false)
    end
    self.EnterBlocker:Show()
end

function MenuButton:OnMenuClosed()
    if self.EnterBlocker then
        self.EnterBlocker:Hide()
    end
end
