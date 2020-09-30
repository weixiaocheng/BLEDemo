//
//  AnalysisTools.h
//  BlueToothDemo
//
//  Created by mac on 2020/6/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ACTIOM_FUNCTTION_0x04, // 计算步数设置
    ACTIOM_FUNCTTION_0x05, // 功能卡关
} ACTIOM_FUNCTTION_TYPE;

@interface AnalysisTools : NSObject
/// 将字符转换成 data 类型
- (NSData *)codeDataWithString: (NSString *)msg;



@end

NS_ASSUME_NONNULL_END
