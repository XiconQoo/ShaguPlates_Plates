-- load ShaguPlates environment
setfenv(1, ShaguPlates:GetEnvironment())

--[[ libtooltip ]]--
-- A ShaguPlates library that provides additional GameTooltip information.
--
--  libtooltip:GetItemID()
--    returns the itemID of the current GameTooltip
--    `nil` when no item is displayed
--
--  libtooltip:GetItemLink()
--    returns the itemLink of the current GameTooltip
--    `nil` when no item is displayed
--
--  libtooltip:GetItemCount()
--    returns the item count (bags) of the current GameTooltip
--    `nil` when no item is displayed

-- return instantly when another libtooltip is already active
if ShaguPlates.api.libtooltip then return end

local _
local libtooltip = CreateFrame("Frame" , "pfLibTooltip", GameTooltip)
libtooltip:SetScript("OnHide", function()
  this.itemID = nil
  this.itemLink = nil
  this.itemCount = nil
end)

-- core functions
libtooltip.GetItemID = function(self)
  if not libtooltip.itemLink then return end
  if not libtooltip.itemID then
    local _, _, itemID = string.find(libtooltip.itemLink, "item:(%d+):%d+:%d+:%d+")
    libtooltip.itemID = tonumber(itemID)
  end

  return libtooltip.itemID
end

libtooltip.GetItemLink = function(self)
  return libtooltip.itemLink
end

libtooltip.GetItemCount = function(self)
  return libtooltip.itemCount
end

ShaguPlates.api.libtooltip = libtooltip

-- setup item hooks
local pfHookSetBagItem = GameTooltip.SetBagItem
function GameTooltip.SetBagItem(self, container, slot)
  libtooltip.itemLink = GetContainerItemLink(container, slot)
  _, libtooltip.itemCount = GetContainerItemInfo(container, slot)
  return pfHookSetBagItem(self, container, slot)
end

local pfHookSetQuestLogItem = GameTooltip.SetQuestLogItem
function GameTooltip.SetQuestLogItem(self, itemType, index)
  libtooltip.itemLink = GetQuestLogItemLink(itemType, index)
  if not libtooltip.itemLink then return end
  return pfHookSetQuestLogItem(self, itemType, index)
end

local pfHookSetQuestItem = GameTooltip.SetQuestItem
function GameTooltip.SetQuestItem(self, itemType, index)
  libtooltip.itemLink = GetQuestItemLink(itemType, index)
  return pfHookSetQuestItem(self, itemType, index)
end

local pfHookSetLootItem = GameTooltip.SetLootItem
function GameTooltip.SetLootItem(self, slot)
  libtooltip.itemLink = GetLootSlotLink(slot)
  pfHookSetLootItem(self, slot)
end

local pfHookSetInboxItem = GameTooltip.SetInboxItem
function GameTooltip.SetInboxItem(self, mailID, attachmentIndex)
  local itemName, itemTexture, inboxItemCount, inboxItemQuality = GetInboxItem(mailID)
  libtooltip.itemLink = GetItemLinkByName(itemName)
  return pfHookSetInboxItem(self, mailID, attachmentIndex)
end

local pfHookSetInventoryItem = GameTooltip.SetInventoryItem
function GameTooltip.SetInventoryItem(self, unit, slot)
  libtooltip.itemLink = GetInventoryItemLink(unit, slot)
  return pfHookSetInventoryItem(self, unit, slot)
end

local pfHookSetLootRollItem = GameTooltip.SetLootRollItem
function GameTooltip.SetLootRollItem(self, id)
  libtooltip.itemLink = GetLootRollItemLink(id)
  return pfHookSetLootRollItem(self, id)
end

local pfHookSetLootRollItem = GameTooltip.SetLootRollItem
function GameTooltip.SetLootRollItem(self, id)
  libtooltip.itemLink = GetLootRollItemLink(id)
  return pfHookSetLootRollItem(self, id)
end

local pfHookSetMerchantItem = GameTooltip.SetMerchantItem
function GameTooltip.SetMerchantItem(self, merchantIndex)
  libtooltip.itemLink = GetMerchantItemLink(merchantIndex)
  return pfHookSetMerchantItem(self, merchantIndex)
end

local pfHookSetCraftItem = GameTooltip.SetCraftItem
function GameTooltip.SetCraftItem(self, skill, slot)
  libtooltip.itemLink = GetCraftReagentItemLink(skill, slot)
  return pfHookSetCraftItem(self, skill, slot)
end

local pfHookSetCraftSpell = GameTooltip.SetCraftSpell
function GameTooltip.SetCraftSpell(self, slot)
  libtooltip.itemLink = GetCraftItemLink(slot)
  return pfHookSetCraftSpell(self, slot)
end

local pfHookSetTradeSkillItem = GameTooltip.SetTradeSkillItem
function GameTooltip.SetTradeSkillItem(self, skillIndex, reagentIndex)
  if reagentIndex then
    libtooltip.itemLink = GetTradeSkillReagentItemLink(skillIndex, reagentIndex)
  else
    libtooltip.itemLink = GetTradeSkillItemLink(skillIndex)
  end
  return pfHookSetTradeSkillItem(self, skillIndex, reagentIndex)
end

local pfHookSetAuctionSellItem = GameTooltip.SetAuctionSellItem
function GameTooltip.SetAuctionSellItem(self)
  local itemName, _, itemCount = GetAuctionSellItemInfo()
  libtooltip.itemCount = itemCount
  libtooltip.itemLink = GetItemLinkByName(itemName)
  return pfHookSetAuctionSellItem(self)
end

local pfHookSetTradePlayerItem = GameTooltip.SetTradePlayerItem
function GameTooltip.SetTradePlayerItem(self, index)
  libtooltip.itemLink = GetTradePlayerItemLink(index)
  return pfHookSetTradePlayerItem(self, index)
end

local pfHookSetTradeTargetItem = GameTooltip.SetTradeTargetItem
function GameTooltip.SetTradeTargetItem(self, index)
  libtooltip.itemLink = GetTradeTargetItemLink(index)
  return pfHookSetTradeTargetItem(self, index)
end
