//
//  PainterView.h
//  painter
//
//  Created by zhangmucoder on 2018/5/4.
//  Copyright © 2018年 Zhangmucoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,setType) {
    setTypeBack,
    setTypeClearAll,
    setTypeForward
    
};
typedef void(^boardSettingBlock)(setType type);

@interface PainterView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, copy) boardSettingBlock stype;
@property (nonatomic, strong, readonly) UIImage *snapImage;
@property (nonatomic, strong) UIColor *paintColor;
@property (nonatomic, assign) CGFloat paintWidth;
@property (nonatomic, strong) Line *currentLine;

@end


