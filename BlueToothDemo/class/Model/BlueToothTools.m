//
//  BlueToothTools.m
//  BlueToothDemo
//
//  Created by 刘亮  on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BlueToothTools.h"

@interface BlueToothTools ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong)CBCentralManager *manager;



@property (nonatomic, assign) BluetoothFailState bluetoothFailState;
@property (nonatomic, assign) BluetoothState bluetoothState;

/// 记录需要发送消息的对象特性的服务
@property (nonatomic, strong) CBCharacteristic *mesgCb;

@end

static BlueToothTools *_toolsmanger;
@implementation BlueToothTools
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _toolsmanger = [[BlueToothTools alloc] init];
        [_toolsmanger setUpBluetooths];
        
    });
    return _toolsmanger;
}

- (void)setUpBluetooths{
    self.manager = [[CBCentralManager alloc]
                    initWithDelegate:self
                    queue:dispatch_get_main_queue()];
    self.periList = [NSMutableArray array];
}

// 扫描组成部分
-(void)scan{
    [self.manager scanForPeripheralsWithServices:nil options:nil];
    [self scanDevicesContenPeriperalInfos];
}

- (void)stop{
    [self.manager stopScan];
}

// 主动连接蓝牙
- (void)connectPeripheralWithPeripheral: (CBPeripheral *)peripheral{
    [self.manager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES}];
}


-(void)scanDevicesContenPeriperalInfos
{
    //已经被系统或者其他APP连接上的设备数组 Battery
    NSArray *arr =[self.manager retrieveConnectedPeripheralsWithServices: @[[CBUUID UUIDWithString:@"1817"]]];
    NSLog(@"arr : %@",arr);
    for (CBPeripheral *peri in arr) {
        if (![self.periList containsObject:peri]) {
            //            [self.periList addObject:peri];
            [[self mutableArrayValueForKey:@"periList"] addObject:peri];
        }
    }
    
}


#pragma mark --CBCentralManagerDelegate
// 代理检查 蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message ;
    if (central.state != CBManagerStatePoweredOn) {
        
        NSLog(@"fail: status is off ");
        switch (central.state) {
            case CBManagerStatePoweredOff:
                NSLog(@"连接失败 : \n 请您检查一下您的手机蓝牙是否打开 , \n 然后再试一遍吧");
                message = @"请您检查一下您的手机蓝牙是否打开";
                _bluetoothFailState = BluetoothFailStateByOff;
                break;
            case CBManagerStateResetting:
                _bluetoothFailState = BluetoothFailStateTimout;
                NSLog(@"连接失败 : \n 请求超时");
                message = @"蓝牙开启请求超时";
                break;
            case CBManagerStateUnsupported:
                NSLog(@"连接失败 : \n 手机设置不支持 试了也没用 ");
                _bluetoothFailState = BluetoothFailStateByHw;
                message = @"手机设置不支持 试了也没用";
                break;
            case CBManagerStateUnauthorized:
                _bluetoothFailState = BluetoothFailStateUnauthorized;
                NSLog(@"连接失败 : \n 请打开设置 授权之后再试 , \n 然后再试一遍吧");
                message = @"请打开设置 授权之后再试";
                break;
            case CBManagerStateUnknown:
                _bluetoothFailState = BluetoothFailStateUnKnow;
                NSLog(@"连接失败 : \n 未知错误 , \n 然后再试一遍吧");
                message = @"未知错误 再试一遍吧";
                break;
            default:
                break;
        }
    }
}


#pragma mark -- 发现蓝牙设备

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (peripheral.name != nil && ![self.periList containsObject:peripheral]) {
       [[self mutableArrayValueForKey:@"periList"] addObject:peripheral];
       NSLog(@"didDiscoverPeripheral : %@ \n advertisementData : %@ \n RSSI : %@",peripheral, advertisementData,RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接到外设 : %@",peripheral);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    _discoverdPeripheral = peripheral;
    [self.manager stopScan];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error{
    NSLog(@"发现蓝牙设备 :peripheral : %@ \n 包含的服务是 : %@ ",peripheral,service);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"连接蓝牙失败 : %@",peripheral);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error//断开外设的委托
{
    NSLog(@"断开外设的委托 \n peripheral : %@ \n :error %@",peripheral, error);
}


#pragma mark -- CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"连接蓝牙失败 %@",peripheral.name);
        return;
    }
    if ([self.delegate respondsToSelector:@selector(blueToothToolsdidDiscoverServicesPeripheral:)]) {
        [self.delegate blueToothToolsdidDiscoverServicesPeripheral:peripheral];
    }
  
    //遍历所有service
    for (CBService *service in peripheral.services)
    {
                NSString *uuid = [NSString stringWithFormat:@"%@",service.UUID];
        NSLog(@"服务%@",service.UUID);
                //找到你需要的servicesuuid
//        [CBUUID UUIDWithCFUUID:(CFUUIDRef)externalCBUUID]
        if ([uuid isEqualToString: @"FFF0"])
        {
            self.mesgCb = service;
            NSString *str = @"680300006B16";
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//            [peripheral writeValue:data forDescriptor:service];
        //监听它
//        [peripheral discoverCharacteristics:nil forService:service];
        }
    }
   
    
    
    
    NSLog(@"此时链接的peripheral：%@",peripheral);
}

- (void)sendeData: (NSString *)datastring
{
    NSLog(@"dataString : %@", datastring);
    
}

// 连接上 设备 对应的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        NSLog(@"设备 对应的服务 : %@",error.localizedDescription);
        return;
    }
    NSLog(@"设备 对应的服务 \nservice : %@ \n peripheral : %@",service, peripheral);
    self.printString = [NSString stringWithFormat:@"设备 对应的服务 \nservice : %@ \n peripheral : %@",service, peripheral];
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        //        NSString *uuid = [NSString stringWithFormat:@"%@",service.UUID];
        NSLog(@"特征%@",service.UUID);
        self.printString = [NSString stringWithFormat:@"特征%@",service.UUID];
        //发现特征
        //注意：uuid 分为可读，可写，要区别对待！！！
        //        if ([uuid isEqualToString:@"Battery"])
        //        {
        NSLog(@"监听：%@",characteristic);//监听特征
        self.printString = [NSString stringWithFormat:@"监听：%@",characteristic];
        //保存characteristic特征值对象
        //以后发信息也是用这个uuid
        _charecteristicl = characteristic;
        [_discoverdPeripheral readValueForCharacteristic:characteristic];
        [_discoverdPeripheral setNotifyValue:YES forCharacteristic:characteristic];
        //        }
    }
     
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    Byte *testByte = (Byte *)[characteristic.value bytes];
    NSLog(@"testByte : %@",characteristic.value);
    
    NSLog(@"%@", [self parseByteArray2HexString:testByte]);
    NSData *data = [NSData dataWithBytes:testByte length:sizeof(testByte)];
    
    NSString *uuid = [NSString stringWithFormat:@"%@",characteristic.UUID];
//    NSString *stringFromData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"DataToHexStr : %@",[self DataToHexStr:characteristic.value]);
//    NSLog(@"stringFromData : %@ value : %@ ",stringFromData, characteristic.value);
    NSString * hexString  = [NSString stringWithFormat:@"%@", characteristic.value];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@">" withString:@""];
//    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([uuid isEqualToString:@"Battery Level"]) {
        NSLog(@"当前电量是  %ld",(long)[self numberWithHexString:hexString]);
        self.printString = [NSString stringWithFormat:@"当前电量是  %ld",(long)[self numberWithHexString:hexString]];
        return;
    }
    NSString *stringdata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"stringdata : %@",stringdata);
    
    NSLog(@"收到的数据：%@ \n UUID : %@ \n str: %@ ",[self stringFromHexString:hexString], uuid,hexString);
    Byte ctrl = *(testByte+1) & 0x7f;
    NSLog(@"ctrl : %hhu",ctrl);
    self.printString = [NSString stringWithFormat:@"收到的数据：%@ \n UUID : %@ \n str: %@ ",[self stringFromHexString:hexString], uuid,hexString];
    switch (ctrl) {
            case 0x03:
            {
                int power = *(testByte+4);
                NSLog(@"电量 %d", power);
                break;
            }
            case 0x05:
            {
                //读取提醒开关
                Byte type = *(testByte+4);
                if(type == 0x00)
                {
                    break;
                }
                int attention_type = *(testByte+5);
                Byte onoff = *(testByte+6);
                switch (attention_type)
                {
                case 1:
                {
                    NSLog(@"防丢 %02x", onoff);
                   
                    break;
                }
                case 2:
                {
                    NSLog(@"短信 %02x", onoff);
                   
                    break;
                }
                case 3:
                {
                    NSLog(@"电话 %02x", onoff);
                  
                    break;
                }
                default:
                    break;
                }
                
            }
            case 0x20:
            {
                //校时
                break;
            }
            default:
            {
                break;
            }
        }
    
}

//十六进制转换为普通字符串的。
- (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

- (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"字符串%@",unicodeString);
    return unicodeString;
}


-(NSString *) parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];

    int i = 0;

    if(bytes)

    {

        while (bytes[i] != '\0')

        {

            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数

            if([hexByte length]==1)

                [hexStr appendFormat:@"0%@", hexByte];

            else

                [hexStr appendFormat:@"%@", hexByte];

            

            i++;

        }

    }

    NSLog(@"bytes 的16进制数为:%@",hexStr);

    return hexStr;
 
}

- (NSString *)DataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end
