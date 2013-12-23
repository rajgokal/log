//
//  HistoryViewController.m
//  Log
//
//  Created by Raj on 12/20/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "HistoryViewController.h"
#import "Database.h"
#import "StyleFactory.h"

@interface HistoryViewController (){
    NSArray *_categories;
}

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _categories = [Database categories];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _categories = [Database categories];
    // Enable scrolling
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 20+_categories.count*(50+1)+50);
    self.view = scrollView;
    self.view.backgroundColor = [StyleFactory backgroundColor];
    
    int blockHeight = 50;
    int blockWidth = 31;
    
	for (int i=0; i<_categories.count; i++)
    {
        NSDictionary *logItem = _categories[i];
        NSString *name = [logItem objectForKey:@"Name"];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20+i*(blockHeight+1), blockWidth*3, blockHeight)];
        nameLabel.text = name;
        nameLabel.font = [[StyleFactory normalFont] fontWithSize:12.0];
        [self.view addSubview:nameLabel];
        
        for (int j=0; j<7; j++)
        {
            NSDate *date = [[NSDate date] dateByAddingTimeInterval:(-86400*j)];
            UIView *block = [self blockForName:name withDay:date];
            block.frame = CGRectMake(blockWidth*3+j*(blockWidth+1), 20+i*(blockHeight+1), blockWidth, blockHeight);
            [self.view addSubview:block];
        }
    }
}

- (UIView *)blockForName:(NSString *)name withDay:(NSDate *)date {
    UIView *block = [[UIView alloc] initWithFrame:CGRectZero];
    LogEntry *entry = [Database getLastLogEntryNamed:name ForDay:date];
    UIColor *backgroundColor = ([entry.value doubleValue] > 0) ? [StyleFactory emphasizeButtonColor] : [StyleFactory normalButtonColor];
    block.backgroundColor = backgroundColor;
    
    return block;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
