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

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *_logItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    _logItems = @[
                  @{@"Name" : @"Weight",
                    @"Type" : @"Decimal"
                    },
                  @{@"Name" : @"Body Fat \%",
                    @"Type" : @"Percentage",
                    },
                  @{@"Name" : @"Muscle \%",
                      @"Type" : @"Percentage"
                    },
                  @{@"Name" : @"Floss",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Brush Teeth",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Shower",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Mouthwash",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Moisturizer",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Vitamins",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Yoga",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Stretch",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Calisthenics",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Run",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Protein Shake",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Meditation",
                    @"Type" : @"Boolian"
                    },
                  @{@"Name" : @"Day Planning",
                    @"Type" : @"Boolian"
                    }
                  ];
    
    // Enable scrolling
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    [self.view addSubview:scrollView];
    
    // Add items to be logged
    for (int i=0; i<_logItems.count; i++)
    {
        NSLog(@"%i",i);
        LogButton *logItem = [self makeLogButton:i];
        [scrollView addSubview:logItem];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (LogButton *)makeLogButton:(int)number
{
    int viewHeight = 50;
    int viewWidth = self.view.frame.size.width-2;
    NSDictionary *logItem = _logItems[number];
    LogButton *logButton = [[LogButton alloc] initWithFrame:CGRectMake(1,20+(viewHeight+1)*number,viewWidth,viewHeight)];
    [logButton setName:[logItem objectForKey:@"Name"]];
    
    return logButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
