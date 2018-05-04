//
//  PainterContent.m
//  painter
//
//  Created by zhangmucoder on 2018/5/4.
//  Copyright © 2018年 Zhangmucoder. All rights reserved.
//

#import "PainterContent.h"

@implementation PainterContent

- (instancetype)init
{
    self = [super init];
    if (self) {
        _path = [UIBezierPath bezierPath];
        _path.lineCapStyle = kCGLineCapRound;
        _path.lineJoinStyle = kCGLineJoinRound;
        _path.lineWidth = 10;
        _path.flatness = 1;
        _color = [UIColor blackColor];
    }
    
    return self;
}

@end
