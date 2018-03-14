
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KDGoalBarPercentLayer.h"

/*
 self.view.backgroundColor = [UIColor grayColor];
 KDGoalBar*firstGoalBar = [[KDGoalBar alloc]initWithFrame:CGRectMake((320-177)/2., 100, 177, 177)];
 [firstGoalBar setPercent:35 animated:NO];
 [self.view addSubview:firstGoalBar];
 */

@interface KDGoalBar : UIView {
    UIImage * thumb;
    
    KDGoalBarPercentLayer *percentLayer;
    CALayer *thumbLayer;
          
}

@property (nonatomic, strong) UILabel *percentLabel;

- (void)setPercent:(int)percent animated:(BOOL)animated;


@end
