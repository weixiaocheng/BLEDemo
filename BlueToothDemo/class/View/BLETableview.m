//
//  BLETableview.m
//  BlueToothDemo
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BLETableview.h"

@interface BLETableview ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_dataList;
}
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation BLETableview

- (UITableView *)tableview{
    if (!_tableview ) {
        _tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _tableview;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI{
    [self addSubview:self.tableview];
    [self addConstraintWithNSLayoutAttribute:NSLayoutAttributeLeft];
    [self addConstraintWithNSLayoutAttribute:NSLayoutAttributeRight];
    [self addConstraintWithNSLayoutAttribute:NSLayoutAttributeTop];
    [self addConstraintWithNSLayoutAttribute:NSLayoutAttributeBottom];
}

- (void)addConstraintWithNSLayoutAttribute: (NSLayoutAttribute )attribute{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:_tableview
                                                            attribute:attribute
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:attribute
                                                           multiplier:1 constant:0];
    [self addConstraint:layout];
}

- (void)setDataList:(NSArray<CBPeripheral *> *)dataList{
    _dataList = dataList;
    [_tableview reloadData];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"idCell"];
    }
    CBPeripheral  *peri = _dataList[indexPath.row];
    cell.textLabel.text = peri.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:false animated:true];
    CBPeripheral  *peri = _dataList[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(BLETableviewSelected:)]) {
        [self.delegate BLETableviewSelected:peri];
    }
}

@end
