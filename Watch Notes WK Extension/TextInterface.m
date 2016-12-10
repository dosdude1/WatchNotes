//
//  TextInterface.m
//  Watch Notes
//
//  Created by Collin Mistr on 10/4/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import "TextInterface.h"

@interface TextInterface ()

@end

@implementation TextInterface

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self.noteLabel setText:context];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
@end



