//
//  GradientButton.m
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "GradientButton.h"
#import "UIImage+Color.h"
@interface GradientButton()
{
    NSArray *gradientColors;//渐变色数组
    UIColor *untouchedColor;//不可点击状态下的颜色
}
@end
@implementation GradientButton
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (gradientColors) {
        [self setBackgroundGradientColors:gradientColors];
    }
    if (untouchedColor) {
        [self setBackgroundImage:[UIImage imageWithColor:untouchedColor] forState:UIControlStateDisabled];
    }
}
- (void)setBackgroundGradientColors:(NSArray<UIColor *> *)colors {
    if (colors.count == 1) { //只有一种颜色，直接上色
        [self setBackgroundColor:colors[0]];
    } else { //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于button属性的frame
        gradientLayer.frame = self.bounds;
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的字体
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        //将背景颜色颜色设为gradientImage模式
//        [self setBackgroundColor:[UIColor colorWithPatternImage:gradientImage]];
        [self setBackgroundImage:gradientImage forState:UIControlStateNormal];
    }
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
-(void)setUntouchedColor:(UIColor *)color{
    untouchedColor = color;
}
//添加渐变数组
- (void)setGradientColors:(NSArray<UIColor *> *)colors{
    gradientColors = [NSArray arrayWithArray:colors];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
