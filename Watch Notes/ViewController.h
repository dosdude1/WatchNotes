//
//  ViewController.h
//  Watch Notes
//
//  Created by Collin Mistr on 9/25/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "NoteView.h"
#import "NoteBook.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WCSessionDelegate>
{
    NSArray *notes;
    NoteView *noteView;
    NoteBook *noteBook;
    IBOutlet UITableView *noteTable;
    UIBarButtonItem *newButton;
}
- (IBAction)makeNewNote:(id)sender;
- (IBAction)editTable:(id)sender;

@end

