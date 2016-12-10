//
//  NoteBook.m
//  Watch Notes
//
//  Created by Collin Mistr on 9/28/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import "NoteBook.h"
#import "Note.h"

@implementation NoteBook

-(id)init
{
    docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    notes = [[NSMutableArray alloc]init];
    if ([[NSFileManager defaultManager]fileExistsAtPath:[docsPath stringByAppendingPathComponent:@"notes.plist"]])
    {
        NSMutableArray *noteStrings=[[NSMutableArray alloc]initWithContentsOfFile:[docsPath stringByAppendingPathComponent:@"notes.plist"]];
        for (int i=0; i<noteStrings.count; i++)
        {
            [notes addObject:[[Note alloc]initWithText:[noteStrings objectAtIndex:i]]];
        }
    }
    
    
    return self;
}
-(void)makeNewNote:(NSString *)note
{
    [notes insertObject:[[Note alloc]initWithText:note] atIndex:0];
}
-(NSString *)getNote:(int)index
{
    return [[notes objectAtIndex:index]getText];
}
-(void)writeNote:(NSString *)text atIndex:(int)index
{
    [[notes objectAtIndex:index]setText:text];
}
-(void)deleteNote:(int)index
{
    [notes removeObjectAtIndex:index];
}
-(int)getNumNotes
{
    return (int)[notes count];
}
-(void)moveNote:(int)fromIndexPath toIndex:(int)toIndexPath
{
    id object = [notes objectAtIndex:fromIndexPath];
    [notes removeObjectAtIndex:fromIndexPath];
    [notes insertObject:object atIndex:toIndexPath];
}
-(void)saveData
{
    NSMutableArray *noteStrings = [[NSMutableArray alloc]init];
    if (notes.count > 0)
    {
        for (int i=0; i<notes.count; i++)
        {
            [noteStrings addObject:[[notes objectAtIndex:i] getText]];
        }
    }
    [noteStrings writeToFile:[docsPath stringByAppendingPathComponent:@"notes.plist"] atomically:YES];
}
@end
