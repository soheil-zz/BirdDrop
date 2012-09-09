//
//  Window.m
//  BirdDrop
//
//  Created by Soheil Yasrebi on 9/4/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import "Window.h"

@implementation Window

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
    if (self) {
        [self setOpaque:NO];
        [self setHasShadow:YES];
        [self setLevel:NSFloatingWindowLevel];
        [self setAlphaValue:0.6];
    }
    
    contentRect.origin.x=100;
    contentRect.origin.y=100;
    
    return self;
}

- (void)awakeFromNib
{
    [NSEvent addGlobalMonitorForEventsMatchingMask:
     (NSLeftMouseDraggedMask|NSKeyDownMask|NSFlagsChangedMask)
                                           handler:^(NSEvent *incomingEvent) {
                                               if (([incomingEvent type] == 6 && [self isMakingAShakeGesture:[incomingEvent locationInWindow]])
                                                   || ([incomingEvent type] == 10 && [incomingEvent keyCode] == 9 && ([incomingEvent modifierFlags] == 1573200
                                                                                                                      || [incomingEvent modifierFlags] == 1573160))){
                                                   [self didShakeGesture:[incomingEvent locationInWindow]];
                                               }
                                           }];
    [self mouseExited:nil];
}

- (int)speed:(NSPoint)location
{
    int speed = locationPrev.x ? sqrt(pow(locationPrev.x - location.x, 2) + pow(locationPrev.y - location.y, 2)) : 0;
    locationPrev = location;
    return speed;
}

- (void)didShakeGesture:(NSPoint)location
{
    if (isVisible) {
        [self mouseExited:nil];
    } else {
        NSRect screenRect = [[NSScreen mainScreen] visibleFrame];
        [self mouseEntered:nil];
        int x = location.x + self.frame.size.width/2;
        int y = location.y - self.frame.size.height/2;
        if (x + self.frame.size.width > screenRect.size.width) {
            x -= self.frame.size.width*2;
        }
        if (y + self.frame.size.height > screenRect.size.height) {
            y = screenRect.size.height - self.frame.size.height;
        }
        if (y - self.frame.size.height/2 < 0) {
            y = 0;
        }
        [self setFrame:NSMakeRect(x, y, self.frame.size.width, self.frame.size.height) display:YES];
    }
}

- (BOOL)isMakingAShakeGesture:(NSPoint)location
{
    double delta = [[NSDate date] timeIntervalSince1970] - startShakeIdealTime;
    if (delta > .49 || [[NSDate date] timeIntervalSince1970] - noShakeUntilTime < 0) {
        startLocation.x = 0;
        startLocation.y = 0;
    }
    if (!startLocation.x) {
        startShakeIdealTime = [[NSDate date] timeIntervalSince1970];
        startLocation = location;
        shakes = 0;
    }
    int xDelta = abs(startLocation.x - location.x);
    int yDelta = abs(startLocation.y - location.y);
    int xyDelta = xDelta > yDelta ? xDelta : yDelta;
    if (xyDelta > 20 && xyDelta < 240 && [self speed:location] > 30) {
        startShakeIdealTime = [[NSDate date] timeIntervalSince1970];
        if (delta < .2 && delta > .05) {
            shakes++;
        }
        if (shakes > 2) {
            startLocation.x = 0;
            startLocation.y = 0;
            noShakeUntilTime = [[NSDate date] timeIntervalSince1970] + 1.5;
            shakes = 0;
            return YES;
        }
    }
    return NO;
}

// Windows created with NSBorderlessWindowMask normally can't be key, but we want ours to be
- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [[self animator] setAlphaValue:.87];
    } completionHandler:^{
        isVisible = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [[self animator] setAlphaValue:0.0];
    } completionHandler:^{
        isVisible = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }];
}

-(IBAction)exitButton:(id)sender
{
    [self mouseExited:nil];
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    NSLog(@"sourceOperationMaskForDraggingContext-matrix");
    return NSDragOperationAll;
}

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint
{
    NSLog(@"draggingSession-matrix");
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSLog(@"dragged");
}

@end
