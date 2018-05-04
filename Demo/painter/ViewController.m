//
//  ViewController.m
//  painter
//
//  Created by zhangmucoder on 2018/5/4.
//  Copyright © 2018年 Zhangmucoder. All rights reserved.
//

#import "ViewController.h"
#import "ZMDrawingBoard.h"

#define TOOL_BAR_HEIGHT     50.f

@interface ViewController ()

@property (nonatomic, strong) ZMDrawingBoard *painterView;
@property (nonatomic, strong) UIButton *eraserBtn;
@property (nonatomic, strong) UIButton *paintBtn;
@property (nonatomic, strong) UIButton *Back;
@property (nonatomic, strong) UIButton *clearAll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.painterView = [[ZMDrawingBoard alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-TOOL_BAR_HEIGHT)];
    [self.view addSubview:self.painterView];
    
    _eraserBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                           self.view.bounds.size.height-TOOL_BAR_HEIGHT,
                                                           self.view.bounds.size.width/4,
                                                           TOOL_BAR_HEIGHT)];
    _eraserBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _eraserBtn.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    _eraserBtn.layer.borderWidth = 1;
    [_eraserBtn setTitle:@"橡皮擦" forState:UIControlStateNormal];
    [_eraserBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eraserBtn addTarget:self action:@selector(eraserClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eraserBtn];
    
    _paintBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/4, _eraserBtn.frame.origin.y, self.view.bounds.size.width/4, TOOL_BAR_HEIGHT)];
    _paintBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _paintBtn.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    _paintBtn.layer.borderWidth = 1;
    [_paintBtn setTitle:@"画笔" forState:UIControlStateNormal];
    [_paintBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_paintBtn addTarget:self action:@selector(paintClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_paintBtn];
    
    
    _Back = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, _eraserBtn.frame.origin.y, self.view.bounds.size.width/4, TOOL_BAR_HEIGHT)];
    _Back.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _Back.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    _Back.layer.borderWidth = 1;
    [_Back setTitle:@"回退" forState:UIControlStateNormal];
    [_Back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_Back addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_Back];
    
    
    _clearAll = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/4 *3 , _eraserBtn.frame.origin.y, self.view.bounds.size.width/4, TOOL_BAR_HEIGHT)];
    _clearAll.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _clearAll.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    _clearAll.layer.borderWidth = 1;
    [_clearAll setTitle:@"前进" forState:UIControlStateNormal];
    [_clearAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_clearAll addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearAll];
    
    [self paintClicked:nil];
}

- (void)eraserClicked:(id)sender
{
    self.painterView.drawView.paintColor = [UIColor clearColor];
    self.painterView.drawView.paintWidth = 20;
    _eraserBtn.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    _paintBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
}
//清除
- (void)clearClicked:(id)sender
{
    
    if (self.painterView.drawView.stype) {
        self.painterView.drawView.stype(setTypeForward);
    }
}
//回退
- (void)backClicked:(id)sender
{
    if (self.painterView.drawView.stype) {
        self.painterView.drawView.stype(setTypeBack);
    }
}

- (void)paintClicked:(id)sender
{
    self.painterView.drawView.paintColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
    self.painterView.drawView.paintWidth = 12;
    _eraserBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _paintBtn.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
