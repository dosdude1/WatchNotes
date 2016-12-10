//
//  NoteBook.h
//  Watch Notes
//
//  Created by Collin Mistr on 9/28/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteBook : NSObject
{
    NSString *docsPath;
    NSMutableArray *notes;
}

-(id)init;
-(void)makeNewNote:(NSString *)note;
-(NSString *)getNote:(int)index;
-(void)writeNote:(NSString *)text atIndex:(int)index;
-(void)deleteNote:(int)index;
-(int)getNumNotes;
-(void)moveNote:(int)fromIndexPath toIndex:(int)toIndexPath;
-(void)saveData;

@end
