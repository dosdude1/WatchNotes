//
//  InterfaceController.h
//  Watch Notes WK Extension
//
//  Created by Collin Mistr on 10/4/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "RowController.h"

@interface InterfaceController : WKInterfaceController <WCSessionDelegate>
{
    NSArray *notes;
}
@property (strong, nonatomic) IBOutlet WKInterfaceTable *noteTable;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *noNotesLabel;

@end
