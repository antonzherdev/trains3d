#import "chain.h"
#import "Kiwi.h"

static BOOL (^const LESS_THAN_3)(id) = ^BOOL(id x) {return [x intValue] < 3;};

SPEC_BEGIN(CNChainSpec)

  describe(@"The CNChain", ^{
      NSArray *s = [NSArray arrayWithObjects:@1, @3, @2, nil];
      it(@"should return the same array without any actions", ^{
          NSArray *r = [[CNChain chainWithCollection:s] array];
          [[r should] equal:s];
          r = [[s chain] array];
          [[r should] equal:s];
      });

      it(@"should filter items with condition", ^{
          NSArray *r = [[s filter:^BOOL(id x) {return [x intValue] <= 2;}] array];
          [[r should] equal:@[@1, @2]];
      });
      it(@"should modify values with map function", ^{
          NSArray *r = [[s map:^id(id x) {return [NSNumber numberWithInt:[x intValue] * 2];}] array];
          [[r should] equal:@[@2, @6, @4]];
      });
      it(@"should perform several operations in one chain", ^{
          NSArray *r = [[[s
                  filter:LESS_THAN_3]
                     map:^id(id x) {return [NSNumber numberWithInt:[x intValue] * 2];}]
                   array];
          [[r should] equal:@[@2, @4]];
      });
      it(@".first should return first value or none", ^{
          [[[[s filter:LESS_THAN_3] first] should] equal:@1];
          [[[[s filter:^BOOL(id x) {
              return NO;
          }] first] should] equal:[CNOption none]];
      });
      it(@".set should return set", ^{
          NSSet *set = [[[NSArray arrayWithObjects:@2, @3, @2, nil] chain] set];
          [[set should] equal:[NSSet setWithObjects:@2, @3, nil]];
      });
      describe(@"should add elements", ^{
          it(@"to beggining from an array", ^{
              NSArray *r = [[[s chain] append:@[@3, @1]] array];
              [[r should] equal:@[@1, @3, @2, @3, @1]];
          });
          it(@"to beggining from a chain", ^{
              NSArray *r = [[[s chain] append:[CNChain chainWithCollection:@[@3, @1]]] array];
              [[r should] equal:@[@1, @3, @2, @3, @1]];
          });
          it(@"to ending from an array", ^{
              NSArray *r = [[[s chain] prepend:@[@3, @1]] array];
              [[r should] equal:@[@3, @1, @1, @3, @2]];
          });
      });
      describe(@"should generate a range", ^{
          it(@"with positive direction", ^{
              NSArray *r = [[CNChain chainWithStart:1 end:6 step:2] array];
              [[r should] equal:@[@1, @3, @5]];
          });
          it(@"with negative direction", ^{
              NSArray *r = [[CNChain chainWithStart:6 end:2 step:2] array];
              [[r should] equal:@[@6, @4, @2]];
          });
      });

      it(@".mul should multiply the chain by a collection", ^{
          NSArray *r = [[[s chain] mul:@[@"a", @"b"]] array];
          [[r should] equal: @[
                  tuple(@1, @"a"), tuple(@1, @"b"),
                  tuple(@3, @"a"), tuple(@3, @"b"),
                  tuple(@2, @"a"), tuple(@2, @"b"),
          ]];
      });
  });

SPEC_END