//
//  Category.h
//  Log
//
//  Created by Raj on 12/22/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogEntry.h"

@interface Habit : NSObject

@property float goal;
@property int currentLogStreak;
@property int allTimeLogStreak;
@property LogEntry *lastLogEntry;

@end
