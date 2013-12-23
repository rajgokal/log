
@interface StyleFactory : NSObject

+ (void) styleCell: (UIView*) view;

+ (UIColor*) placeholderColor;

+ (UIColor*) deemphasizeButtonColor;
+ (UIColor*) normalButtonColor;
+ (UIColor*) highlightColor;
+ (UIColor*) emphasizeButtonColor;

+ (UIFont*) normalFont;
+ (UIFont*) heavyFont;
+ (UIColor*) backgroundColor;
+ (UIColor*) headerBackgroundColor;

+ (void) setReferencePoint:(CGPoint)referencePoint;

+ (void) alignY:(UIView*) view;
+ (void) alignX:(UIView*) view;

+ (void) alignY:(UIView*) view withOffset: (float) offset;
+ (void) alignX:(UIView*) view withOffset: (float) offset;

+ (void) alignY:(UIView*) view withPoint: (CGPoint)point andOffset: (float) offset;
+ (void) alignX:(UIView*) view withPoint: (CGPoint)point andOffset: (float) offset;

+ (void) alignFromRightEdge: (UIView*) target ofElement:(UIView*) referenceElement withOffset: (float) offset;

+ (void) setX: (float) x ofTarget: (UIView*) target;
+ (void) setY: (float) y ofTarget: (UIView*) target;
+ (void) setWidth: (float) width ofTarget: (UIView*) target;
+ (void) setHeight: (float) height ofTarget: (UIView*) target;

@end
