//
//  HabitCategoryViewController.m
//  Log
//
//  Created by Raj on 1/10/14.
//  Copyright (c) 2014 Raj. All rights reserved.
//

#import "HabitCategoryViewController.h"
#import "HabitCategoryCell.h"
#import "Database.h"
#import "StyleFactory.h"

@interface HabitCategoryViewController ()
{
    NSArray *_habits;
    NSNumber *_section;
    UIButton *_floatingButton;
    UITableView *_tableView;
}

@end

@implementation HabitCategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithCoder:nil];
    if (self) {
        _tableView.allowsSelection = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Floating button
    _floatingButton = [[UIButton alloc]initWithFrame:(CGRectMake(5,self.view.frame.size.height-95,40,40))];
    _floatingButton.backgroundColor = [StyleFactory deemphasizeButtonColor];
    [_floatingButton setTitle:@"+" forState:UIControlStateNormal];
    _floatingButton.titleLabel.font = [[StyleFactory heavyFont] fontWithSize:26.0];
    [_floatingButton addTarget:self action:@selector(addHabit) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self.view addSubview:_floatingButton];
    [self.view bringSubviewToFront:_floatingButton];
    
    [_tableView registerClass:[HabitCategoryCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect frame = _floatingButton.frame;
//    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - _floatingButton.frame.size.height;
//    _floatingButton.frame = frame;
//    
//    [self.view bringSubviewToFront:_floatingButton];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [Database numberOfCategories];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HabitCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Habit *habit = [Database getHabitCategory:[NSNumber numberWithInt:indexPath.row]];
    cell.name = habit.name;
    
    return cell;
}

- (void)addHabit
{
    Habit *habit = [[Habit alloc] init];
    habit.name = @"New habit";
    
    [Database saveHabitCategory:habit withCallback: ^(NSString* newId){}];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
