//
//  BLETableview.h
//  BlueToothDemo
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

@protocol BLETableviewDelegate <NSObject>

@optional
// 返回选中的外设
- (void)BLETableviewSelected:(CBPeripheral *)peripheral;

@end

@interface BLETableview : UIView

@property (nonatomic, weak) id<BLETableviewDelegate>delegate;

- (void)setDataList: (NSArray<CBPeripheral *> *)dataList;
@end

NS_ASSUME_NONNULL_END
