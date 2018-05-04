//
//  ZMDrawingBoard.m
//  painter
//
//  Created by zhangmucoder on 2018/5/4.
//  Copyright © 2018年 Zhangmucoder. All rights reserved.
//

#import "ZMDrawingBoard.h"
@interface ZMDrawingBoard()

@property (nonatomic, strong) UIImageView *backImage;

@end

@implementation ZMDrawingBoard
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImage.image = [UIImage imageNamed:@"yellowMountainMap"];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backImage];
        [self addSubview:self.drawView];
    }
    return self;
}
- (UIImageView *)backImage
{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _backImage;
}
- (PainterView *)drawView{
    if (!_drawView) {
        _drawView = [PainterView new];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.frame = self.bounds;
    }
    return _drawView;
}

@end
