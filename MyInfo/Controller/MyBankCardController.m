//
//  MyBankCardController.m
//  TTJF
//
//  Created by wbzhan on 2018/6/12.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "MyBankCardController.h"
#import "MyBankCardCell.h"
#import "BankCardRemindView.h"
#import "MyBankCardModel.h"
@interface MyBankCardController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *tableView;
Strong NSMutableArray *dataArray;
Strong BankCardRemindView *remindView;
Strong MyBankCardModel *baseModel;
Assign BOOL isCanAdd;
@end

@implementation MyBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"我的银行卡";
    self.dataArray = InitObject(NSMutableArray);
    [self.view addSubview:self.tableView];
    [SVProgressHUD show];
    [self getRequest];
    
    //解绑页面
    self.remindView = [[BankCardRemindView alloc]initWithFrame:kScreen_Bounds];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.remindView];
    [self.remindView setHidden:YES];
    WEAK_SELF;
    self.remindView.remindBlock = ^(NSInteger tag) {
        
        [weakSelf.remindView setHidden:YES];
        //
        if (tag==1) {
            //拨打客服电话
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",IsEmptyStr(weakSelf.baseModel.relieve.cust_ser_num)?@"400-000-9899":weakSelf.baseModel.relieve.cust_ser_num];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else{
            //查看银行解绑流程
            [weakSelf goWebViewWithPath:weakSelf.baseModel.relieve.relieve_link];
        }
    };
    
    // Do any additional setup after loading the view.
}
- (void)getRequest{
    NSArray *keysArr = @[kToken];
    NSArray *valuesArr = @[[CommonUtils getToken]];
    [self.dataArray removeAllObjects];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:getBankCardListUrl keysArray:keysArr valuesArray:valuesArr refresh:self.tableView success:^(NSDictionary *successDic) {
        self.baseModel = [MyBankCardModel yy_modelWithJSON:successDic];
        [self.dataArray addObjectsFromArray:self.baseModel.bank_list];
        if ([self.baseModel.add_bank.is_add isEqualToString:@"-1"]) {
            self.isCanAdd = NO;//不可添加银行卡，也不显示按钮
        }else{
             self.isCanAdd = YES;
        }
        [self.tableView reloadData];
        
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(BaseUITableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseUITableView alloc]initWithFrame:RECT(0, kNavHight, screen_width, kViewHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
       
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dataArray.count>0&&self.isCanAdd) {
        return 2;
    }else
        return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&self.dataArray.count>0) {
        return kSizeFrom750(280);
    }else
        return kSizeFrom750(170);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0&&self.dataArray.count>0) {
        return self.dataArray.count;
    }else
        return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&self.dataArray.count>0) {
        static NSString *cellId = @"MyBankCardCell";
        MyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[MyBankCardCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        BankCardModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell loadInfoWithModel:model];
        WEAK_SELF;
        cell.unlinkBankCardBlock = ^(NSString *cardId) {
          //点击解绑类型：1--是快捷充值卡（解绑走提示） 2 ，提现卡（解绑走接口） 3，不可解绑
            if ([model.relieve_type isEqualToString:@"1"]) {
                [weakSelf.remindView setHidden:NO];
            }else if([model.relieve_type isEqualToString:@"2"]){
                //
                NSArray *keysArr = @[kToken,@"card_id"];
                NSArray *valuesArr = @[[CommonUtils getToken],cardId];
                [[HttpCommunication sharedInstance] postSignRequestWithPath:relieveBankCardUrl keysArray:keysArr valuesArray:valuesArr refresh:nil success:^(NSDictionary *successDic) {
                    [self getRequest];
                } failure:^(NSDictionary *errorDic) {
                    
                }];
            }else
                [SVProgressHUD showInfoWithStatus:@"不可解绑"];
        };
        return cell;
    }else{
        static NSString *cellId = @"AddBankCardCell";
        AddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[AddBankCardCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        [cell loadInfoWithModel:self.baseModel.add_bank];
        cell.addBankCardBlock = ^{
            if ([self.baseModel.add_bank.is_add isEqualToString:@"-1"]) {
                //不可添加
                [SVProgressHUD showInfoWithStatus:@"无法添加"];
            }else{
                //调取添加相关内容
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&self.dataArray.count>0) {
        
    }else{
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
