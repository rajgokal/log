//
//  LogButton.h
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogEntry.h"

@interface LogButton : UIView <UIGestureRecognizerDelegate>

-(void)loadLastLogEntry;
-(void)setName: (NSString *)name;

@end
