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
    int _viewHeight;
    int _viewWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewHeight = 50;
    _viewWidth = self.view.frame.size.width;
    
    self.view.backgroundColor = [StyleFactory backgroundColor];
    UIScrollView *horizontalScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    horizontalScroll.scrollEnabled = YES;
    horizontalScroll.pagingEnabled = YES;
    horizontalScroll.showsHorizontalScrollIndicator = YES;
    horizontalScroll.contentSize = CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height);
    [self.view addSubview:horizontalScroll];
    
    [horizontalScroll addSubview:[self makeScrollingList:0]];
    [horizontalScroll addSubview:[self makeScrollingList:1]];
    [horizontalScroll addSubview:[self makeScrollingList:2]];
    
    // Floating button
    UIButton *floatingButton = [[UIButton alloc]initWithFrame:(CGRectMake(5,self.view.frame.size.height-95,40,40))];
    floatingButton.backgroundColor = [StyleFactory deemphasizeButtonColor];
    [floatingButton setTitle:@"+" forState:UIControlStateNormal];
    floatingButton.titleLabel.font = [[StyleFactory heavyFont] fontWithSize:26.0];
    [self.view addSubview:floatingButton];
    [self.view bringSubviewToFront:floatingButton];
    
}

- (LogButton *)makeLogButton:(NSString *)name number:(int)number
{
    LogButton *logButton = [[LogButton alloc] initWithFrame:CGRectMake(0,(_viewHeight)*(number+1),_viewWidth,_viewHeight)];
    logButton.name = name;
    [logButton loadLastLogEntry];
    
    return logButton;
}

- (UIScrollView *)makeScrollingList:(int)number
{
    NSArray *habits = [Database category:number];
    
    // Enable scrolling by implementing scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0+_viewWidth*number, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(_viewWidth, (habits.count+1)*_viewHeight);
    scrollView.contentInset = UIEdgeInsetsMake(20., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0.);
    
    // Add header
    [scrollView addSubview:[self makeHeader:number]];
    
    // Add items to be logged
    for (int i=0; i<habits.count; i++)
    {
        // TODO: Make categories generate from a CATEGORIES table
        NSDictionary *habit = habits[i];
        LogButton *habitButton = [self makeLogButton:[habit objectForKey:@"Name"] number:i];
        habitButton.layer.borderWidth = 0.25f;
        habitButton.layer.borderColor = [self.view.backgroundColor CGColor];
        [scrollView addSubview:habitButton];
    }
    
    return scrollView;
}

- (UIView *)makeHeader:(int)number
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,_viewWidth,_viewHeight)];
    headerView.backgroundColor = [StyleFactory headerBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [StyleFactory heavyFont];
    NSString *headerText;
    if (number == 0) headerText = @"Morning";
    if (number == 1) headerText = @"Day";
    if (number == 2) headerText = @"Evening";
    headerLabel.text = headerText;
    headerLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:headerLabel];
    
    int offset = 135;
    
    UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left-arrow.png"]];
    leftArrow.frame = CGRectMake(0, 0, 29.0/2.0, 40.0/2.0);
    [StyleFactory alignY:leftArrow withPoint:headerLabel.center andOffset:0];
    [StyleFactory alignX:leftArrow withPoint:headerLabel.center andOffset:-offset];
    [headerView addSubview:leftArrow];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow.png"]];
    rightArrow.frame = CGRectMake(0, 0, 29.0/2.0, 40.0/2.0);
    [StyleFactory alignY:rightArrow withPoint:headerLabel.center andOffset:0];
    [StyleFactory alignX:rightArrow withPoint:headerLabel.center andOffset:offset];
    [headerView addSubview:rightArrow];
    
    return headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
