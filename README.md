# New Collection Set Lightroom Plug-in

This plug-in for Lightroom Classic will create a collection set containing a collection and a smart
collection from the name given.

## Installation

* Download the [release zip][1] file and extract it.
* Move `new-collection-set.lrplugin` to the directory where you keep your Lightroom plug-ins.
* In Lightroom Classic, go to _File -> Plug-in Manager..._:
    * Click _Add_ at the bottom of the left hand list.
    * Navigate to and select `new-collection-set.lrplugin` and click _Add Plug-in_
    * Click _Enable_ in the _Status_ section for the New Collection Set plugin.
    * Close the Plug-in Manager by clicking _Done_.


[1]: https://github.com/akrabat/new-collection-set-lrplugin/archive/1.0.0.zip

## Running the plug-in

To run the plug-in, click _Library -> Plug-in Extras -> Create Collection Set_

This will:

1. Display a dialog asking for entry of the collection set name
2. Create a collection set under the selected collection set (or top level otherwise) named as per
   the entered name from the dialog box.
3. Create a collection under the new collection set with the same name appended with " Masters".
4. Create a smart collection under the new collection set with the same name appended with " <!>".
   The smart collection rules are that the photo must have a rating of at least 1 Star and be in
   the new "Masters" collection.

The end result is that you will have a collection set with a "masters" collection and a "picks"
smart collection inside it.