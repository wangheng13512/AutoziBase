//
//  UIRangeExpansionButton.m
//  PalmHospital
//
//  Created by li on 2017/6/13.
//  Copyright © 2017年 朗越(北京)信息技术有限公司. All rights reserved.
//

#import "UIRangeExpansionButton.h"

@implementation UIRangeExpansionButton

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds =self.bounds;
    
    CGFloat widthDelta =64.0- bounds.size.width;
    
    CGFloat heightDelta =64.0- bounds.size.height;
    
    bounds =CGRectInset(bounds, -0.5* widthDelta, -0.5* heightDelta);//注意这里是负数，扩大了之前的bounds的范围
    return CGRectContainsPoint(bounds, point);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
