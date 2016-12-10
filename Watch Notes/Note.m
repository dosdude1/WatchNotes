//
//  Note.m
//  Watch Notes
//
//  Created by Collin Mistr on 9/27/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import "Note.h"

@implementation Note

-(id)init
{
    noteContent=@"";
    return self;
}
-(instancetype)initWithText:(NSString *)noteText
{
    noteContent=noteText;
    return self;
}
-(NSString *)getText
{
    return noteContent;
}
-(void)setText:(NSString *)text
{
    noteContent = text;
}
@end
