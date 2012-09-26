//
//  Window.h
//  BirdDrop
//
//  Created by Soheil Yasrebi on 9/4/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Window : NSWindow
{
    NSWindow *trackingWin;
    // variable to keep track if trackingWin is moving vertically or horizontally
    BOOL movingVertically, isVisible;
    NSPoint locationPrev, startLocation;
    double startShakeIdealTime, noShakeUntilTime;
    int shakes;
}
- (void)didShakeGesture:(NSPoint)location;

@end
