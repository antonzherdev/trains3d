#import "EGTypes.h"

#import "EGGL.h"
EGPoint egPointApply(EGPointI point) {
    return EGPointMake(point.x, point.y);
}
EGPoint egPointAdd(EGPoint self, EGPoint point) {
    return EGPointMake(self.x + point.x, self.y + point.y);
}
EGPoint egPointSub(EGPoint self, EGPoint point) {
    return EGPointMake(self.x - point.x, self.y - point.y);
}
EGPoint egPointNegate(EGPoint self) {
    return EGPointMake(-self.x, -self.y);
}
double egPointAngle(EGPoint self) {
    return atan2(self.y, self.x);
}
double egPointDot(EGPoint self, EGPoint point) {
    return self.x * point.x + self.y * point.y;
}
double egPointLengthSquare(EGPoint self) {
    return egPointDot(self, self);
}
double egPointLength(EGPoint self) {
    return sqrt(egPointLengthSquare(self));
}
EGPoint egPointMul(EGPoint self, double value) {
    return EGPointMake(self.x * value, self.y * value);
}
EGPoint egPointMid(EGPoint self, EGPoint point) {
    return egPointMul(egPointAdd(self, point), 0.5);
}
double egPointDistanceTo(EGPoint self, EGPoint point) {
    return egPointLength(egPointSub(self, point));
}
EGPoint egPointSet(EGPoint self, double length) {
    return egPointMul(self, length / egPointLength(self));
}
EGPoint egPointNormalize(EGPoint self) {
    return egPointSet(self, 1.0);
}
EGPointI egPointIApply(EGPoint point) {
    return EGPointIMake(lround(point.x), lround(point.y));
}
EGPointI egPointIAdd(EGPointI self, EGPointI point) {
    return EGPointIMake(self.x + point.x, self.y + point.y);
}
EGPointI egPointISub(EGPointI self, EGPointI point) {
    return EGPointIMake(self.x - point.x, self.y - point.y);
}
EGPointI egPointINegate(EGPointI self) {
    return EGPointIMake(-self.x, -self.y);
}
BOOL egRectContains(EGRect self, EGPoint point) {
    return self.left <= point.x && point.x <= self.right && self.top <= point.y && point.y <= self.bottom;
}
void egColorSet(EGColor self) {
    egColor4(self.r, self.g, self.b, self.a);
}
