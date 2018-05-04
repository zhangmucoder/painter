//
//  PainterView.m
//  painter
//
//  Created by zhangmucoder on 2018/5/4.
//  Copyright © 2018年 Zhangmucoder. All rights reserved.
//

#import "PainterView.h"
#import "PainterContent.h"
#import "NSFileManager+Helper.h"
@interface PainterView ()
{
    PainterContent *_content;
    UIImage *_tmpImage;
}
@property (nonatomic, strong) NSMutableArray <UIBezierPath *>*paths;
@property (nonatomic, assign) BOOL isDo;
@end


@implementation PainterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _paintColor = [UIColor blackColor];
        _paintWidth = 10.f;
        self.backgroundColor = [UIColor clearColor];
        [self getSettingType:^(setType type) {
            switch (type) {
                case setTypeBack:
                    {
                        if ([self.undoManager canUndo]) {
                            self.isDo = YES;
                            [self.undoManager undo];
                        }
                    }
                    break;
                case setTypeForward:
                    {
                        if ([self.undoManager canRedo]) {
                            self.isDo = YES;
                            [self.undoManager redo];
                        }
                    }
                    break;
                default:
                    break;
            }
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_tmpImage) {
        [_tmpImage drawAtPoint:CGPointZero];
    }
    if (self.isDo) {
        for (UIBezierPath *path in self.paths) {
            _content = [PainterContent new];
            _content.color = _paintColor;
            _content.path.lineWidth = _paintWidth;
            _content.path = path;
            [_content.color setStroke];
            if (_content.color == [UIColor clearColor]) {
                CGContextSetBlendMode(context, kCGBlendModeClear);
            }else {
                CGContextSetBlendMode(context, kCGBlendModeNormal);
            }
            [_content.path stroke];
        }
        _tmpImage = [self imageRepresentation];
        self.isDo = !self.isDo;
    }else{
        [_content.color setStroke];
        if (_content.color == [UIColor clearColor]) {
            CGContextSetBlendMode(context, kCGBlendModeClear);
        }else {
            CGContextSetBlendMode(context, kCGBlendModeNormal);
        }
        [_content.path stroke];
    }
    [super drawRect:rect];
}

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}
- (UIImage *)imageRepresentation
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.undoManager beginUndoGrouping];
    CGPoint point = [self touchPoint:touches];
    _content = [PainterContent new];
    _content.color = _paintColor;
    _content.path.lineWidth = _paintWidth;
    [_content.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint previousPoint2 = _content.path.currentPoint; //begin
    CGPoint previousPoint1 = [self touchPrePoint:touches]; //previous
    CGPoint currentPoint = [self touchPoint:touches]; //current
    CGPoint mid1 = midPoint(previousPoint1, currentPoint);
    [_content.path addQuadCurveToPoint:mid1 controlPoint:previousPoint1];
    
    CGFloat minX = MIN(MIN(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat minY = MIN(MIN(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat maxX = MAX(MAX(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat maxY = MAX(MAX(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat space = _paintWidth * 0.5 + 1;
    CGRect drawRect = CGRectMake(minX-space, minY-space, maxX-minX+_paintWidth, maxY-minY+_paintWidth);
    
    [self setNeedsDisplayInRect:drawRect];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint previousPoint2 = _content.path.currentPoint;
    CGPoint previousPoint1 = [self touchPrePoint:touches];
    CGPoint currentPoint = [self touchPoint:touches];
    [_content.path addQuadCurveToPoint:currentPoint controlPoint:previousPoint1];
    
    CGFloat minX = MIN(MIN(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat minY = MIN(MIN(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat maxX = MAX(MAX(previousPoint2.x, previousPoint1.x), currentPoint.x);
    CGFloat maxY = MAX(MAX(previousPoint2.y, previousPoint1.y), currentPoint.y);
    CGFloat space = _paintWidth * 0.5 + 1;
    CGRect drawRect = CGRectMake(minX-space, minY-space, maxX-minX+_paintWidth+2, maxY-minY+_paintWidth+2);
    
    [self setNeedsDisplayInRect:drawRect];
    //保存截图
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    _tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self addPath:_content.path];
    [self.undoManager endUndoGrouping];
}

- (CGPoint)touchPrePoint:(NSSet<UITouch *> *)touches
{
    UITouch *validTouch = nil;
    for (UITouch *touch in touches) {
        if ([touch.view isEqual:self]) {
            validTouch = touch;
            break;
        }
    }
    
    if (validTouch) {
        return [validTouch previousLocationInView:self];
    }
    else {
        return CGPointMake(-1, -1);
    }
}

- (CGPoint)touchPoint:(NSSet<UITouch *> *)touches
{
    UITouch *validTouch = nil;
    for (UITouch *touch in touches) {
        if ([touch.view isEqual:self]) {
            validTouch = touch;
            break;
        }
    }
    
    if (validTouch) {
        return [validTouch locationInView:self];
    }
    else {
        return CGPointMake(-1, -1);
    }
}



- (void)getSettingType:(boardSettingBlock)type
{
    self.stype = type;
}

-(void)addPath:(UIBezierPath *)path
{
    [[self.undoManager prepareWithInvocationTarget:self] removePath:path];
    [self.paths addObject:path];
    if (self.isDo) {
        _tmpImage = nil;
        [self setNeedsDisplay];
    }
}

-(void)removePath:(UIBezierPath *)path
{
    [[self.undoManager prepareWithInvocationTarget:self] addPath:path];
    if ([self.paths containsObject:path]) {
        [self.paths removeObject:path];
        _tmpImage = nil;
        [self setNeedsDisplay];
    }
}

#pragma mark - Lazying
- (NSMutableArray *)paths{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

@end
