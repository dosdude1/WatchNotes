//
//  TextInterface.h
//  Watch Notes
//
//  Created by Collin Mistr on 10/4/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface TextInterface : WKInterfaceController
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *noteLabel;

@end
