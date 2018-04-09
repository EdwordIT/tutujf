//
//  NoNetController.m
//  TTJF
//
//  Created by 占碧光 on 2017/10/13.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "NoNetController.h"
#import "AppDelegate.h"


@interface NoNetController ()
{
        NSTimer * myTimer;
}

@end

@implementation NoNetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE];
    UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    [image setImage:[UIImage imageNamed:@"webback.jpg"]];
    [self.view addSubview:image];
    // Do any additional setup after loading the view.
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                               target:self
                                             selector:@selector(changeWeb)
                                             userInfo:nil
                                              repeats:YES];
 
}

-(void)changeWeb
{
   [myTimer invalidate];
    myTimer=nil;
    //更换web登录
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
