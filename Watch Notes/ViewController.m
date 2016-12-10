//
//  ViewController.m
//  Watch Notes
//
//  Created by Collin Mistr on 9/25/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [noteTable setDelegate:self];
    [noteTable setDataSource:self];
    noteBook=[[NoteBook alloc]init];
    noteView=[self.storyboard instantiateViewControllerWithIdentifier:@"NoteView"];
    newButton = [[UIBarButtonItem alloc]
                  initWithTitle:@"New"
                  style:UIBarButtonItemStyleBordered
                  target:self
                  action:@selector(makeNewNote:)];
    [noteView getNotebook:noteBook];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTable) name:@"UpdateTable" object:nil];
    if ([WCSession isSupported]) {
        WCSession *watchSession = [WCSession defaultSession];
        watchSession.delegate = self;
        [watchSession activateSession];
    }
}
-(void)updateTable
{
    [noteTable reloadData];
    [self sendNotesToWatch];
}
-(void)sendNotesToWatch
{
    if ([[WCSession defaultSession] isReachable]) {
        NSArray *objects = [[NSArray alloc] initWithObjects:@"sentNotes", [self getNoteStrings], nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"sendData", @"notes", nil];
        NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        [[WCSession defaultSession] sendMessage:applicationData
                                   replyHandler:^(NSDictionary *reply) {
                                       
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                   }
         ];
    }
    else {
        //we aren't in range of the phone, they didn't bring it on their run
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [noteBook deleteNote:(int)indexPath.row];
        [noteBook saveData];
        [noteTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self sendNotesToWatch];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [noteBook moveNote:(int)fromIndexPath.row toIndex:(int)toIndexPath.row];
    [noteBook saveData];
    [self sendNotesToWatch];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [noteBook getNumNotes];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([noteBook getNumNotes]>0)
    {
        noteTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        noteTable.backgroundView=nil;
    }
    else
    {
        UILabel *noNotesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, noteTable.bounds.size.width, noteTable.bounds.size.height)];
        [noNotesLabel setText:@"No Notes"];
        [noNotesLabel setFont:[UIFont systemFontOfSize:24]];
        [noNotesLabel setTextColor:[UIColor blackColor]];
        [noNotesLabel setTextAlignment:NSTextAlignmentCenter];
        noteTable.backgroundView = noNotesLabel;
        noteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath //Delegated UITableView Method, used for creating the table.
{
    static NSString *identifier = @"TableCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [noteBook getNote:(int)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [noteView receiveData:(int)indexPath.row isNewNote:NO];
    [self.navigationController pushViewController:noteView animated:YES];
    [noteTable deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeNewNote:(id)sender
{
    [noteView receiveData:[noteBook getNumNotes] isNewNote:YES];
    [self.navigationController pushViewController:noteView animated:YES];
}
- (IBAction)editTable:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [noteTable setEditing:NO animated:YES];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        self.navigationItem.rightBarButtonItem = newButton;
    }
    else
    {
        [super setEditing:YES animated:YES];
        [noteTable setEditing:YES animated:YES];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)session:(nonnull WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void(^)(NSDictionary<NSString *,id> *))replyHandler
{
    if ([[message objectForKey:@"sendData"] isEqualToString:@"sendNotes"])
    {
        replyHandler(@{@"actionPerformed":[self getNoteStrings]});
    }
    if ([[message objectForKey:@"sendData"] isEqualToString:@"compareNotes"])
    {
        BOOL isEqual=NO;
        if ([[self getNoteStrings] isEqualToArray:[message objectForKey:@"notes"]])
        {
            isEqual=YES;
        }
        replyHandler(@{@"actionPerformed":[NSNumber numberWithBool:isEqual]});
    }
}
-(NSArray *)getNoteStrings
{
    NSMutableArray *noteStrings=[[NSMutableArray alloc]init];
    for (int i=0; i<noteBook.getNumNotes; i++)
    {
        [noteStrings addObject:[noteBook getNote:i]];
    }
    return [NSArray arrayWithArray:noteStrings];
}
@end
