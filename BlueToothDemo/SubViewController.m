//
//  SubViewController.m
//  BlueToothDemo
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SubViewController.h"
#import "BlueToothTools.h"
@interface SubViewController ()<UITableViewDelegate, UITableViewDataSource,BlueToothToolsDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) BlueToothTools *manager;
@end
#define KSCRWIDTH  (self.view.bounds.size.width)
@implementation SubViewController
-(void)dealloc{
    [_manager removeObserver:self forKeyPath:@"printString"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [BlueToothTools shareInstance];
    self.title = _manager.discoverdPeripheral.name;
    [self setUpView];
    [_manager addObserver:self forKeyPath:@"printString" options:NSKeyValueObservingOptionNew context:nil];
}

//2018年10月06日22:03:05 我要睡觉了
- (void)setUpView{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, KSCRWIDTH, 200)];

    _textView.editable = false;

    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 201, KSCRWIDTH, self.view.bounds.size.height - 201)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_textView];
    [self.view addSubview:self.tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.manager.discoverdPeripheral.services.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"idCell"];
    }
    CBService *service = self.manager.discoverdPeripheral.services[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",service.UUID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:false animated:true];
    CBService *service = self.manager.discoverdPeripheral.services[indexPath.row];

    [self.manager.discoverdPeripheral discoverCharacteristics:nil forService:service];
    self.textView.text = [NSString stringWithFormat:@"连接对应的服务: %@",service];
}

- (void)addStringToTextView:(NSString *)string{
    self.textView.text = [NSString stringWithFormat:@"%@ \n %@",self.textView.text, string];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"printString"]) {
        [self addStringToTextView:self.manager.printString];
    }
}

@end
