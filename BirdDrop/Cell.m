//
//  Cell.m
//  BirdDrop
//
//  Created by Soheil Yasrebi on 9/4/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSImage *alphaImage;
    NSRect alphaImageRect = { NSZeroPoint, cellFrame.size };
    alphaImage = [[NSImage alloc] initWithSize:alphaImageRect.size];
    [alphaImage setFlipped:[controlView isFlipped]];
    [alphaImage lockFocus];
    BOOL wasEnabled = [self isEnabled];
    [self setEnabled:YES];
    [super drawWithFrame:alphaImageRect inView:controlView];
    [self setEnabled:wasEnabled];
    [alphaImage unlockFocus];
    [alphaImage drawAtPoint:cellFrame.origin fromRect:alphaImageRect operation:NSCompositeSourceOver fraction:0.75];
    [self drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
