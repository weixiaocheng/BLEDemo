//
//  HeaderView.h
//  BlueToothDemo
//
//  Created by 刘亮  on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ActionTypeScan,
    ActionTypeStop
}ActionType;

@protocol HeaderViewdelegate <NSObject>

@optional
- (void)headerViewBtnClickedWithType:(ActionType)actionType;

@end

@interface HeaderView : UIView
@property (nonatomic, weak)id<HeaderViewdelegate>delegate;
@end

NS_ASSUME_NONNULL_END
