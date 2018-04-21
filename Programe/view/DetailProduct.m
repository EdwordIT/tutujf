//
//  DetailProduct.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailProduct.h"
#import "JGGView.h"
@interface TitleLabel :UIView
Strong UIImageView *titleImage;

Strong UILabel *textLabel;

@end


@implementation TitleLabel
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleImage = [[UIImageView alloc]initWithFrame:RECT(0, kSizeFrom750(16), kSizeFrom750(6), kSizeFrom750(24))];
        [self.titleImage setImage:IMAGEBYENAME(@"pro_title_left")];
        [self addSubview:self.titleImage];
     
        
        self.textLabel = [[UILabel alloc]initWithFrame:RECT(self.titleImage.right+kSizeFrom750(10), kSizeFrom750(10), kSizeFrom750(500), kSizeFrom750(30))];
        self.textLabel.font = SYSTEMSIZE(26);
        self.textLabel.centerY = self.titleImage.centerY;
        self.textLabel.textColor = HEXCOLOR(@"#666666");
        [self addSubview:self.textLabel];
    }
    return self;
}

@end
@interface DetailProduct()
@end
@implementation DetailProduct

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)initSubViews{
   
}

-(void)loadInfoWithModel:(ProductDetailModel *)model{
    
    [self removeAllSubViews];
    CGFloat totalHeight = 0;
    CGFloat originLeft = kSizeFrom750(30);
    CGFloat spaceTop = kSizeFrom750(20);//间隔
    CGFloat labelHeight = kSizeFrom750(50);
    CGFloat labelWidth = self.width - originLeft*2;
    CGFloat lineHeight = kLineHeight;
   //项目说明
    
    TitleLabel *proLabel = [[TitleLabel alloc]initWithFrame:RECT(originLeft, spaceTop, labelWidth, labelHeight)];
    proLabel.textLabel.text = model.project_desc.title;
    [self addSubview:proLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:RECT(proLabel.left, proLabel.bottom, labelWidth, 0)];
    [subTitleLabel setTextColor:HEXCOLOR(@"#666666")];
    subTitleLabel.numberOfLines = 0;
    [subTitleLabel setFont:SYSTEMSIZE(26)];
    CGFloat subTitleHeight = [CommonUtils getSpaceLabelHeight:model.project_desc.content withFont:subTitleLabel.font withWidth:subTitleLabel.width lineSpace:kSizeFrom750(10)];
    [CommonUtils setAttString:model.project_desc.content withLineSpace:kSizeFrom750(10) titleLabel:subTitleLabel];
    subTitleLabel.height = subTitleHeight+spaceTop/2;
    [self addSubview:subTitleLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:RECT(originLeft, subTitleLabel.bottom, labelWidth, lineHeight)];
    line1.backgroundColor = separaterColor;
    [self addSubview:line1];
    totalHeight = subTitleLabel.bottom;
    //借款人基本信息等
    
    CGFloat borrowerOriginY = 0;//因为借款人每一项信息的类目个数不同，此处用于计算高度
    for (int i=0; i<model.borrower_list.count; i++) {
        BorrowerModel *borrowModel = model.borrower_list[i];
        TitleLabel *borTitle = [[TitleLabel alloc]initWithFrame:RECT(originLeft, totalHeight+borrowerOriginY+spaceTop/2, labelWidth, labelHeight)];
        borTitle.textLabel.text = borrowModel.title;
        [self addSubview:borTitle];
        
        for (int j=0; j<borrowModel.list.count; j++) {
            InfoDetailModel *infoModel = borrowModel.list[j];
            
            UILabel *columLabel = [[UILabel alloc]initWithFrame:RECT(originLeft, borTitle.bottom+spaceTop/2+labelHeight*j, kSizeFrom750(150), labelHeight)];
            columLabel.text = infoModel.title;
            columLabel.font = SYSTEMSIZE(26);
            columLabel.textColor = RGB_166;
            [self addSubview:columLabel];
            
            UILabel *borTextLabel = [[UILabel alloc]initWithFrame:RECT(kSizeFrom750(200), columLabel.top, kSizeFrom750(500), labelHeight)];
            borTextLabel.font = SYSTEMSIZE(26);
            borTextLabel.textColor = RGB_51;
            borTextLabel.text = infoModel.content;
            [self addSubview:borTextLabel];
            
          
            
            if (j==borrowModel.list.count-1) {
                UIView *line2 = [[UIView alloc]initWithFrame:RECT(originLeft, borTextLabel.bottom+spaceTop/2, labelWidth, lineHeight)];
                line2.backgroundColor = separaterColor;
                [self addSubview:line2];
                
                borrowerOriginY = borTextLabel.bottom - totalHeight+spaceTop/2;

            }
            if (i==model.borrower_list.count -1&&j==borrowModel.list.count-1) {
                totalHeight = borTextLabel.bottom;
            }
        }
       
    }
    UIView *bgView = [[UIView alloc]initWithFrame:RECT(originLeft, totalHeight+spaceTop, labelWidth, labelHeight*1.5)];
    bgView.backgroundColor = RGB_233;
    [self addSubview:bgView];
    
    //资料审核
    for (int i=0; i<model.audit_info.list.count +1; i++) {
        AuditColumnModel *auditModel;
        UILabel *auditLabel;
        if (i==0) {
            auditModel = model.audit_info.column;
           auditLabel  = [[UILabel alloc]initWithFrame:RECT(originLeft+kSizeFrom750(20), bgView.centerY - labelHeight/2, kSizeFrom750(300), labelHeight)];

        }else{
            auditModel = [model.audit_info.list objectAtIndex:i-1];
           auditLabel = [[UILabel alloc]initWithFrame:RECT(originLeft+kSizeFrom750(20), (labelHeight+spaceTop)*(i-1)+bgView.bottom+spaceTop/2, kSizeFrom750(300), labelHeight)];
        }
        
        auditLabel.text = auditModel.info_name;
        auditLabel.font = SYSTEMSIZE(26);
        auditLabel.textColor = HEXCOLOR(@"#666666");
        [self addSubview:auditLabel];
        
        UILabel *auditTextLabel = [[UILabel alloc]initWithFrame:RECT(self.width - kSizeFrom750(250), auditLabel.top, kSizeFrom750(200), labelHeight)];
        auditTextLabel.text = auditModel.audit_result;
        auditTextLabel.textAlignment = NSTextAlignmentRight;
        auditTextLabel.font = SYSTEMSIZE(26);
        auditTextLabel.textColor = HEXCOLOR(@"#666666");
        [self addSubview:auditTextLabel];
        
        if (i!=0) {
            UIView *line3 = [[UIView alloc]initWithFrame:RECT(originLeft, auditTextLabel.bottom+spaceTop/2, labelWidth, lineHeight)];
            line3.backgroundColor = separaterColor;
            [self addSubview:line3];
            if (i==model.audit_info.list.count) {
                totalHeight = line3.bottom;
            }
        }
       
    }


    
    NSMutableArray *minarr = InitObject(NSMutableArray);
    NSMutableArray *maxArr = InitObject(NSMutableArray);

    for (NSDictionary *dic in [model.material_pic.pic_list lastObject]) {
        NSString *minurl = [dic objectForKey:@"minimg"];
        NSString *imgurl = [dic objectForKey:@"imgurl"];

        [minarr addObject:minurl];
        [maxArr addObject:imgurl];
    }
    if (minarr.count>0) {
        //项目材料图片
        TitleLabel *picTitle = [[TitleLabel alloc]initWithFrame:RECT(originLeft, totalHeight+spaceTop/2, labelWidth, labelHeight)];
        picTitle.textLabel.text = model.material_pic.title;
        [self addSubview:picTitle];
        
        JGGView *jggView = [[JGGView alloc]initWithFrame:RECT(kSizeFrom750(25), picTitle.bottom+spaceTop/2, kSizeFrom750(700), kSizeFrom750(100))];
        [jggView loadJGGViewWithDataSource:minarr completeBlock:^(NSInteger index, NSArray *dataSource, NSIndexPath *indexpath) {
            
        }];
        jggView.maxDataSource = maxArr;
        jggView.height =  kJGG_GAP*2+((minarr.count-1)/4)*kSizeFrom750(170)+kSizeFrom750(150);
        [self addSubview:jggView];
        
        totalHeight = jggView.bottom+kSizeFrom750(20);
    }else{
        
    }
    
    
    self.height = totalHeight;
    
    if ([self.delegate respondsToSelector:@selector(sendProductHeight:)]) {
        [self.delegate sendProductHeight:totalHeight];
    }
}

@end
