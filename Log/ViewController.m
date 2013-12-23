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
    
    // Add items to be logged
    for (int i=0; i<_categories.count; i++)
    {
        LogButton *logItem = [self makeLogButton:i];
        [self.view addSubview:logItem];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (LogButton *)makeLogButton:(int)number
{
    int viewHeight = 50;
    int viewWidth = self.view.frame.size.width-2;
    NSDictionary *logItem = _categories[number];
    LogButton *logButton = [[LogButton alloc] initWithFrame:CGRectMake(1,20+(viewHeight+1)*number,viewWidth,viewHeight)];
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
