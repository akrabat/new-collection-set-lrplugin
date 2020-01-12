--[[-------------------------------------------------------------------------
CreateCollectionSet.lua

Create a collection set containing a collection and a smart collection from
the name given.
---------------------------------------------------------------------------]]

-- Import the Lightroom SDK namespaces.
local LrApplication = import 'LrApplication'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'
local LrView = import 'LrView'


-- Set up the logger
local logger = LrLogger('AkrabatNewCollectionSet')
logger:enable("print") -- set to "logfile" to write to ~/Documents/lrClassicLogs/AkrabatNewCollectionSet.log
local log = logger:quickf('info')

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

--[[
This is the entry point function that's called when the Lightroom menu item is selected
]]
local function main()
  local catalog = LrApplication.activeCatalog()

  local parentCollectionSet = nil
  local parentCollectionSetName = "== Top level =="

  -- If the first selected source is a Collection Set, then this should be our parent
  local sources = catalog:getActiveSources()
  local count = 0
  for _ in pairs(sources) do count = count + 1 end
  if count == 1 then
    local activeSource = sources[1]
    if (type(activeSource) == "table") and (activeSource:type() == "LrCollectionSet") then
      parentCollectionSet = activeSource
      parentCollectionSetName = activeSource:getName()
    end
  end

  -- Display a dalog box
  LrFunctionContext.callWithContext( "showCreateCollectionSetDialog", function(context)
    local f = LrView.osFactory()

    -- Create a bindable table.  Whenever a field in this table changes
    -- then notifications will be sent.
    local props = LrBinding.makePropertyTable(context)
    props.name = os.date("%Y-%m-%d ")

    -- Create the contents for the dialog.
    local c = f:column {
      bind_to_object = props,
      spacing = f:control_spacing(),

      f:row {
        f:static_text {
          title = "Parent:"
        },
        f:static_text {
          title = parentCollectionSetName
        },
      },
      f:row {
        f:static_text {
          title = "Name: "
        },
        f:edit_field {
          width_in_chars = "30",
          enabled = true,
          value = LrView.bind("name")
        }
      }
    }

    local result = LrDialogs.presentModalDialog {
      title = "Create Collection Set",
      contents = c
    }


    if result == "ok" then
      -- process results of dialog box
      catalog:withWriteAccessDo("Create collection set", function()
        collectionSet = catalog:createCollectionSet(props.name, parentCollectionSet, true)
      end)
      catalog:withWriteAccessDo("Create collections inside collection set", function()
        -- create "Masters" collection within our new set
        local mastersCollectionName = string.format("%s Masters", props.name)
        catalog:createCollection(mastersCollectionName, collectionSet)

        -- Create smart collection within our new set
        local smartCollectionName = string.format("%s <!>", props.name)
        local searchDesc = {
          combine = "intersect",
          {
            -- 1 star or above
            criteria = "rating",
            operation = ">=",
            value = 1
          },
          {
            criteria = "collection",
            operation = "all",
            value = mastersCollectionName,
          },
        }
        catalog:createSmartCollection(smartCollectionName, searchDesc, collectionSet)
      end)


      local msg = string.format("Collection set %q created.", props.name)
      LrDialogs.message("Create Collection Set", msg, "info")
    end

  end) -- end main function
end

-- Run main()
LrTasks.startAsyncTask(main)
