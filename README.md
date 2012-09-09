BirdDrop
========

Ever wonder if there was a better way to drag and drop stuff on your OSX? Well now there is. Just shake your mouse and a tiny window will appear momentarily drag your item there, switch to another app and the tiny window will stay there so you can drag your item from it with ease. Special CMD + CTRL + V shortcut keys can be used to show/hide BirdDrop as well.

Make File
=========
Currently the `make` file is only used to create a .dmg image out of the app folder.

```
hdiutil create BirdDrop.dmg -srcfolder "`find /Users/\`whoami\`/Library/Developer/Xcode/DerivedData/BirdDrop* | grep .app$`" -ov
```

Finds where the compiled dir and generates .dmg in current dir.


Twitter Account
===============
Stay on top of the development cycle by following <a href="https://twitter.com/soheil">@soheil</a> on Twitter.
