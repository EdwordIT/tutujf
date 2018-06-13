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
@interface MyBankCardController ()<UITableViewDelegate,UITableViewDataSource>
Strong BaseUITableView *tableView;
Strong NSMutableArray *dataArray;
Strong BankCardRemindView *remindView;
@end

@implementation MyBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"我的银行卡";
    self.dataArray = InitObject(NSMutableArray);
    [self.view addSubview:self.tableView];
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
//            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",IsEmptyStr(weakSelf.configModel.cust_serv_tel)?@"400-000-9899":weakSelf.configModel.cust_serv_tel];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else{
            //查看银行解绑流程
           // [weakSelf goWebViewWithUrl:weakSelf.configModel.com_problem_link];
        }
    };
    
    // Do any additional setup after loading the view.
}
-(void)getRequest{
    
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
    
    return 1+self.dataArray.count>0?1:0;
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
        return cell;
    }else{
        static NSString *cellId = @"AddBankCardCell";
        AddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[AddBankCardCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
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
