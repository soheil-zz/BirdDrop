//
//  AppDelegate.h
//  BirdDrop
//
//  Created by Soheil Yasrebi on 8/31/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenubarController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) MenubarController *menubarController;
@property (assign) IBOutlet NSWindow *window;

- (IBAction)togglePanel:(id)sender;

@end
