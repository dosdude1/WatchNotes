//
//  Note.h
//  Watch Notes
//
//  Created by Collin Mistr on 9/27/16.
//  Copyright © 2016 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
{
    NSString *noteContent;
}
-(id)init;
-(instancetype)initWithText:(NSString *)noteText;
-(NSString *)getText;
-(void)setText:(NSString *)text;
@end
