--[[-------------------------------------------------------------------------
Info.lua: Plug-in manifest file

Create a collection set containing a collection and a smart collection from
the name given.

Menu items:

* Library -> Plugin Extras -> Create Collection Set

---------------------------------------------------------------------------]]

--[[
See "Declaring the contents of a plug-in" in `Lightroom SDK Guide.pdf`
]]
return {
  VERSION = { major=1, minor=0, revision=0, },

  LrSdkVersion = 9.0,
  LrSdkMinimumVersion = 4.0,

  LrToolkitIdentifier = "com.akrabat.new-collection-set",
  LrPluginName = "New Collection Set",
  LrPluginInfoUrl="https://github.com/akrabat/new-collection-set.lrplugin",

  LrLibraryMenuItems = {
    {
      title = "Create Collection Set",
      file = "CreateCollectionSet.lua",
    },
  },
}
