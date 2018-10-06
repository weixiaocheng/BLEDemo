//
//  ViewController.m
//  BlueToothDemo
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"

#import "BlueToothTools.h"
#import "HeaderView.h"
#import "BLETableview.h"


@interface ViewController ()<HeaderViewdelegate, BLETableviewDelegate,BlueToothToolsDelegate>
@property (nonatomic, strong) BLETableview *tableView;
@property (nonatomic, strong) BlueToothTools *manager;
@end

#define KSCRWIDTH  (self.view.bounds.size.width)

@implementation ViewController

-(void)dealloc{
    [_manager removeObserver:self forKeyPath:@"periList"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欢迎使用蓝牙Dome";
    [self loadData];
    [self setUpView];
}

- (void)loadData{
    _manager = [BlueToothTools shareInstance];
    _manager.delegate = self;
    [_manager addObserver:self forKeyPath:@"periList" options:NSKeyValueObservingOptionNew || NSKeyValueChangeOldKey context:nil];
}
- (void)setUpView{
    // 设置导航栏 不透明
    self.navigationController.navigationBar.translucent = false;
    HeaderView *headView =[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, KSCRWIDTH, 60)];
    headView.delegate = self;
    headView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:headView];
    NSLayoutConstraint *head_top = [NSLayoutConstraint constraintWithItem:headView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1 constant:0];
    NSLayoutConstraint *head_height = [NSLayoutConstraint constraintWithItem:headView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1 constant:100];
    NSLayoutConstraint *head_left = [NSLayoutConstraint constraintWithItem:headView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1 constant:0];
    NSLayoutConstraint *head_right = [NSLayoutConstraint constraintWithItem:headView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1 constant:0];
    [self.view addConstraints:@[head_top,head_height,head_left,head_right]];
    
    // 搭建tableview
    _tableView = [[BLETableview alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame),KSCRWIDTH,100)];
    _tableView.delegate = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:_tableView];
    
    NSLayoutConstraint *table_top = [NSLayoutConstraint constraintWithItem:_tableView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1
                                                            constant:0];
    
    NSLayoutConstraint *table_bottom = [NSLayoutConstraint constraintWithItem:_tableView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0];
    
    NSLayoutConstraint *table_left = [NSLayoutConstraint constraintWithItem:_tableView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0];
    
    NSLayoutConstraint *table_right = [NSLayoutConstraint constraintWithItem:_tableView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0];
    [self.view addConstraints:@[table_top,table_bottom,table_left,table_right]];
}



#pragma mark --HeaderViewdelegate
- (void)headerViewBtnClickedWithType:(ActionType)actionType{
    if (ActionTypeScan == actionType) {
        NSLog(@"开始扫描");
        [self.manager scan];
    }else{
        NSLog(@"停止扫描");
        [self.manager stop];
    }
}

#pragma mark --BLETableviewDelegate
- (void)BLETableviewSelected:(CBPeripheral *)peripheral{
    NSLog(@"选中的 \n peripheral : %@",peripheral);
    [self.manager connectPeripheralWithPeripheral:peripheral];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"periList"]) {
        [self.tableView setDataList:_manager.periList];
    }
}

#pragma mark --BlueToothToolsDelegate
- (void)blueToothToolsdidDiscoverServicesPeripheral:(CBPeripheral *)peripheral{
    SubViewController *subVC = [[SubViewController alloc] init];
    [self.navigationController pushViewController:subVC animated:true];
}

@end
