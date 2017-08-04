local _G = _G

-- muss komplett überarbeitet werden und ergänzt

local DropDown = {}
SmartAssign.DropDown = DropDown

local menuTable = {}
local line, data, submenu = nil, nil, nil
 
local function createMenuLine(data)
  local line = {}
  if not data then return line end
  line.text = data.text or nil
  line.isTitle = data.isTitle or nil
  line.notCheckable = data.notCheckable or nil
  line.notClickable = data.notClickable or nil
  line.keepShownOnClick = data.keepShownOnClick or nil
  line.hasArrow = data.hasArrow or nil 
  line.func = data.func or nil
  line.menuList = data.menuList or nil
  return line
end
 
local function createDelimLine()
  --split line
  local delim = "~~~~~~~~~~~~~~~~~~~~~~~"
  data = { text = delim, notCheckable = true, notClickable = true }
  line = createMenuLine(data)
  return line
end
 
function DropDown:createMenu(frame, name)
    local dropdown = CreateFrame("Frame", name, frame, "UIDropDownMenuTemplate")
    dropdown:SetWidth(300) --Breite in px
	dropdown:SetHeight(500) -- Hoehe in px
	local x = 0
	local y = 0
	dropdown:SetPoint("LEFT",x,y)
 
    --title
    data = { text = "Raids", isTitle = true, notCheckable = true, notClickable = true }
    line = createMenuLine(data)
    table.insert(menuTable,line)
 
    --add delimiter
    line = createDelimLine()
    table.insert(menuTable,line)
 
    --generate sub menu
    submenu = {}      
    data = { text = "Raid1", isTitle = true, notCheckable = true, notClickable = true }
    line = createMenuLine(data)
    table.insert(submenu,line)
    line = createDelimLine()
    table.insert(submenu,line)
    data = { text = "Boss1", func = myGlobalFunction1, notCheckable = true, keepShownOnClick = true, }
    line = createMenuLine(data)
    table.insert(submenu,line)
    data = { text = "Boss2", func = myGlobalFunction2, notCheckable = true, keepShownOnClick = true, }
    line = createMenuLine(data)
    table.insert(submenu,line)
    data = { text = "Boss3", func = myGlobalFunction3, notCheckable = true, keepShownOnClick = true, }
    line = createMenuLine(data)
    table.insert(submenu,line)
 
    --add submenu to menuTable
    data = { text = "Raid1", notCheckable = true, hasArrow = true, menuList = submenu }
    line = createMenuLine(data)
    table.insert(menuTable,line)
 
    --add delimiter
    line = createDelimLine()
    table.insert(menuTable,line)
 
    --close menu
    data = { text = "Close", func = function() CloseDropDownMenus() end, notCheckable = true }
    line = createMenuLine(data)
    table.insert(menuTable,line)
end