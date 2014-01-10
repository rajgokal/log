//
//  Category.m
//  Log
//
//  Created by Raj on 12/22/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "Habit.h"

@implementation Habit

@synthesize habitId = _habitId;
@synthesize name = _name;

- (id)init
{
    self = [super init];
    if (self) {
        _habitId = @"";
        _name = @"";
    }
    return self;
}

- (id)initWithRecord: (FMResultSet*) rs{
    
    self = [self init];
    
    if(self){
        self.habitId = [rs stringForColumn:@"Id"];
        self.name = [rs stringForColumn:@"Name"];
    }
    
    return self;
}

@end
