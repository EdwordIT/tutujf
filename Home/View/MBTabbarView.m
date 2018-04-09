//
//  MBTabbarView.m
//  MedicalBeauty
//
//  Created by wbzhan on 2017/12/15.
//  Copyright © 2017年 MedicalBeauty. All rights reserved.
//

#import "MBTabbarView.h"
#import <UIButton+WebCache.h>
#import "LoginViewController.h"
@interface MBTabbarView ()

@property (nonatomic, strong) UIImageView     *rotatoImageView;
@property (nonatomic, strong) UIButton        *playBtn;
@property (nonatomic, strong) UIView          *playBtnBgView;
@property (nonatomic, strong) NSMutableArray  *tabBarViews;
@property (nonatomic, strong) UIActivityIndicatorView   *activityView;
@property (nonatomic, strong) UIView          *line;
@end

@implementation MBTabbarView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tabBarViews = [NSMutableArray new];
        self.layer.borderColor = [RGBA(216, 216, 216, 0.5) CGColor];
        self.layer.borderWidth = 0.5;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tabBarViews = [NSMutableArray new];
    }
    return self;
}

- (void)createTabBarWithBackgroundImage:(UIImage *)bgImage buttonsImageName:(NSArray *)buttonsImageName buttonsSelectImageName:(NSArray *)buttonsSelectImageName buttonsTitle:(NSArray *)buttonsTitle isLocation:(BOOL)isLocation{
    
    if (buttonsTitle.count == 0 ||
        buttonsImageName.count == 0 ||
        buttonsSelectImageName.count == 0 ||
        buttonsImageName.count != buttonsSelectImageName.count ||
        buttonsSelectImageName.count != buttonsTitle.count) {
        return;
    }
    
    //add bgImage
    if (bgImage) {
        UIImageView *imageView = [[UIImageView alloc ] initWithImage:bgImage];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    } else {
        self.backgroundColor = RGB(255, 255, 255);//HEX_RGB(0xFAFBFE)
    }
    
    self.line = [UIView new];
    self.line.backgroundColor = RGB(255, 255, 255);
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.hidesWhenStopped = YES;
    
    [self addSubview:self.activityView];
    
    
    // add items
    for (int i = 0; i < buttonsTitle.count; i++) {
        TabBarItem *item = [self createItemWithButtonImageName:[buttonsImageName objectAtIndex:i] buttonButtonSelectImageName:[buttonsSelectImageName objectAtIndex:i] title:[buttonsTitle objectAtIndex:i] selector:@selector(clickItem:) target:self index:i isLocation:isLocation];
        [self addSubview:item];
        CGFloat space = (screen_width - (kSizeFrom750(54)*2) - kSizeFrom750(98)*buttonsTitle.count)/(buttonsTitle.count-1);
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSizeFrom750(54)+(space+kSizeFrom750(98))*i);
            make.width.mas_equalTo(kSizeFrom750(98));
            make.height.top.mas_equalTo(self);
        }];
        [self.tabBarViews addObject:item];
    }

}


- (TabBarItem *)createItemWithButtonImageName:(NSString *)buttonImageName buttonButtonSelectImageName:(NSString *)buttonSelectImageName title:(NSString *)title selector:(SEL)sel target:(id)classObject index:(NSInteger)index isLocation:(BOOL)isLocation {
    //网络加载的图片
    
    //    TabBarItem *item = [[TabBarItem alloc] initWithNormalImage:[UIImage imageNamed:buttonImageName] selectedImage:[UIImage imageNamed:buttonSelectImageName] title:title index:index target:classObject selector:sel];
    TabBarItem *item = [[TabBarItem alloc] initWithNormalImage:buttonImageName selectedImage:buttonSelectImageName title:title index:index target:classObject selector:sel isLocation:isLocation];
    
    return item;
}

#pragma mark - Event Action
- (void)clickItem:(UIButton *)btn {
    
    for(UIView *view in self.subviews) {
        if ([view isKindOfClass:[TabBarItem class]]) {
            
            TabBarItem *item = (TabBarItem *)view;
            [item setSelected:NO];
            
        }
    }
    if ([btn.superview isKindOfClass:[TabBarItem class]] ) {
      
        TabBarItem *item = (TabBarItem *)btn.superview;
        [item setSelected:YES];
    }
    if ([btn.superview.superview isKindOfClass:[TabBarItem class]]) {

        TabBarItem *item = (TabBarItem *)btn.superview.superview;
        [item setSelected:YES];
    }
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItem:)]) {
        [self.delegate didSelectedItem:btn.tag];
    }
}

#pragma mark - Public Methods
- (void)setSelectedIndex:(NSInteger)index {
    if (index < self.tabBarViews.count) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[TabBarItem class]]) {
                TabBarItem *item = (TabBarItem *)view;
                [item setSelected:NO];
            }
        }
        
        TabBarItem *item = self.tabBarViews[index];
        [item setSelected:YES];
    }
}

#pragma mark -- 会crash 测试环境
- (void)setRedPointAtIndex:(NSInteger)index isShow:(BOOL)isShow {
    
        TabBarItem *item = self.tabBarViews[index];
        [item showRedPoint:isShow];
}

- (void)setHidden:(BOOL)hidden {
    super.hidden = hidden;
    
    for (UIView *view in self.tabBarViews) {
        if ([view isKindOfClass:[TabBarItem class]]) {
            TabBarItem *item = (TabBarItem *)view;
            item.hidden = NO;
        }
    }
    
    self.line.hidden = NO;
    self.backgroundColor = [UIColor whiteColor];//HEX_RGB(0xFAFBFE)
}

@end



@interface TabBarItem ()
@property (nonatomic, strong) UIButton *btn;
Strong UIButton *btn2;
Strong UIButton *bgBtn;
@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UIView   *redPoint;
@end

@implementation TabBarItem

- (id)initWithNormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected
                    title:(NSString *)title index:(NSInteger)index
                   target:(id)target selector:(SEL)sel  isLocation:(BOOL)isLocation {
    self = [super init];
    if (self) {
        self.tag = index;
        
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = RECT(0, 0, self.frame.size.width, self.frame.size.height);
        [bgBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        bgBtn.tag = index;
        [self addSubview:bgBtn];
        self.bgBtn = bgBtn;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isLocation) {
            [btn setImage:IMAGEBYENAME(imageNormal) forState:UIControlStateNormal];
        } else {
            [btn sd_setImageWithURL:[NSURL URLWithString:imageNormal] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
        
        
        
        btn.tag = index;
        btn.adjustsImageWhenHighlighted = NO;
        if (isLocation) {
            [btn setImage:IMAGEBYENAME(imageSelected) forState:UIControlStateSelected];
        } else {
            [btn sd_setImageWithURL:[NSURL URLWithString:imageSelected] forState:UIControlStateSelected completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }
        
//        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        btn.imageView.clipsToBounds = YES;
         btn.imageView.contentMode =  UIViewContentModeScaleAspectFill;
         btn.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        [bgBtn addSubview:btn];
        self.btn = btn;
        //        [btn setEnlargeEdgeWithTop:kSizeFrom750(7) right:kSizeFrom750(60) bottom:kSizeFrom750(60) left:kSizeFrom750(60)];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = index;
        btn2.adjustsImageWhenHighlighted = NO;
        [btn2 setTitle:title forState:UIControlStateNormal];
        [btn2 setTitleColor:RGB(1, 1, 1) forState:UIControlStateNormal];
        btn2.titleLabel.font = SYSTEMSIZE(12);
        [btn2 addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        [bgBtn addSubview:btn2];
        self.btn2 = btn2;
        
        [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgBtn.mas_centerX);
            make.bottom.mas_equalTo(self).mas_offset(-kSizeFrom750(5));
            make.height.mas_equalTo(kSizeFrom750(24));
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgBtn.mas_centerX);
            make.centerY.mas_equalTo(self).offset(-kSizeFrom750(13));
            make.width.mas_equalTo(kSizeFrom750(54));
            make.height.mas_equalTo(kSizeFrom750(54));
            
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _btn.selected = YES;
        //        _label.textColor = RGB(10, 224, 173);
        [_btn2 setTitleColor:RGB(255, 45, 18) forState:UIControlStateNormal];
    } else {
        _btn.selected = NO;
        [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //  _label.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
    }
}

- (void)showRedPoint:(BOOL)isShow {
    self.redPoint.hidden = !isShow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
