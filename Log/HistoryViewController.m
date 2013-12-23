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
    
    float blockHeight = 50.0;
    float blockWidth = self.view.frame.size.width / 7.0;
    
    // Enable scrolling
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _categories.count*blockHeight);
    scrollView.contentInset = UIEdgeInsetsMake(20., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0.);
    self.view = scrollView;
    self.view.backgroundColor = [StyleFactory backgroundColor];
    
	for (int i=0; i<_categories.count; i++)
    {
        NSDictionary *logItem = _categories[i];
        NSString *name = [logItem objectForKey:@"Name"];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, i*blockHeight, blockWidth*3, 20)];
        nameLabel.text = name;
        nameLabel.font = [[StyleFactory normalFont] fontWithSize:7.0];
        
        for (int j=0; j<7; j++)
        {
            NSDate *date = [[NSDate date] dateByAddingTimeInterval:(-86400*j)];
            UIView *block = [self blockForName:name withDay:date];
            block.layer.borderWidth = 0.25f;
            block.layer.borderColor = [self.view.backgroundColor CGColor];
            block.frame = CGRectMake(0+j*blockWidth, i*blockHeight, blockWidth, blockHeight);
            [self.view addSubview:block];
        }
        
        [self.view addSubview:nameLabel];
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
