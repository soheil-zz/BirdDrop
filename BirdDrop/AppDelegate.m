//
//  AppDelegate.m
//  BirdDrop
//
//  Created by Soheil Yasrebi on 8/31/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark -

void *kContextActivePanel = &kContextActivePanel;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextActivePanel) {
//        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Install icon into the menu bar
    self.menubarController = [[MenubarController alloc] init];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Explicitly remove the icon from the menu bar
    self.menubarController = nil;
    return NSTerminateNow;
}

- (IBAction)togglePanel:(id)sender
{
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
}
//
//- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
//{
//    return self.menubarController.statusItemView;
//}
//

@end
