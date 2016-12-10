//
//  NoteView.m
//  Watch Notes
//
//  Created by Collin Mistr on 9/25/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import "NoteView.h"

@interface NoteView ()

@end

@implementation NoteView

- (void)viewDidLoad {
    [super viewDidLoad];
    [noteTextView setDelegate:self];
    doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(dismissKeyboard)];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    orientation = [[UIApplication sharedApplication] statusBarOrientation];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    orientation = toInterfaceOrientation;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    double height = 0.0;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        height = self.navigationController.navigationBar.frame.size.height+20;
    }
    else
    {
        height = self.navigationController.navigationBar.frame.size.height;
    }
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(height, 0.0, kbSize.height, 0.0);
    noteTextView.contentInset = contentInsets;
    noteTextView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, noteTextView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, noteTextView.frame.origin.y-kbSize.height);
        [noteTextView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    double height = 0.0;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        height = self.navigationController.navigationBar.frame.size.height+20;
    }
    else
    {
        height = self.navigationController.navigationBar.frame.size.height;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(height, 0.0, 44.0, 0.0);
    noteTextView.contentInset = contentInsets;
    noteTextView.scrollIndicatorInsets = contentInsets;
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getNotebook:(NoteBook *)inNoteBook
{
    noteBook=inNoteBook;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = doneButton;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (isNewNote || isLastNote)
    {
        if (![[noteTextView text]isEqualToString:@""])
        {
            [noteBook makeNewNote:[noteTextView text]];
            selectedIndex=0;
            isNewNote=NO;
            isLastNote=NO;
        }
        else
        {
            isNewNote=YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (!isNewNote)
    {
        if ([[noteTextView text]isEqualToString:@""])
        {
            isNewNote=YES;
            [self removeNote];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [noteBook writeNote:[noteTextView text] atIndex:selectedIndex];
        }
    }
    [noteBook saveData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateTable" object:nil];
    self.navigationItem.rightBarButtonItem = nil;
}
-(void)dismissKeyboard
{
    [noteTextView resignFirstResponder];
}
-(NSString *)sendData
{
    return [noteTextView text];
}
-(void)receiveData:(int)index isNewNote:(BOOL)isNew
{
    isNewNote=isNew;
    selectedIndex=index;
    if (isNewNote)
    {
        [noteTextView setText:@""];
        [noteTextView becomeFirstResponder];
    }
    else
    {
        [noteTextView setText:[noteBook getNote:index]];
        [self performSelector:@selector(refreshText:) withObject:[noteBook getNote:index] afterDelay:0.15];
        [noteTextView resignFirstResponder];
    }
}
-(void)refreshText:(NSString *)text
{
    [noteTextView setText:text];
    [noteTextView resignFirstResponder];
}
- (IBAction)deleteNote:(id)sender
{
    if (!isLastNote && !isNewNote)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Note" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault; [actionSheet showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [UIView beginAnimations:@"Curl" context:NULL];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:noteTextView cache:NO];
            [UIView setAnimationDuration:0.75f];
            [UIView commitAnimations];
            [self removeNote];
            break;
    }
}
-(void)removeNote
{
    if ([noteBook getNumNotes]>0)
    {
        [noteBook deleteNote:selectedIndex];
        if (selectedIndex > 0)
        {
            selectedIndex--;
        }
        if ([noteBook getNumNotes]>0 && !isNewNote)
        {
            [noteTextView setText:[noteBook getNote:selectedIndex]];
        }
        else
        {
            isLastNote=YES;
            [noteTextView setText:@""];
            [noteTextView becomeFirstResponder];
        }
    }
    else
    {
        isNewNote=YES;
        [noteTextView setText:@""];
        [noteTextView becomeFirstResponder];
    }
    [noteBook saveData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateTable" object:nil];
}
@end
