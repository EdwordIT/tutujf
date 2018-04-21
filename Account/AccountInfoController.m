//
//  AccountInfoController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/19.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "AccountInfoController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "AccountModel.h"
#import "HomeWebController.h"
#import "AccountRealname.h"
#import "AccountPhone.h"
#import "LoginViewController.h"
#import "ChangePasswordViewController.h"
#import "AccountSettingCell.h"
@interface AccountInfoController ()<UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate>
{
    UIWebView * iWebView;
}
Strong AccountModel * accountModel;
Strong BaseUITableView *tableView;
Strong UIButton *existBtn;//退出按钮
Strong NSArray *titleArr;

@end



@implementation AccountInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"设置";
    self.titleArr = @[@"用户头像",@"用户名",@"我的二维码",@"实名认证",@"我的银行卡",@"绑定手机",@"修改密码"];
    [self initSubViews];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [self getRequest];
}

//初始化主界面
-(void)initSubViews{
    self.tableView = [[BaseUITableView alloc] initWithFrame:CGRectMake(0, kNavHight, screen_width, kViewHeight) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = kSizeFrom750(107);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setSeparatorColor:separaterColor];
    [self.view addSubview:self.tableView];
    
    self.existBtn = [[UIButton alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(850), screen_width - kOriginLeft*2, kSizeFrom750(90))];
    self.existBtn.backgroundColor = navigationBarColor;
    [self.existBtn setTitleColor:COLOR_White forState:UIControlStateNormal];
    [self.existBtn.titleLabel setFont:SYSTEMSIZE(34)];
    [self.existBtn addTarget:self action:@selector(existBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.existBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    self.existBtn.layer.cornerRadius = kSizeFrom750(90)/2;
    self.existBtn.layer.masksToBounds = YES;
    [self.tableView addSubview:self.existBtn];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0 ){
        return 3;
    }
    else if (section ==1 ){
        return 3;
    }
    else if (section ==2 ){
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kSizeFrom750(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = COLOR_Background;
    return footerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0)];
    footerView.backgroundColor = COLOR_Background;
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"AccountSettingCell";
    AccountSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[AccountSettingCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self loadCellInfoWith:cell IndexPath:indexPath];
    return cell;
}
//数据加载
-(void)loadCellInfoWith:(AccountSettingCell *)cell IndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.section*3+indexPath.row;
    cell.titleLabel.text = [self.titleArr objectAtIndex:index];
    [cell.rightArrow setHidden:NO];
    [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell.contentView).offset(-kSizeFrom750(60));
    }];
    
    switch (index) {
        case 0:
            {
                //头像
                [cell.rightArrow setHidden:YES];
                [cell.iconImage setHidden:NO];
                
                [cell.iconImage setImage:IMAGEBYENAME(@"icons_portrait")];
            }
            break;
        case 1:
        {
            //用户名
            [cell.rightArrow setHidden:YES];
            cell.contentLabel.text = self.accountModel.user_name;
            [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.contentView).offset(-kOriginLeft);
            }];
        }
            break;
        case 2:
        {//我的二维码
            [cell.codeImage setHidden:NO];
            [cell.codeImage setImage:IMAGEBYENAME(@"icons_code")];
        }
            break;
        case 3:
        {
           //实名认证
            if (IsEmptyStr(self.accountModel.is_realname.card_id)) {
                cell.contentLabel.text = self.accountModel.is_realname.name;
            }else
            {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@  %@",self.accountModel.is_realname.realname,self.accountModel.is_realname.card_id];
                [cell.rightArrow setHidden:YES];
                [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(cell.contentView).offset(-kOriginLeft);
                }];
            }
        }
            break;
        case 4:
        {
            cell.contentLabel.text = self.accountModel.my_bank_statusname;
            //我的银行卡
        }
            break;
        case 5:
        {
            //绑定手机号
             [cell.rightArrow setHidden:YES];
            cell.contentLabel.text = self.accountModel.is_phone.phone_num;
            [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(cell.contentView).offset(-kOriginLeft);
            }];
            
        }
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.section*3+indexPath.row;
    switch (index) {
        case 2:
            {
                //二维码
                HomeWebController *web = InitObject(HomeWebController);
                web.urlStr = self.accountModel.qr_code_url;
                [self.navigationController pushViewController:web animated:YES];
            }
            break;
        case 3:
        {
            //实名认证
            if (IsEmptyStr(self.accountModel.is_realname.card_id)) {
                HomeWebController *web = InitObject(HomeWebController);
                web.urlStr = self.accountModel.is_realname.url;
                [self.navigationController pushViewController:web animated:YES];
            }
        }
            break;
        case 4:
        {
            //银行卡
            HomeWebController *web = InitObject(HomeWebController);
            web.urlStr = self.accountModel.my_bank_url;
            [self.navigationController pushViewController:web animated:YES];
            
        }
            break;
        case 6:
        {
            //修改密码
            ChangePasswordViewController *change = InitObject(ChangePasswordViewController);
            [self.navigationController pushViewController:change animated:YES];
        }
            break;
        default:
            break;
    }
   
}
#pragma mark --数据获取
-(void) getRequest{
   
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getMyAccountUrl keysArray:@[kToken] valuesArray:@[[CommonUtils getToken]] refresh:self.tableView success:^(NSDictionary *successDic) {
        self.accountModel = [AccountModel yy_modelWithJSON:successDic];
        [self.tableView reloadData];
    } failure:^(NSDictionary *errorDic) {
        
    }];
   
}

-(void) existBtnClick:(UIButton *)sender{
 
    [self exitLoginStatus];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"退出登录成功"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) OnLogin{
    [self goLoginVC];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
