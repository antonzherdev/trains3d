#import <Foundation/Foundation.h>
#import "EGTypes.h"

@interface EGScene : NSObject
@property (nonatomic, readonly) id controller;
@property (nonatomic, readonly) id view;

+ (id)sceneWithController:(id)controller view:(id)view;
- (id)initWithController:(id)controller view:(id)view;
- (void)drawWithViewSize:(CGSize)viewSize;
- (void)updateWithDelta:(CGFloat)delta;
@end


