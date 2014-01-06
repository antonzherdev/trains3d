#import "EGInAppPlat.h"
#import "EGInApp.h"

@class EGInAppProductRequestDelegate;

static NSArray* _curDelegates; 

@interface EGInAppProductRequestDelegate : NSObject<SKProductsRequestDelegate>
- (instancetype)initWithCallback:(void (^)(id <CNSeq>))callback;

+ (instancetype)delegateWithCallback:(void (^)(id <CNSeq>))callback;

@end

@implementation EGInAppProductRequestDelegate {
    void(^_callback)(id<CNSeq>);
}
- (instancetype)initWithCallback:(void (^)(id <CNSeq>))callback {
    self = [super init];
    if (self) {
        _callback = callback;
    }

    return self;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for(NSString* id in response.invalidProductIdentifiers) {
        NSLog(@"Invalid in-app id: %@", id);
    }
    NSArray *products = [[[response.products chain] map:^EGInAppProduct *(SKProduct *x) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:x.priceLocale];
        NSString *formattedString = [numberFormatter stringFromNumber:x.price];
        return [EGInAppProduct inAppProductWithId:x.productIdentifier name:x.localizedTitle price:formattedString];
    }] toArray];
    _callback(products);
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByRemovingObject:self];
    }
}

+ (instancetype)delegateWithCallback:(void (^)(id <CNSeq>))callback {
    return [[self alloc] initWithCallback:callback];
}

@end

@implementation EGInApp
static ODClassType* _EGInApp_type;

+ (void)initialize {
    [super initialize];
    _curDelegates = [NSArray array];
    _EGInApp_type = [ODClassType classTypeWithCls:[EGInApp class]];
}

+ (void)loadProductsIds:(id<CNSeq>)ids callback:(void(^)(id<CNSeq>))callback {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[ids convertWithBuilder:[CNHashSetBuilder hashSetBuilder]]];
    EGInAppProductRequestDelegate *del = [EGInAppProductRequestDelegate delegateWithCallback:callback];
    @synchronized (_curDelegates) {
        _curDelegates = [_curDelegates arrayByAddingObject:del];
    }
    productsRequest.delegate = del;
    [productsRequest start];
}

- (ODClassType*)type {
    return [EGInApp type];
}

+ (ODClassType*)type {
    return _EGInApp_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}
@end


