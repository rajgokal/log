//
//  LogButton.m
//  Log
//
//  Created by Raj on 12/16/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "LogButton.h"
#import "Database.h"
#import "StyleFactory.h"

@implementation LogButton
{
    NSString *_name;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UIButton *_doneButton;
    UITextField *_textField;
    LogEntry *_logEntry;
    bool _completed;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutView];
    }
    return self;
}

- (void)layoutView
{
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = 0.2;
//    self.layer.shadowRadius = 1.0;
//    self.layer.shadowOffset = CGSizeMake(2, 2);
//    self.clipsToBounds = NO;
    
    int viewWidth = self.frame.size.width;
    int viewHeight = self.frame.size.height;
    
    // Label
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,viewWidth*.7,viewHeight)];
    _nameLabel.font = [StyleFactory normalFont];
    [self addSubview:_nameLabel];
    
    // Time label
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth * .7,0,viewWidth*.3,viewHeight)];
    _timeLabel.hidden = YES;
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = [StyleFactory normalFont];
    [self addSubview:_timeLabel];
    
    // Text field
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth * .5,0,viewWidth*.2,viewHeight)];
    _textField.hidden = YES;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.placeholder = @"#.##";
    _textField.textColor = [UIColor grayColor];
    _textField.font = [StyleFactory heavyFont];
    [self addSubview:_textField];
    
    // Done button
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth * .7,0,viewWidth*.3,viewHeight)];
    _doneButton.hidden = YES;
    _doneButton.backgroundColor = [StyleFactory highlightColor];
    [_doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    _doneButton.titleLabel.textColor = [UIColor blackColor];
    _doneButton.titleLabel.font = [StyleFactory normalFont];
    [self addSubview:_doneButton];
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogItem:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognize];
    [self setUserInteractionEnabled: YES];
}

- (void)toggleCompleted
{
    _completed = !_completed;
    [self createLogEntry:(double)_completed];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self refresh];
                        }
    ];
}

- (void)refresh
{
    _completed = ([_logEntry.value doubleValue] > 0);
    if([_logEntry.value doubleValue] > 1)
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        if([_name isEqualToString:@"Weight"]) [numberFormatter setPositiveFormat:@"0.0;0.0;-0.0"];
        if([_name isEqualToString:@"Body Fat %"]) [numberFormatter setPositiveFormat:@"0.0'%';0.0'%';-0.0'%'"];
        if([_name isEqualToString:@"Muscle %"]) [numberFormatter setPositiveFormat:@"0.0'%';0.0'%';-0.0'%'"];
        
        NSLog(@"%@", [numberFormatter stringFromNumber:@4.0]);
        _textField.text = [numberFormatter stringFromNumber:_logEntry.value];
        _textField.hidden = NO;
    }
    UIColor *backgroundColor = _completed ? [StyleFactory emphasizeButtonColor] : [StyleFactory normalButtonColor];
    UIColor *textColor = _completed ? [UIColor whiteColor] : [UIColor blackColor];
    self.backgroundColor = backgroundColor;
    self.name = _logEntry.name;
    _nameLabel.textColor = textColor;
    _textField.textColor = [UIColor whiteColor];
    _timeLabel.hidden = !_completed;
    _timeLabel.textColor = textColor;
    _timeLabel.text = [_logEntry.stringFromTimestamp lowercaseString];
}

- (void)setName:(NSString *)name
{
    _name = name;
    _nameLabel.text = name;
}

- (void)tapLogItem:(UIGestureRecognizer *)tap
{
    if(_completed)
    {
        
    }
    if ([_name isEqualToString:@"Weight"] || [_name isEqualToString:@"Body Fat %"] || [_name isEqualToString:@"Muscle %"])
    {
        _textField.hidden = NO;
        _textField.text = [_logEntry.value stringValue];
        [_textField becomeFirstResponder];
        _doneButton.hidden = NO;
        return;
    }
    [self toggleCompleted];
}

- (void)done
{
    [_textField resignFirstResponder];
    _doneButton.hidden = YES;
    _completed = YES;
    [self createLogEntry:[_textField.text doubleValue]];
    [self refresh];
}

- (void)loadLastLogEntry
{
    _logEntry = [Database getLastLogEntryNamed:_name ForDay:[NSDate date]];
    if(!_logEntry)
    {
        [self createLogEntry:0];
    }
    [self refresh];
}

- (void)createLogEntry:(double)value;
{
    _logEntry = [[LogEntry alloc] init];
    _logEntry.timestamp = [NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]];
    _logEntry.name = _name;
    _logEntry.value = [NSNumber numberWithDouble:value];
    
    [Database saveLogEntry:_logEntry withCallback: ^(NSString* newId){}];
    [Database startBackgroundSync];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
