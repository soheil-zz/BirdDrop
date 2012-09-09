hdiutil create BirdDrop.dmg -srcfolder "`find /Users/\`whoami\`/Library/Developer/Xcode/DerivedData/BirdDrop* | grep .app$`" -ov
