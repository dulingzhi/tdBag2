-- Inventory.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 10/25/2019, 1:56:22 AM

local ipairs = ipairs

---@type ns
local ns = select(2, ...)
local ContainerFrame = ns.UI.ContainerFrame

---@class tdBag2Inventory: tdBag2ContainerFrame
local Inventory = ns.Addon:NewClass('UI.Inventory', ContainerFrame)

local MAIN_MENU_BUTTONS = {
    MainMenuBarBackpackButton, --
    CharacterBag0Slot, --
    CharacterBag1Slot, --
    CharacterBag2Slot, --
    CharacterBag3Slot, --
}

local function SetChecked(self)
    return self:RawSetChecked(ns.Addon:IsFrameShown(ns.BAG_ID.BAG))
end

for i, v in ipairs(MAIN_MENU_BUTTONS) do
    v.RawSetChecked = v.SetChecked
    v.SetChecked = SetChecked
end

function Inventory:OnShow()
    ContainerFrame.OnShow(self)

    self:HighlightMainMenu(true)
end

function Inventory:OnHide()
    ContainerFrame.OnHide(self)

    self:HighlightMainMenu(false)
end

function Inventory:HighlightMainMenu(flag)
    for _, button in ipairs(MAIN_MENU_BUTTONS) do
        button:RawSetChecked(flag)
    end
end
