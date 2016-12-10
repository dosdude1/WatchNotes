//
//  InterfaceController.m
//  Watch Notes WK Extension
//
//  Created by Collin Mistr on 10/4/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if ([WCSession isSupported]) {
        WCSession *watchSession = [WCSession defaultSession];
        watchSession.delegate = self;
        [watchSession activateSession];
    }
    notes=[[NSArray alloc]init];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if ([[WCSession defaultSession] isReachable]) {
        NSArray *objects = [[NSArray alloc] initWithObjects:@"compareNotes", notes, nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"sendData", @"notes", nil];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        [[WCSession defaultSession] sendMessage:applicationData
                                   replyHandler:^(NSDictionary *reply) {
                                       if ([[reply objectForKey:@"actionPerformed"] boolValue]==NO)
                                       {
                                           NSArray *objects = [[NSArray alloc] initWithObjects:@"sendNotes", nil];
                                           NSArray *keys = [[NSArray alloc] initWithObjects:@"sendData", nil];
                                           NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                                           [[WCSession defaultSession] sendMessage:applicationData
                                                                      replyHandler:^(NSDictionary *reply) {
                                                                          notes = [reply objectForKey:@"actionPerformed"];
                                                                          [self updateTable];
                                                                      }
                                                                      errorHandler:^(NSError *error) {
                                                                          //catch any errors here
                                                                      }
                                            ];
                                       }
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                   }
         ];
    }
    else {
        //phone not in range
    }
    
}
-(void)updateTable
{
    [self.noteTable setNumberOfRows:notes.count withRowType:@"RowIdentifier"];
    for (int i = 0; i < notes.count; i++) {
        // Set the values for the row controller
        RowController* row = [self.noteTable rowControllerAtIndex:i];
        
        [row.rowLabel setText:[notes objectAtIndex:i]];
        
    }
    if (notes.count > 0)
    {
        [self.noNotesLabel setHidden:YES];
    }
    else
    {
        [self.noNotesLabel setHidden:NO];
    }
}
- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    [self pushControllerWithName:@"TextInterface" context:[notes objectAtIndex:rowIndex]];
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (void)session:(nonnull WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void(^)(NSDictionary<NSString *,id> *))replyHandler
{
    if ([[message objectForKey:@"sendData"] isEqualToString:@"sentNotes"])
    {
        notes=[message objectForKey:@"notes"];
        [self updateTable];
    }
}
@end



