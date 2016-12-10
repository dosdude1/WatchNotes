//
//  NoteView.h
//  Watch Notes
//
//  Created by Collin Mistr on 9/25/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteBook.h"

@interface NoteView : UIViewController <UITextViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UITextView *noteTextView;
    UIBarButtonItem *doneButton;
    BOOL isLastNote;
    BOOL isNewNote;
    NoteBook *noteBook;
    int selectedIndex;
    UIInterfaceOrientation orientation;
}
-(void)receiveData:(int)index isNewNote:(BOOL)isNew;
-(void)getNotebook:(NoteBook *)inNoteBook;
- (IBAction)deleteNote:(id)sender;

@end
