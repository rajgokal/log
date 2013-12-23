//
//  ActivitiesListCell.h
//  graphing
//
//  Created by Raj on 8/1/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LogEntry.h"

@interface LogCell : UITableViewCell { }

@property (weak, nonatomic) UINavigationController* presentingViewController;

-(void)layoutPanel;
-(void)loadFoodEntry: (LogEntry *)le;

+(int)cellHeight;

@end
