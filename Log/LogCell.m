//
//  ActivitiesListCell.m
//  graphing
//
//  Created by Raj on 8/1/13.
//  Copyright (c) 2013 Raj. All rights reserved.
//

#import "LogCell.h"
#import "LogEntry.h"
#import "StyleFactory.h"


@implementation LogCell{
    UIView *_panel;
    UILabel *_commentLabel;
    UILabel *_valueLabel;
    UILabel *_timeLabel;
    UILabel *_syncedBox;
    UIImageView *_firstPicThumbnail;
    UIImageView *_secondPicThumbnail;
    LogEntry *_logEntry;
}


@synthesize presentingViewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)loadFoodEntry: (LogEntry *)le{
    _logEntry = le;

    if(le){
        _commentLabel.text = _logEntry.name;
        
        if([_logEntry.value doubleValue] > 1) _valueLabel.text = [_logEntry.value stringValue];

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
 
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];

        _timeLabel.font = [[StyleFactory normalFont] fontWithSize: 10.0f];
        _timeLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: [_logEntry.timestamp doubleValue]]];

        if([_logEntry.value boolValue]){
            _syncedBox.backgroundColor = [StyleFactory emphasizeButtonColor];
        }else{
            _syncedBox.backgroundColor = [StyleFactory highlightColor];
        }
    }
}

+ (int)cellHeight { return 75; }

- (void)layoutPanel
{
    if(_panel){
        [_panel removeFromSuperview];
        _panel = nil;
        [self layoutPanel];
        
        NSLog(@"removed panel");
        return;
    }

    int height = [LogCell cellHeight];
    
    // set up panel
    _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    
    /*
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    */
    
    CGPoint centerPoint = CGPointMake(_panel.frame.size.width/2, (_panel.frame.size.height/2) - 2);
    [StyleFactory setReferencePoint: centerPoint];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 225, 20)];
    _commentLabel.font = [StyleFactory normalFont];
    [StyleFactory alignY: _commentLabel withOffset: -20];
    [_panel addSubview:_commentLabel];
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 225, 20)];
    _valueLabel.font = [StyleFactory normalFont];
    [StyleFactory alignY: _valueLabel withOffset: 0];
    [_panel addSubview:_valueLabel];
   
    int syncedBoxWidth = 15;
    int syncedBoxPadding = 3;

    _syncedBox = [[UILabel alloc] initWithFrame:CGRectMake(_panel.frame.size.width - (syncedBoxWidth + syncedBoxPadding), syncedBoxPadding, syncedBoxWidth, syncedBoxWidth)];
    _syncedBox.backgroundColor = _panel.backgroundColor;
    [_panel addSubview:_syncedBox];

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, syncedBoxPadding, CGRectGetMaxX(_panel.frame) - (CGRectGetMaxX(_panel.frame) - CGRectGetMinX(_syncedBox.frame)) - 8, 15)];
    //_timeLabel.backgroundColor = [UIColor grayColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    //[StyleFactory alignY: _timeLabel withOffset: -10];
    [_panel addSubview:_timeLabel];
    
    [StyleFactory styleCell: _panel];

    [self addSubview:_panel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

