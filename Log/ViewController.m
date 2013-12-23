//
//  ViewController.m
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "ViewController.h"
#import "LogEntry.h"
#import "LogButton.h"
#import "Database.h"
#import "StyleFactory.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *_categories;
    int _viewHeight;
    int _viewWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _categories = [Database categories];
    _viewHeight = 50;
    _viewWidth = self.view.frame.size.width;
    
    // Enable scrolling by implementing scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _categories.count*_viewHeight);
    self.view = scrollView;
    scrollView.contentInset = UIEdgeInsetsMake(20., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0.);
    self.view.backgroundColor = [StyleFactory backgroundColor];
    
    // Add items to be logged
    for (int i=0; i<_categories.count; i++)
    {
        // TODO: Make categories generate from a CATEGORIES table
        LogButton *logItem = [self makeLogButton:i];
        logItem.layer.borderWidth = 0.25f;
        logItem.layer.borderColor = [self.view.backgroundColor CGColor];
        [self.view addSubview:logItem];
    }
}

- (LogButton *)makeLogButton:(int)number
{
    NSDictionary *logItem = _categories[number];
    LogButton *logButton = [[LogButton alloc] initWithFrame:CGRectMake(0,(_viewHeight)*number,_viewWidth,_viewHeight)];
    logButton.name = [logItem objectForKey:@"Name"];
    [logButton loadLastLogEntry];
    
    return logButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
