//
//  ViewController.m
//  JFIntervalTimer
//
//  Created by hao123 on 16/8/5.
//  Copyright © 2016年 arrfu. All rights reserved.
//  每条命令间的间隔为50ms 间隔参数：sInterval 可修改

#import "ViewController.h"
#import "JFIntervalTimer.h"

@interface ViewController (){
    JFIntervalTimer *_intervalTimer;
}

@property (nonatomic,assign)int sInterval; // 发送最短时间间隔 毫秒
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    _intervalTimer = [[JFIntervalTimer alloc] init];
    _intervalTimer.sInterval = 250; // 设置时间间隔为 毫秒
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 100, 100);
        btn.center = CGPointMake(self.view.center.x, 150*(i+1));
        btn.tag = i;
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:i?@"清空命令":@"发送命令" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

    }
    
}

-(void)btnClick:(UIButton*)sender{
    
    if (sender.tag == 0) {
        // 发送命令
        static int countN = 0;
        countN++;
        
        uint8_t cmd[13]={0x11,0x21,0x11,0x00,0x00,0xff,0xff,0xd0,0x11,0x02,0x01,0x01,0x00};
        cmd[0] = countN;
        NSData *cmdData = [NSData dataWithBytes:cmd length:13];
        
        NSLog(@"start delay:%d",countN);
        
        __weak typeof(self)weakSelf = self;
        [_intervalTimer sendCustomCommand:cmdData block:^(NSData *data) {
            uint8_t *buffer = (uint8_t *)[data bytes];
            [weakSelf myLogArray:buffer length:data.length];
        }];

    }
    else{
        // 清空命令
        [_intervalTimer cancelAllData];
    }
  
}

/**
 * 打印数组
 */
-(void)myLogArray:(uint8_t*)buffer length:(NSInteger)len{
    NSMutableString *tempMStr=[[NSMutableString alloc] init];
    for (int i=0;i<len;i++)
        [tempMStr appendFormat:@"%02x ",buffer[i]];
    NSLog(@"cmd = %@ , len = %ld",tempMStr,(long)len);
}




@end
