#import "chain.h"
#import "Kiwi.h"
#import "CNRange.h"

static BOOL (^const LESS_THAN_3)(id) = ^BOOL(id x) {return [x intValue] < 3;};

SPEC_BEGIN(CNChainSpec)

  describe(@"The CNChain", ^{
      NSArray *s = [NSArray arrayWithObjects:@1, @3, @2, nil];
      it(@"should return the same array without any actions", ^{
          NSArray *r = [[CNChain chainWithCollection:s] toArray];
          [[r should] equal:s];
          r = [[s chain] toArray];
          [[r should] equal:s];
      });

      it(@"should filter items with condition", ^{
          NSArray *r = [[s filter:^BOOL(id x) {
              return [x intValue] <= 2;
          }] toArray];
          [[r should] equal:@[@1, @2]];
      });
      it(@"should modify values with map function", ^{
          NSArray *r = [[s map:^id(id x) {
              return [NSNumber numberWithInt:[x intValue] * 2];
          }] toArray];
          [[r should] equal:@[@2, @6, @4]];
      });
      it(@"should perform several operations in one chain", ^{
          NSArray *r = [[[s
                  filter:LESS_THAN_3]
                  map:^id(id x) {
                      return [NSNumber numberWithInt:[x intValue] * 2];
                  }]
                  toArray];
          [[r should] equal:@[@2, @4]];
      });
      it(@".head should return first value or nil", ^{
          [[[[s filter:LESS_THAN_3] head] should] equal:@1];
          BOOL isNil = [[[s filter:^BOOL(id x) {
              return NO;
          }] head] isEmpty];
          [[theValue(isNil) should] beTrue];
      });
      it(@".set should return set", ^{
          NSSet *set = [[[NSArray arrayWithObjects:@2, @3, @2, nil] chain] set];
          [[set should] equal:[NSSet setWithObjects:@2, @3, nil]];
      });
      describe(@"should add elements", ^{
          it(@"to beggining from an array", ^{
              NSArray *r = [[[s chain] append:@[@3, @1]] toArray];
              [[r should] equal:@[@1, @3, @2, @3, @1]];
          });
          it(@"to beggining from a chain", ^{
              NSArray *r = [[[s chain] append:[CNChain chainWithCollection:@[@3, @1]]] toArray];
              [[r should] equal:@[@1, @3, @2, @3, @1]];
          });
          it(@"to ending from an array", ^{
              NSArray *r = [[[s chain] prepend:@[@3, @1]] toArray];
              [[r should] equal:@[@3, @1, @1, @3, @2]];
          });
      });
      describe(@"should generate a range", ^{
          it(@"with positive direction", ^{
              NSArray *r = [[[CNRange rangeWithStart:1 end:6 step:2] chain] toArray];
              [[r should] equal:@[@1, @3, @5]];
          });
          it(@"with negative direction", ^{
              NSArray *r = [[[CNRange rangeWithStart:6 end:2 step:-2] chain] toArray];
              [[r should] equal:@[@6, @4, @2]];
          });
      });

      it(@".mul should multiply the chain by a collection", ^{
          NSArray *r = [[[s chain] mul:@[@"a", @"b"]] toArray];
          [[r should] equal: @[
                  tuple(@1, @"a"), tuple(@1, @"b"),
                  tuple(@3, @"a"), tuple(@3, @"b"),
                  tuple(@2, @"a"), tuple(@2, @"b"),
          ]];
      });
      
      it(@".exclude should exclude element containing in another collection", ^{
          NSArray *r = [[[s chain] exclude:@[@1, @2]] toArray];
          [[r should] equal: @[@3]];
      });
      it(@".intersect should filter elements containing in two collecions", ^{
          NSArray *r = [[[s chain] intersect:@[@1, @2]] toArray];
          [[r should] equal: @[@1, @2]];
      });
      it(@".randomItem should return one random item", ^{
          int i = [[s randomItem] intValue];
          BOOL b = i == 1 || i == 2 || i == 3;
          [[theValue(b) should] beTrue];
      });
      it(@".forEach should enumerate all items", ^{
          __block int sum = 0;
          [s forEach:^(id x) {
              sum += [x intValue];
          }];
          [[theValue(sum) should] equal:@6];
          sum = 0;
          [[s chain] forEach:^(id x) {
              sum += [x intValue];
          }];
          [[theValue(sum) should] equal:@6];
      });
      it(@".count should return count items in chain", ^{
          NSUInteger count = [[s filter:^BOOL(id x) {
              return [x intValue] < 3;
          }] count];
          [[theValue(count) should] equal:@2];
      });
      it(@".reverse shoude reverse collection", ^{
          [[[[s reverse] toArray] should] equal:@[@2, @3, @1]];
          [[[[[s chain] reverse] toArray] should] equal:@[@2, @3, @1]];
      });
      it(@".fold should make fold", ^{
          id r = [s fold:^id(id x, id y) {
              return numi(unumi(x) + unumi(y));
          } withStart:@0];
          [[r should] equal:@6];
      });
      it(@".find should find first compatilable items or none", ^{
          [[[s find:LESS_THAN_3] should] equal:@1];
          BOOL isNil = [[s find:^BOOL(id x) {
              return NO;
          }] isEmpty];
          [[theValue(isNil) should] beTrue];
      });
      it(@".flatMap should concatinate the returning arrays into the one array", ^{
          NSArray *r = [[s flatMap:^id(id x) {
              return [s map:^id(id x2) {
                  return numi(unumi(x) * unumi(x2));
              }];
          }] toArray];
          [[r should] equal:@[@1, @3, @2, @3, @9, @6, @2, @6, @4]];
          r = [[s flatMap:^id(id x) {
              return [[s map:^id(id x2) {
                  return numi(unumi(x) * unumi(x2));
              }] toArray];
          }] toArray];
          [[r should] equal:@[@1, @3, @2, @3, @9, @6, @2, @6, @4]];
      });
      it(@".distinct should filter unique items", ^{
          NSArray *r = [[@[@1, @3, @2, @3, @1, @0] distinct] toArray];

          [[r should] equal:@[@1, @3, @2, @0]];
      });
  });

SPEC_END