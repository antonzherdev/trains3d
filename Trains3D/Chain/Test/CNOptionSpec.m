#import "chain.h"
#import "Kiwi.h"

SPEC_BEGIN(CNOpionSpec)
    describe(@"CNOption", ^{
        id some = [CNOption opt:@"test"];
        id none = [CNOption none];
        it(@"should execute foreach one time for not null object and no one for null", ^{
            __block int ex = 0;
            [some forEach:^(id o) {
                ex++;
                [[o should] equal:@"test"];
            }];
            [[theValue(ex) should] equal:theValue(1)];
            ex = 0;
            [none forEach:^(id o) {
                ex++;
            }];
            [[theValue(ex) should] equal:theValue(0)];
        });

        it(@"should behave like nil with selectors when it empty", ^{
            [[[some substringFromIndex:3] should] equal:@"t"];
            [[theValue([some length]) should] equal:theValue(4)];

            [[none substringFromIndex:3] shouldBeNil];
            [[theValue([none length]) should] equal:theValue(0)];
        });
        it(@"should return empty option with nil value", ^{
            [[[CNOption opt:nil] should] equal:none];
        });
        it(@".orValue and .or should return self if it's some or value if it's none", ^{
            [[[some getOr:@"def"] should] equal:@"test"];
            [[[none getOr:@"def"] should] equal:@"def"];
            [[[some getOrElse:^id {
                return @"def";
            }] should] equal:@"test"];
            [[[none getOrElse:^id {
                return @"def";
            }] should] equal:@"def"];
        });
        it(@"should be empty for none and defined for some", ^{
            [[theValue([some isEmpty]) should] beNo];
            [[theValue([none isEmpty]) should] beYes];
            [[theValue([some isDefined]) should] beYes];
            [[theValue([none isDefined]) should] beNo];
        });
        it(@".map should return f(self) for some or none", ^{
            [[[some map:^id(id x) {return [x substringFromIndex:2];}] should] equal:@"st"];
            [[[none map:^id(id x) {return [x substringFromIndex:2];}] should] equal:none];
        });
    });
SPEC_END