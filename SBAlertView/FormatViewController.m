//
//  FormatViewController.m
//  SBAlertView
//
//  Created by qyb on 2018/6/21.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "FormatViewController.h"
#import "SBAlertHeader.h"
@interface FormatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *mainlist;
@property (nonatomic) NSArray *datas;
@end

@implementation FormatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainlist = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainlist.delegate = self;
    _mainlist.dataSource = self;
    _mainlist.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_mainlist];
    //
    _datas = @[@"format1",@"format2",@"format3",@"format4",@"format5"];
    [_mainlist reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [SBAlertController showFailWithMessage:@"Do any additional setup after loading the view, typically from a nib. Do any additional setup after loading the view, typically from a nib."];
           
        }
            break;
        case 1:
        {
            [SBAlertController showAlertWithTitle:@"Do any additional setup after loading the view, typically from a nib." message:nil icon:[UIImage imageNamed:@"tb_download"] completionBlock:^(NSUInteger buttonIndex, id<SBAlertDelegate> alertView) {
                
            } cancelButtonTitle:@"取消我的下载" otherButtonTitles:@"确定下载",nil];
        }
            break;
        case 2:
        {
            [SBAlertController showAlertWithTitle:@"Do any additional setup after loading the view, typically from a nib." message:@"Do any additional setup after loading the vie" icon:[UIImage imageNamed:@"tb_download"] completionBlock:^(NSUInteger buttonIndex, id<SBAlertDelegate> alertView) {
                
            } cancelButtonTitle:@"取消我的下载" otherButtonTitles:@"确定下载",nil];
        }
            break;
        case 3:
        {
            [SBAlertController showAlertWithTitle:@"Do any additional setup after loading the view, typically from a nib." message:@"Do any additional setup after loading the vie" icon:nil completionBlock:^(NSUInteger buttonIndex, id<SBAlertDelegate> alertView) {
                
            } cancelButtonTitle:@"取消我的下载" otherButtonTitles:@"确定下载",nil];
        }
            break;
        case 4:
        {
            [SBAlertController showAlertWithTitle:@"Do any additional setup after loading the view, typically from a nib." message:@"Do any additional setup after loading the vie" icon:nil completionBlock:^(NSUInteger buttonIndex, id<SBAlertDelegate> alertView) {
                
            } cancelButtonTitle:@"取消我的下载" otherButtonTitles:nil];
        }
            break;
        default:
            break;
    }
}

@end
