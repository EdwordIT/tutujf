//
//  MIneMidddleCell.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "MIneMiddleCell.h"
#import "MyAccountModel.h"
@interface MIneMiddleCell ()
Strong NSMutableArray *imgArray;
Strong NSMutableArray *textArray;
Strong NSMutableArray *subTextArray;
@end
@implementation MIneMiddleCell

-(void)initSubViews
{
    self.imgArray = InitObject(NSMutableArray);
    self.textArray = InitObject(NSMutableArray);
    self.subTextArray = InitObject(NSMutableArray);
    NSArray *imgArr = [NSArray arrayWithObjects: @"user03.png",@"user04.png",@"user05.png",nil];
    NSArray *titleArray = [NSArray arrayWithObjects: @"我的投资",@"我的红包",@"资金记录",nil];
    NSArray *subTitleArray = [NSArray arrayWithObjects: @"了解投资进度",@"各种红包福利",@"查看资金流向",nil];

    CGFloat viewW = (screen_width - kSizeFrom750(35)*2 - kSizeFrom750(20)*2)/3;
    for (int i=0; i<3; i++) {
        UIView *bgView = InitObject(UIView);
        bgView.frame = RECT(kSizeFrom750(35)+(kSizeFrom750(20)+viewW)*i, kSizeFrom750(25), viewW, kSizeFrom750(216));
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = kSizeFrom750(10);
        bgView.userInteractionEnabled = YES;
        bgView.tag = i;
        [self.contentView addSubview:bgView];
        
        UIImageView *img = InitObject(UIImageView);
        img.frame = RECT(0, kSizeFrom750(25), kSizeFrom750(80), kSizeFrom750(80));
        img.centerX = bgView.width/2;
        img.layer.cornerRadius = kSizeFrom750(10);
        [bgView addSubview:img];
        [img setImage:IMAGEBYENAME(imgArr[i])];
        [self.imgArray addObject:img];
        
        UILabel *textLabel = InitObject(UILabel);
        textLabel.frame = RECT(0, img.bottom+kSizeFrom750(15), bgView.width, kSizeFrom750(35));
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = RGB_51;
        textLabel.font = SYSTEMSIZE(28);
        [bgView addSubview:textLabel];
        textLabel.text = titleArray[i];
        [self.textArray addObject:textLabel];
        
        UILabel *subTextLabel = InitObject(UILabel);
        subTextLabel.frame = RECT(0, textLabel.bottom+kSizeFrom750(5), bgView.width, kSizeFrom750(30));
        subTextLabel.textAlignment = NSTextAlignmentCenter;
        subTextLabel.textColor = RGB_166;
        subTextLabel.text = subTitleArray[i];
        subTextLabel.font = SYSTEMSIZE(24);
        [bgView addSubview:subTextLabel];
        [self.subTextArray addObject:subTextLabel];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
        [bgView addGestureRecognizer:tap1];
        
        
    }
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=COLOR_Background;
        
        [self initSubViews];
        
    }
    return self;
}

-(void)OnTapImage:(UITapGestureRecognizer *)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didTapMIneMiddleAtIndex:)]) {
        [self.delegate didTapMIneMiddleAtIndex:sender.view.tag];
    }
}

-(void)loadInfoWithArray:(NSArray *)dataArray{
    if (dataArray.count>0) {
        for (int i=0; i<3; i++) {
            MyCapitalModel *model = dataArray[i];
            
            UILabel *textLabel = [self.textArray objectAtIndex:i];
            textLabel.text = model.title;
            
            UILabel *subTextLabel = [self.subTextArray objectAtIndex:i];
            subTextLabel.text = model.sub_title;
        }
    }
}
-(void) setModelData:(NSArray *) ary1 ary2:(NSArray *)ary2 ary3:(NSArray *)ary3
{
    for (int i=0; i<3; i++) {
        UIImageView *imgV = [self.imgArray objectAtIndex:i];
        [imgV setImage:[UIImage imageNamed:ary1[i]]];
        
        UILabel *textLabel = [self.textArray objectAtIndex:i];
        textLabel.text = ary2[i];
        
        UILabel *subTextLabel = [self.subTextArray objectAtIndex:i];
        subTextLabel.text = ary3[i];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code108
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
