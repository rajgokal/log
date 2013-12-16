//
//  ViewController.m
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *_logItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        UIView *logItem = [self makeItem:i];
        [scrollView addSubview:logItem];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (UIView *)makeItem:(int)number
{
    int viewHeight = 30;
    int viewWidth = self.view.frame.size.width-2;
    NSDictionary *logItem = _logItems[number];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(1,(viewHeight+1)*number,viewWidth,viewHeight)];
    container.backgroundColor = [UIColor grayColor];
    
    // Label
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20,0,viewWidth*.7,viewHeight)];
    title.text = [logItem objectForKey:@"Name"];
    [container addSubview:title];
    
    // Fields / boxes
    if ([[logItem objectForKey:@"Type"] isEqual:@"Decimal"])
         {
             UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth * .7,0,viewWidth*.3,viewHeight)];
             field.backgroundColor = [UIColor whiteColor];
             field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
             field.returnKeyType = UIReturnKeyDone;
             [container addSubview:field];
         }
    
    
    return container;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
