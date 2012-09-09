//
//  Matrix.m
//  BirdDrop
//
//  Created by Soheil Yasrebi on 9/4/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import "Matrix.h"
#import "Cell.h"

@implementation Matrix

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    return [NSImage canInitWithPasteboard: [sender draggingPasteboard]];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    return [self draggingUpdated:sender];
}

- (NSSize)rescaleRect:(NSSize)rect toFitInSize:(NSSize)size
{
    float heightQuotient = rect.height / size.height; float widthQuotient = rect.width / size.width;
    if (heightQuotient > widthQuotient) {
        return NSMakeSize(rect.width / heightQuotient, rect.height / heightQuotient);
    } else {
        return NSMakeSize(rect.width / widthQuotient, rect.height / widthQuotient);
    }
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
    NSInteger rowCurrent, columnCurrent;
    NSImage *image;
    NSPoint location=[self convertPoint:[sender draggingLocation] fromView:nil];
    if([NSImage canInitWithPasteboard: [sender draggingPasteboard]]) {
        image = [[NSImage alloc] initWithPasteboard: [sender draggingPasteboard]];
        if ( [self getRow:&rowCurrent column:&columnCurrent forPoint:location] ) {
            Cell *cellPrev = [self cellAtRow:row column:column];
            if (row != rowCurrent && column != columnCurrent) {
                [cellPrev setImage:nil];
            }
            [cellPrev setImage:nil];
            Cell *cell = [self cellAtRow:rowCurrent column:columnCurrent];
            row = rowCurrent;
            column = columnCurrent;
            if ( [image size].width > [self cellSize].width || [image size].height > [self cellSize].height )
            {
                [image setSize: 1 / (image.size.width / image.size.height) + image.size.width / image.size.height > 2*1.1 ? [self rescaleRect:[image size] toFitInSize:[self cellSize]] : [self cellSize]];
            }
            
            [cell setImage:image];
        }
    }
    return NSDragOperationCopy;
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

- (void) mouseDragged: (NSEvent *) a_theEvent
{
    NSPasteboard *pboard;
    NSImage *image = nil;
    NSImage *translucent = nil;
    NSPoint dragPoint = NSZeroPoint;
    
    pboard = [NSPasteboard pasteboardWithName: NSDragPboard];
    //    [self copyToPasteboard: pboard];
    
    image = [((Cell *)[self selectedCell]) image];
    dragPoint = [self convertPoint: [a_theEvent locationInWindow]
                          fromView: nil];
    dragPoint.x -= ([image size].width * 0.5);
    dragPoint.y += ([image size].height * 0.5);
    
    translucent = [[NSImage alloc] initWithSize: [image size]];
    [translucent lockFocus];
    [image dissolveToPoint: NSZeroPoint fraction: 0.5];
    [translucent unlockFocus];
    
    [self dragImage: translucent
                 at: dragPoint
             offset: NSZeroSize
              event: a_theEvent
         pasteboard: pboard
             source: self
          slideBack: YES];
}

- (NSImage *) getImageOfContents
{
    NSImage *image = nil;
    NSBitmapImageRep *bits = nil;
    NSRect textFrame;
    
    textFrame.size = [self cellSize];
    textFrame.origin = NSZeroPoint;
    
    image = [[NSImage alloc] initWithSize: textFrame.size];
    [image setBackgroundColor:[NSColor clearColor]];
    
    [image lockFocus];
    bits = [[NSBitmapImageRep alloc] initWithFocusedViewRect: textFrame];
    [image unlockFocus];
    
    return image;
}
- (BOOL) acceptsFirstMouse: (NSEvent *) theEvent
{
    NSLog(@"acceptsFirstMouse");
    return YES;
}

- (NSDragOperation) draggingSourceOperationMarkForLocal: (BOOL) flag
{
    NSLog(@"draggingSourceOperationMarkForLocal");
    return NSDragOperationCopy;
}

- (void) copyToPasteboard: (NSPasteboard *) a_pboard
{
    NSLog(@"copyToPasteboard");
    NSString *title = [[self selectedCell] title];
    NSAttributedString *attTitle = [[self selectedCell] attributedTitle];
    
    [a_pboard declareTypes: [NSArray arrayWithObjects: NSRTFPboardType,
                             NSStringPboardType, nil] owner: self];
    
    [a_pboard setData: [attTitle RTFFromRange: NSMakeRange(0, [attTitle
                                                               length]) documentAttributes: nil] forType:NSRTFPboardType];
    [a_pboard setString: title forType: NSStringPboardType];
    
    //[a_pboard setData: [[self title] dataUsingEncoding: some custom
    //    encoding? forType: NSStringPboardType];
    //NSLog(@"Types in drag: %@\n", [a_pboard types]);
}

// NSMatrix eats drag events
- (void) mouseDown: (NSEvent *) a_theEvent
{
    if ( [self getRow: &row column: &column forPoint: [self
                                                       convertPoint:[a_theEvent locationInWindow] fromView: nil]] &&
        [[self cellAtRow:row column: column] isEnabled]) {
        [self selectCellAtRow: row column: column];
        [self sendAction];
    } else {
        [super mouseDown: a_theEvent];
    }
}

@end
