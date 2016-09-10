function SD_CAVITYSEARCH_ON_INIT(addon, frame)
  if SD_CAVITYSEARCH_LOADED then
    return
  end
  
  _G['SD_OLD_SET_EQUIP_SLOT_BY_SPOT'] = SET_EQUIP_SLOT_BY_SPOT
  _G['SET_EQUIP_SLOT_BY_SPOT'] = SD_SET_EQUIP_SLOT_BY_SPOT
  
  ui.SysMsg('-> sd_cavitysearch');
  
  SD_CAVITYSEARCH_LOADED = true
end

function SD_GET_ITEM_LINK(invitem)
  local itemobj = GetIES(invitem:GetObject());

  local imgtag =  "";
  local imageName = GET_ITEM_ICON_IMAGE(itemobj);
  
  local imgtag = string.format("{img %s %d %d}", imageName, 32, 32);

  local properties = "";

  local itemName = GET_FULL_NAME(itemobj);

  if itemobj.ClassName == 'Scroll_SkillItem' then   
    local sklCls = GetClassByType("Skill", itemobj.SkillType)
    itemName = itemName .. "(" .. sklCls.Name ..")";
    properties = GetSkillItemProperiesString(itemobj);
  else
    properties = GetModifiedProperiesString(itemobj);
  end

  if properties == "" then
    properties = 'nullval'
  end
  
  local itemrank_num = itemobj.ItemStar

  local linkstr = string.format("{a SLI %s %d}{#0000FF}%s%s{/}{/}{/}", properties, itemobj.ClassID, imgtag, itemName);
  
  return linkstr;
end

function SD_SET_EQUIP_SLOT_BY_SPOT(frame, equipItem, eqpItemList, iconFunc, ...)
  SD_OLD_SET_EQUIP_SLOT_BY_SPOT(frame, equipItem, eqpItemList, iconFunc, ...)
  
  local spotName = item.GetEquipSpotName(equipItem.equipSpot);
  
  if spotName ~= nil then
    if frame:GetChild(spotName) == nil and item.GetNoneItem(equipItem.equipSpot) ~= equipItem.type and equipItem.equipSpot ~= 21 then
      ui.SysMsg(string.format("Invalid Slot (%d:%s): %s", equipItem.equipSpot, spotName, SD_GET_ITEM_LINK(equipItem)))
    end
  end
end
