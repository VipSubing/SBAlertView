//
//  FormatViewController.m
//  SBAlertView
//
//  Created by qyb on 2018/6/21.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "FormatViewController.h"
#import "SBAlertController.h"
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
    _datas = @[@"message nomal",@"message icon",@"status succss",@"status success countDown",@"status fail", @"error desc" ,@"list content", @"custom",@"sheet",@"items matrix sheet"];
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
            [SBAlertController showWithMessage:@"Do any additional setup after loading the view, typically from a nib."];
        }
            break;
        case 1:
        {
            [SBAlertController showAlertWithTitle:@"Do any additional setup" message:@"Do any additional setup after loading the view, typically from a nib" icon:[UIImage imageNamed:@"tb_download"] completionBlock:^(NSUInteger buttonIndex, id <SBAlertDelegate> alertView) {
                if (buttonIndex == 1) {
                    NSLog(@"sure");
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        }
            break;
        
        default:
            break;
    }
}

@end
