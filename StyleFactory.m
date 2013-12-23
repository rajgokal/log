
#import "StyleFactory.h"

static CGPoint _referencePoint = {0, 0};

@implementation StyleFactory

+ (UIColor*) deemphasizeButtonColor{
    return([UIColor colorWithRed:0 green: 0 blue: 127 alpha:0.6f]);
}

+ (UIColor*) normalButtonColor{
    return([UIColor whiteColor]);
}

+ (UIColor*) emphasizeButtonColor{
//    return([UIColor colorWithRed:169.0/255.0 green:228.0/255.0 blue:114.0/255.0 alpha:1.0]);
    return([UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:76.0/255.0 alpha:1.0]);
//    return([UIColor colorWithRed:27.0/255.0 green:178.0/255.0 blue:73.0/255.0 alpha:1.0]);
}

+ (UIColor*) highlightColor{
    return([UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0]);
}
 
+ (UIColor*) placeholderColor{
    return([UIColor grayColor]);
}

+ (UIColor*) backgroundColor{
    return ([UIColor colorWithRed:216.0 / 255.0 green:216.0 / 255.0 blue:216.0 / 255.0 alpha:1.0]);}

+ (UIColor*) headerBackgroundColor{
    return ([UIColor colorWithRed:127.0 / 255.0 green:140.0 / 255.0 blue:141.0 / 255.0 alpha:1.0]);}

+ (UIFont*) normalFont{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];
}

+ (UIFont*) heavyFont{
    return [UIFont fontWithName:@"Helvetica" size:18.0];
}

+ (void) styleCell: (UIView*) view{
    //view.backgroundColor = [UIColor colorWithHue:0.0 / 360.0 saturation:0.0 brightness:0.16 alpha:1.0];

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, view.frame.size.height - 6.0f, view.frame.size.width, 5.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f 
                                                 alpha:1.0f].CGColor;
    [view.layer addSublayer:bottomBorder];
}

+ (void) setReferencePoint:(CGPoint)referencePoint{
    _referencePoint = referencePoint;
}

+ (void) alignY:(UIView*) view{
    [StyleFactory alignY: view withPoint: _referencePoint andOffset: 0];
}

+ (void) alignX:(UIView*) view{
    [StyleFactory alignX: view withPoint: _referencePoint andOffset: 0];
}

+ (void) alignY:(UIView*) view withOffset: (float) offset{
    [StyleFactory alignY: view withPoint: _referencePoint andOffset: offset];
}

+ (void) alignX:(UIView*) view withOffset: (float) offset{
    [StyleFactory alignX: view withPoint: _referencePoint andOffset: offset];
}

+ (void) alignY:(UIView*) view withPoint: (CGPoint)point andOffset: (float) offset{
    view.center = CGPointMake(view.center.x, point.y + offset);
}

+ (void) alignX:(UIView*) view withPoint: (CGPoint)point andOffset: (float) offset{
    view.center = CGPointMake(point.x + offset, view.center.y);
}

+ (void) alignFromRightEdge: (UIView*) target ofElement:(UIView*) referenceElement withOffset: (float) offset{
    CGRect rect = referenceElement.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(referenceElement.frame) + offset, rect.origin.y);
    target.frame = rect;
}

+ (void) setX: (float) x ofTarget: (UIView*) target{
    CGRect rect = target.frame;
    rect.origin = CGPointMake(x, rect.origin.y);
    target.frame = rect;
}

+ (void) setY: (float) y ofTarget: (UIView*) target{
    CGRect rect = target.frame;
    rect.origin = CGPointMake(rect.origin.x, y);
    target.frame = rect;
}

+ (void) setWidth: (float) width ofTarget: (UIView*) target{
    CGRect rect = target.frame;
    rect.size = CGSizeMake(width, rect.size.height);
    target.frame = rect;
}

+ (void) setHeight: (float) height ofTarget: (UIView*) target{
    CGRect rect = target.frame;
    rect.size = CGSizeMake(rect.size.width, height);
    target.frame = rect;
}


@end
