#import "objd.h"
@class EGShareDialog;

@class EGShareItem;
@class EGShareContent;
@class EGShareChannel;

@interface EGShareChannel : ODEnum
+ (EGShareChannel*)facebook;
+ (EGShareChannel*)twitter;
+ (EGShareChannel*)email;
+ (EGShareChannel*)message;
+ (NSArray*)values;
@end


@interface EGShareItem : NSObject
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) id subject;

+ (id)shareItemWithText:(NSString*)text subject:(id)subject;
- (id)initWithText:(NSString*)text subject:(id)subject;
- (ODClassType*)type;
+ (EGShareItem*)applyText:(NSString*)text;
+ (ODClassType*)type;
@end


@interface EGShareContent : NSObject
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) id image;
@property (nonatomic, readonly) id<CNMap> items;

+ (id)shareContentWithText:(NSString*)text image:(id)image items:(id<CNMap>)items;
- (id)initWithText:(NSString*)text image:(id)image items:(id<CNMap>)items;
- (ODClassType*)type;
+ (EGShareContent*)applyText:(NSString*)text image:(id)image;
- (EGShareContent*)addChannel:(EGShareChannel*)channel text:(NSString*)text;
- (EGShareContent*)addChannel:(EGShareChannel*)channel text:(NSString*)text subject:(id)subject;
- (EGShareContent*)twitterText:(NSString*)text;
- (EGShareContent*)facebookText:(NSString*)text;
- (EGShareContent*)emailText:(NSString*)text subject:(NSString*)subject;
- (EGShareContent*)messageText:(NSString*)text;
- (NSString*)textChannel:(EGShareChannel*)channel;
- (id)subjectChannel:(EGShareChannel*)channel;
- (id)imageChannel:(EGShareChannel*)channel;
- (EGShareDialog*)dialog;
- (EGShareDialog*)dialogCompletionHandler:(void(^)(EGShareChannel*))completionHandler;
+ (ODClassType*)type;
@end


