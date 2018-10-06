//
//  BlueToothTools.h
//  BlueToothDemo
//
//  Created by 刘亮  on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BluetoothState) {
    BluetoothStateDisconnect = 0,
    BluetoothStateScanSuccess = 1,
    BluetoothStateStateScaning = 2,
    BluetoothStateStateConneted = 3,
    BluetoothStateStateConning
};

typedef NS_ENUM(NSInteger, BluetoothFailState) {
    BluetoothFailStateUnExit = 0,
    BluetoothFailStateUnKnow = 1,
    BluetoothFailStateByHw = 2,
    BluetoothFailStateByOff = 3,
    BluetoothFailStateUnauthorized = 4,
    BluetoothFailStateTimout
};

@protocol BlueToothToolsDelegate <NSObject>

@optional

/**
 连接到蓝牙设备时的回调

 @param peripheral <#peripheral description#>
 */
- (void)blueToothToolsdidDiscoverServicesPeripheral: (CBPeripheral*)peripheral;



@end


@interface BlueToothTools : NSObject
@property (nonatomic, strong) NSMutableArray *periList;
@property (nonatomic, strong) CBPeripheral *discoverdPeripheral; // 当前设备
@property (nonatomic, strong) CBCharacteristic *charecteristicl; // 周边设备服务特性
@property (nonatomic, weak) id<BlueToothToolsDelegate>delegate;

@property (nonatomic, strong) NSString *printString; // 打印字符串 
+ (instancetype)shareInstance;

/**
 开始扫描
 */
-(void)scan;

/**
 停止扫描
 */
- (void)stop;


/**
 连接蓝牙

 @param peripheral <#peripheral description#>
 */
- (void)connectPeripheralWithPeripheral: (CBPeripheral *)peripheral;

/*
 *
 */


@end

NS_ASSUME_NONNULL_END
