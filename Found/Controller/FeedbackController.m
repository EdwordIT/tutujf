//
//  FeedbackController.m
//  TTJF
//
//  Created by wbzhan on 2018/6/4.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "FeedbackController.h"
#import "InputTextView.h"
#import <LPDQuoteImagesView.h>
#import "GradientButton.h"
@interface FeedbackController ()<InputTextViewDelegate,LPDQuoteImagesViewDelegate>
Strong UIView *topView;
Strong UILabel *titleL;
Strong InputTextView *inPutTextView;
Strong LPDQuoteImagesView *imagesView;
Strong GradientButton *uploadBtn;
Strong NSMutableArray *imageArray;
@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"意见反馈";
    self.imageArray = InitObject(NSMutableArray);
    _topView = [[UIView alloc]init];
    _topView.backgroundColor = COLOR_White;
    [self.view addSubview:self.topView];
    
    _titleL = [[UILabel alloc]initWithFrame:RECT(kOriginLeft, kSizeFrom750(20), kContentWidth,kLabelHeight)];
    _titleL.textColor = RGB_51;
    _titleL.text = @"反馈内容";
    _titleL.font = SYSTEMSIZE(28);
    [self.topView addSubview:self.titleL];
    
    _inPutTextView = [[InputTextView alloc] initWithMaxLength:140];
    _inPutTextView.frame = CGRectMake(kOriginLeft, self.titleL.bottom+kSizeFrom750(20), kContentWidth, kSizeFrom750(250));
    _inPutTextView.layer.masksToBounds = YES;
    [_inPutTextView setTextColor:RGB_51 placeHolder:@"欢迎您提出宝贵的意见和建议，帮助我们做的更好~"];
    [_inPutTextView.textView setFont:SYSTEMSIZE(30)];
    _inPutTextView.delegate = self;
    _inPutTextView.tintColor = RGB_183;
    [self.topView addSubview:self.inPutTextView];
    
    UIView *lineV = [[UIView alloc]initWithFrame:RECT(0, self.inPutTextView.bottom+kSizeFrom750(20), screen_width, kLineHeight)];
    lineV.backgroundColor = separaterColor;
    [self.topView addSubview:lineV];
    
    
    _imagesView = [[LPDQuoteImagesView alloc]initWithFrame:CGRectMake(kOriginLeft, lineV.bottom+kSizeFrom750(20),self.inPutTextView.width,kSizeFrom750(150)) withCountPerRowInView:5 cellMargin:kSizeFrom750(20)];
    _imagesView.maxSelectedCount = 5;//最多上传5张
    _imagesView.navcDelegate = self;
    _imagesView.collectionView.scrollEnabled = NO;
    [self.topView addSubview:_imagesView];
    // Do any additional setup after loading the view.
    
    self.topView.frame = RECT(0, kNavHight, screen_width, self.imagesView.bottom+kSizeFrom750(10));
    
    _uploadBtn = [[GradientButton alloc]initWithFrame:RECT(kOriginLeft, self.topView.bottom+kSizeFrom750(80), kContentWidth, kSizeFrom750(80))];
    [_uploadBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadBtn.titleLabel setFont:SYSTEMSIZE(36)];
    [_uploadBtn setTitle:@"提交" forState:UIControlStateNormal];
    _uploadBtn.layer.cornerRadius = kSizeFrom750(80)/2;
    _uploadBtn.layer.masksToBounds = YES;
    [_uploadBtn setGradientColors:@[COLOR_DarkBlue,COLOR_LightBlue]];
    [_uploadBtn setUntouchedColor:COLOR_Btn_Unsel];
    [self.view addSubview:self.uploadBtn];
}
#pragma mark --delegate
-(void)inputTextView:(InputTextView *)view didEdit:(NSString *)editString
{
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (buttonIndex==0) {
            return;
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}
#pragma mark --buttonClick
-(void)uploadBtnClick:(UIButton *)sender{
    
    if ([self checkInfo]) {
        [SVProgressHUD show];
        //先上传图片，上传完成后，返回图片地址链接地址
        NSArray *imgArr = [self getImageDataArray];
        if (imgArr.count==0) {
            //仅仅上传内容，不上传图片
            [self postFeedBack];
            
        }else{
            if (self.imageArray.count==imgArr.count) {//图片已经全部上传完毕
                [self postFeedBack];
            }
            for (int i=0; i<imgArr.count; i++) {
                NSData *imageData = [imgArr objectAtIndex:i];
                NSString *file_id = [CommonUtils getRandomStringWithNum:20];
                NSString *time_stamp = [CommonUtils getCurrentTimestamp];
                NSArray *keysArr = @[kToken,@"file_id",@"time_stamp"];
                NSArray *valuesArr = @[[CommonUtils getToken],file_id,time_stamp];
                [[HttpCommunication sharedInstance] uploadImageWithUrl:uploadImagesUrl keysArray:keysArr valuesArray:valuesArr image:imageData success:^(NSDictionary *successDic) {
                    [self.imageArray addObject:[successDic objectForKey:@"uploadimg"]];
                    if (self.imageArray.count==imgArr.count) {//全部上传完毕
                        [self postFeedBack];
                    }
                } failure:^(NSDictionary *errorDic) {
                    
                }];
                
            }
        }
    }
}
//上传所有反馈内容
-(void)postFeedBack{
    
    //上传内容
    NSArray *contentKeysArr = @[kToken,@"content",@"arr_img_url"];
    NSArray *contentValuesArr = @[[CommonUtils getToken],self.inPutTextView.textView.text,[self getFeedBackStringWithArray:self.imageArray]];
    [[HttpCommunication sharedInstance] postSignRequestWithPath:postSuggestUrl keysArray:contentKeysArr valuesArray:contentValuesArr refresh:nil success:^(NSDictionary *successDic) {
        //延迟两秒后，返回上一页
        [self performSelector:@selector(quit) withObject:nil afterDelay:1];
    } failure:^(NSDictionary *errorDic) {
        
    }];
}
-(void)quit
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)getFeedBackStringWithArray:(NSArray *)array{
    NSString *resault = @"";
    for (int i=0; i<array.count; i++) {
        NSString *imageUrl = [array objectAtIndex:i];
        if (i!=array.count-1) {
            resault = [resault stringByAppendingString:[NSString stringWithFormat:@"%@,",imageUrl]];
        }else{
            resault = [resault stringByAppendingString:imageUrl];
        }
    }
    return resault;
}
#pragma mark --信息可行性校验
-(BOOL)checkInfo
{
    if ([self.inPutTextView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0&&self.imagesView.selectedPhotos.count==0) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return NO;
    }
    return YES;
}
//获取上送数据数组
-(NSArray<NSData *>*)getImageDataArray
{
    NSArray<UIImage *>*imageArray = [NSArray arrayWithArray:self.imagesView.selectedPhotos];
    
    //取得照片数组
    
    NSMutableArray<NSData *>*imageDataArray = [[NSMutableArray alloc] init];
    
    for(UIImage *imageObject in imageArray){
        
        NSData *imageData = UIImageJPEGRepresentation(imageObject, 0.3);
        
//        NSString *encodeData = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //UIImage转换为NSData
        
        [imageDataArray addObject:imageData];
    }
    
    return imageDataArray;
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
