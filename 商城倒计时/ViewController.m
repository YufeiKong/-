//
//  ViewController.m
//  商城倒计时
//
//  Created by Content on 17/3/29.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "ViewController.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()
{
    dispatch_source_t _timer;
}
@property(nonatomic,strong)UILabel *timerLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _timerLabel = [[UILabel alloc]initWithFrame: CGRectMake((kScreenWidth-100)/2,200,100,50)];
    _timerLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:_timerLabel];
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.textColor = [UIColor whiteColor];
    _timerLabel.font = [UIFont systemFontOfSize:14];
    
    
    __block   NSInteger timeout = 10000; //倒计时时间
    
    if (timeout!=0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            
            if(timeout<=0){ //倒计时结束，关闭
                
                dispatch_source_cancel(_timer);
                _timer = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _timerLabel.text = @"00:00:00";
                    
                });
            }else{
                
                NSInteger minutes = (timeout % 3600) / 60;
                NSInteger seconds = timeout % 60;
                NSInteger hours = timeout /3600 ;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                _timerLabel.text = [NSString stringWithFormat:@"%02zd : %02zd : %02zd",(long)hours,(long)minutes,(long)seconds];
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }

    
}



@end
