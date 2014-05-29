#import "objd.h"
@class EGShareDialog;

@class EGShareItem;
@class EGShareContent;
@class EGShareChannel;

typedef enum EGShareChannelR {
    EGShareChannel_Nil = 0,
    EGShareChannel_facebook = 1,
    EGShareChannel_twitter = 2,
    EGShareChannel_email = 3,
    EGShareChannel_message = 4
} EGShareChannelR;
@interface EGShareChannel : CNEnum
+ (NSArray*)values;
@end
static EGShareChannel* EGShareChannel_Values[5];
static EGShareChannel* EGShareChannel_facebook_Desc;
static EGShareChannel* EGShareChannel_twitter_Desc;
static EGShareChannel* EGShareChannel_email_Desc;
static EGShareChannel* EGShareChannel_message_Desc;


@interface EGShareItem : NSObject {
@protected
    NSString* _text;
    NSString* _subject;
}
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) NSString* subject;

+ (instancetype)shareItemWithText:(NSString*)text subject:(NSString*)subject;
- (instancetype)initWithText:(NSString*)text subject:(NSString*)subject;
- (CNClassType*)type;
+ (EGShareItem*)applyText:(NSString*)text;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGShareContent : NSObject {
@protected
    NSString* _text;
    NSString* _image;
    NSDictionary* _items;
}
@property (nonatomic, readonly) NSString* text;
@property (nonatomic, readonly) NSString* image;
@property (nonatomic, readonly) NSDictionary* items;

+ (instancetype)shareContentWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items;
- (instancetype)initWithText:(NSString*)text image:(NSString*)image items:(NSDictionary*)items;
- (CNClassType*)type;
+ (EGShareContent*)applyText:(NSString*)text image:(NSString*)image;
- (EGShareContent*)addChannel:(EGShareChannelR)channel text:(NSString*)text;
- (EGShareContent*)addChannel:(EGShareChannelR)channel text:(NSString*)text subject:(NSString*)subject;
- (EGShareContent*)twitterText:(NSString*)text;
- (EGShareContent*)facebookText:(NSString*)text;
- (EGShareContent*)emailText:(NSString*)text subject:(NSString*)subject;
- (EGShareContent*)messageText:(NSString*)text;
- (NSString*)textChannel:(EGShareChannelR)channel;
- (NSString*)subjectChannel:(EGShareChannelR)channel;
- (NSString*)imageChannel:(EGShareChannelR)channel;
- (EGShareDialog*)dialog;
- (EGShareDialog*)dialogShareHandler:(void(^)(EGShareChannelR))shareHandler cancelHandler:(void(^)())cancelHandler;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


