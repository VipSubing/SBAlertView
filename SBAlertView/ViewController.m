//
//  ViewController.m
//  SBAlertView
//
//  Created by qyb on 2018/6/7.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "ViewController.h"
#import "SBAlertHeader.h"
#import "SBAlertButton.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *mainlist;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UILabel *messageLabel;
@property (copy,nonatomic) void (^copyBlock)(NSUInteger index, id <SBAlertDelegate> alertView) ;

@property (nonatomic) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _mainlist = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainlist.delegate = self;
    _mainlist.dataSource = self;
    _mainlist.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_mainlist];
//
    _datas = @[@"message nomal",@"message icon",@"status succss",@"status success countDown",@"status fail", @"error desc" ,@"list content", @"custom",@"sheet",@"items matrix sheet"];
    [_mainlist reloadData];
    
   
}
- (void)injected{
    [self viewDidLoad];
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
        case 2:
        {
            [SBAlertController showSuccessWithMessage:@"commit success!"];
        }
            break;
        case 3:
        {
            [SBAlertController showSuccessWithMessage:@"commit success!" afterTimeInterval:3];
        }
            break;
        case 4:
        {
            [SBAlertController showFailWithMessage:@"commit fail !"];
        }
            break;
        case 5:
        {
            [SBAlertController showErrorWithTitle:@"实名认证未通过" descTitle:@"不通过原因：" desc:@"用户在注册之前，应当仔细阅读本协议，并同意遵守本协议后方可成为注册用户。" completionBlock:^(NSUInteger buttonIndex, id <SBAlertDelegate> alertView) {
                if (buttonIndex == 1) {
                    NSLog(@"do something");
                }
            } cancelButtonTitle:@"关闭" otherButtonTitles:@"重新提交",nil];
        }
            break;
        case 6:
        {
            NSString *message = @"1、平台确认收到您的打款后，会显示新购买的产品；\n2、剩余天数是起息日到投资结束日的统计天数；\n3、理财收益以结算时收益为准，预计收益是估算值。";
            [SBAlertController showAlertWithTitle:@"温馨提醒：" message:message icon:nil titleAttributes:@{kNSTextAlignmentKey:@(NSTextAlignmentLeft)} messageAttributes:@{kNSTextAlignmentKey:@(NSTextAlignmentLeft)} completionBlock:^(NSUInteger buttonIndex, id <SBAlertDelegate> alertView) {
                NSLog(@"do something");
            } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        }
            break;
        case 7:
        {
            [self customAlert];
        }
            break;
        case 8:
        {
            [SBAlertController alertWithContents:nil title:@"Message" cancleTitle:@"cancle"];
        }
            break;
        case 9:
        {
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.itemSize = CGSizeMake(50, 60);
            layout.minimumInteritemSpacing = 10;
            layout.minimumLineSpacing = 10L;
            layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
            [SBAlertController alertWithItemLayout:layout
                                         itemCount:15
                                 itemForRowAtIndex:^UIView *(id<SBAlertDelegate> alertView, NSInteger index) {
                                        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
                                        [item setImage:[UIImage imageNamed:@"tb_risk"] forState:UIControlStateNormal];
                                        [item setTitle:@"Wechat" forState:UIControlStateNormal];
                                        item.titleLabel.font = [UIFont systemFontOfSize:14];
                                        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                        [item setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 15, 0)];
                                        [item setTitleEdgeInsets:UIEdgeInsetsMake(45, 0, 0, 0)];
                                        return item;
                                 } didSelectedItemAtIndex:^(id<SBAlertDelegate> alertView, NSInteger index) {
                                     NSLog(@"selected %ld",index);
                                 }
                                             title:@"标准Item方阵"
                                       cancleTitle:@"cancle"];
        }
            break;
        default:
            break;
    }
}
- (void)show{
    [self customAlert];
    
//    [SBAlertController showSuccessWithMessage:@"Do any additional setup after loading the view, typically from a nib." afterTimeInterval:3];
//    [SBAlertController showSuccessWithMessage:@"你好" afterTimeInterval:0];
//    [SBAlertController showAlertWithTitle:@"" message:@"Do any additional setup after loading the view, typically from a nib." icon:[UIImage imageNamed:@"tb_download"]  completionBlock:^(NSUInteger buttonIndex, id <SBAlertDelegate> alertView) {
//
//    } cancelButtonTitle:@"取消" otherButtonTitles:@"你好",@"在拉",nil];
//    [SBAlertController showWithMessage:@"Do any additional setup after loading the view, typically from a nib."];
}
- (void)customAlert{
    id <SBAlertDelegate> alertView = [SBAlertController alertViewWithStyle:UIAlertControllerStyleAlert];
    NSMutableArray *items = [NSMutableArray new];

    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请输入预约金额：";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.sb_itemSize = CGSizeMake([SBAlertController defaultAlertWidth]-30, 30);
    titleLabel.sb_boundsInsets = UIEdgeInsetsMake(25, 0, 10, 0);
    [items addObject:titleLabel];
    //textField
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"输入金额";
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 5;
    _textField.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.sb_itemSize = CGSizeMake([SBAlertController defaultAlertWidth]-30-50, 40);
    _textField.sb_parallel = YES;
    [items addObject:_textField];
    
    UILabel *unitLabel = [SBAlertController titleLabel];
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.text = @"万元";
    unitLabel.sb_boundsInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    unitLabel.sb_itemSize = CGSizeMake(40, _textField.sb_itemSize.height);
    unitLabel.sb_parallel = YES;
    [items addObject:unitLabel];
    
    //message
    _messageLabel = [UILabel new];
    _messageLabel.font = [UIFont systemFontOfSize:12];
    _messageLabel.textColor = [UIColor redColor];
    _messageLabel.text = @"*您的预约金额超过剩余募集金额，重新填写";
    _messageLabel.sb_itemSize = CGSizeMake([SBAlertController defaultAlertWidth]-30, 25);
    _messageLabel.sb_boundsInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [items addObject:_messageLabel];
    
    //
    
    _copyBlock = ^(NSUInteger index, id <SBAlertDelegate> alertView){
        if (index == 0) {
            //dissmiss
            [alertView dissmiss];
        }else{
            NSLog(@"点击了确定按钮");
        }
        
    };
    SBAlertButton *cancleButton = [SBAlertController cancleButtonWithButtonCount:2];
    cancleButton.tag = baesTag ;
    [cancleButton addActionBlock:_copyBlock tag:cancleButton.tag alertView:alertView];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.sb_itemSize = CGSizeMake(([SBAlertController defaultAlertWidth]-50)/2, 35);
    cancleButton.sb_boundsInsets = UIEdgeInsetsMake(10, 0, 20, 10);
    cancleButton.sb_parallel = YES;
    [items addObject:cancleButton];
    
    SBAlertButton *button = [SBAlertController otherButton];
    button.tag = baesTag + 1;
    [button addActionBlock:_copyBlock tag:button.tag alertView:alertView];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.sb_itemSize = CGSizeMake(cancleButton.sb_itemSize.width, 35);
    button.sb_boundsInsets = UIEdgeInsetsMake(10, 10, 20, 0);
    button.sb_parallel = YES;
    [items addObject:button];
    
    //
    alertView.items = items;
    [alertView reloadData];
    [[SBAlertController shareAlert] showAlert:alertView];
    
    
}

@end
