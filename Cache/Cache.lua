-- Cache.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 1/1/2020, 12:22:38 AM

---@type ns
local ns = select(2, ...)
local Forever = ns.Forever
local Current = ns.Current
local GlobalSearch = ns.GlobalSearch

---@class tdBag2CacheOwnerData
---@field name string
---@field realm string
---@field faction string
---@field class string
---@field race string
---@field gender number
---@field cached boolean
---@field money number

---@class tdBag2CacheBagData
---@field slot number
---@field owned boolean
---@field cached boolean
---@field count number
---@field free number
---@field family number
---@field cost number
---@field link string
---@field icon string
---@field id number
---@field title string

---@class tdBag2CacheItemData
---@field link string
---@field count number
---@field cached boolean
---@field icon string
---@field locked boolean
---@field quality number
---@field id number
---@field readable boolean
---@field timeout number

---@class tdBag2Cache
local Cache = {}
ns.Cache = Cache

local GLOBAL_SEARCH_OWNER = ns.GLOBAL_SEARCH_OWNER
local CACHED_EMPTY = {cached = true}

function Cache:GetOwnerAddress(owner)
    return ns.REALM, owner or ns.PLAYER, owner == GLOBAL_SEARCH_OWNER
end

function Cache:GetOwnerInfo(owner)
    local realm, name, isGlobalSearch = self:GetOwnerAddress(owner)
    if isGlobalSearch then
        return CACHED_EMPTY
    elseif self:IsOwnerCached(realm, name) then
        return Forever:GetOwnerInfo(realm, name)
    else
        return Current:GetOwnerInfo()
    end
end

function Cache:GetBagInfo(owner, bag)
    local realm, name, isGlobalSearch = self:GetOwnerAddress(owner)
    if isGlobalSearch then
        return GlobalSearch:GetBagInfo(bag)
    elseif self:IsBagCached(realm, name, bag) then
        return Forever:GetBagInfo(realm, name, bag)
    else
        return Current:GetBagInfo(bag)
    end
end

function Cache:GetItemInfo(owner, bag, slot)
    local realm, name, isGlobalSearch = self:GetOwnerAddress(owner)
    if isGlobalSearch then
        return GlobalSearch:GetItemInfo(bag, slot)
    elseif self:IsBagCached(realm, name, bag) then
        return Forever:GetItemInfo(realm, name, bag, slot)
    else
        return Current:GetItemInfo(bag, slot)
    end
end

function Cache:IsOwnerCached(realm, name)
    return realm ~= ns.REALM or name ~= ns.PLAYER
end

function Cache:IsBagCached(realm, name, bag)
    if self:IsOwnerCached(realm, name) then
        return true
    end

    if ns.IsInBank(bag) then
        return not Forever.atBank
    end

    return not ns.IsContainerBag(bag)
end

function Cache:GetItemID(owner, bag, slot)
    local info = self:GetItemInfo(owner, bag, slot)
    return info and info.id
end

function Cache:IsOwnerBagCached(owner, bag)
    local realm, name = self:GetOwnerAddress(owner)
    return self:IsBagCached(realm, name, bag)
end

function Cache:GetOwners()
    return Forever:GetOwners()
end

function Cache:HasMultiOwners()
    return Forever:HasMultiOwners()
end

function Cache:DeleteOwnerInfo(owner)
    return Forever:DeleteOwnerInfo(self:GetOwnerAddress(owner))
end
