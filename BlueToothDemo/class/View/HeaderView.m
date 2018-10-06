//
//  HeaderView.m
//  BlueToothDemo
//
//  Created by 刘亮 on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    // 搭建扫描按钮
    UIButton *scanBtn = [self setUpBuutonWithTitle:@" 扫描 "];
    UIButton *stopBtn = [self setUpBuutonWithTitle:@" 停止 "];
    [self btnAddConstraintWithBtn:scanBtn andMarginCenterX:-30];
    [self btnAddConstraintWithBtn:stopBtn andMarginCenterX:30];
}

#pragma mark -- 添加自动布局
- (void)btnAddConstraintWithBtn : (UIButton *)btn andMarginCenterX : (CGFloat)marginCenterX{
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:btn
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0];
    
    NSLayoutConstraint *margin = [NSLayoutConstraint constraintWithItem:btn
                                              attribute: marginCenterX < 0? NSLayoutAttributeRight : NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1 constant:marginCenterX];
    
    [self addConstraints:@[centerY,margin]];
}

#pragma mark -搭建 按钮
- (UIButton *)setUpBuutonWithTitle: (NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 设置圆角 显示边框
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = true;
    // 自动布局关闭
    btn.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:btn];
    return btn;
}

- (void)btnClicked: (UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@" 扫描 "]) {
        
        if ([self.delegate respondsToSelector:@selector(headerViewBtnClickedWithType:)]) {
            [self.delegate headerViewBtnClickedWithType:ActionTypeScan];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(headerViewBtnClickedWithType:)]) {
            [self.delegate headerViewBtnClickedWithType:ActionTypeStop];
        }
    }
}

@end
