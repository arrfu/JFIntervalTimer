//
//  JFIntervalTimer.m
//  JFIntervalTimer
//
//  Created by hao123 on 16/8/5.
//  Copyright © 2016年 arrfu. All rights reserved.
//  每条命令间的间隔为50ms 间隔参数：sInterval 可修改

#import "JFIntervalTimer.h"

typedef void (^CmdBlock)(NSData *data);

@interface JFIntervalTimer(){ 
    NSMutableArray *_cmdTimerArray;
    NSMutableArray *_cmdDataArray;
    UInt64 oldDate;
}

@property (nonatomic,copy)CmdBlock cmdBlock;

@end

@implementation JFIntervalTimer

-(instancetype)init{
    if (self = [super init]) {
        MyLog(@"---init---");
        self.sInterval = 150; // 默认时间间隔为150毫秒
    }
    
    return self;
}

/**
 * 发送命令：cmd
 * 时间间隔：sInterval
 */
-(BOOL)sendCustomCommand:(NSData*)cmd block:(void (^)(NSData *data))block{
    if (cmd == nil) {
        MyLog(@"error %s",__func__);
        return NO;
    }
    
    self.cmdBlock = block;
    
    if (_cmdDataArray == nil) {
        _cmdDataArray = [[NSMutableArray alloc] init];
    }
    
    [_cmdDataArray addObject:cmd];
    
    
    // 创建定时器
    [self createSendTimer];
    
    return  YES;
}

/**
 * 清空数据缓存
 */
-(void)cancelAllData{
    
    // 取消所有定时器
    [_cmdTimerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSTimer class]]) {
            NSTimer *item = (NSTimer*)obj;
            [item invalidate];
            [_cmdTimerArray removeObject:item];
        }
    }];
    
    
    // 清空数据
    if (_cmdDataArray && _cmdDataArray.count > 0) {
        
        [_cmdDataArray removeAllObjects];
    }
    
    MyLog(@"清空数据缓存");
}


/**
 * 创建定时器
 */
-(void)createSendTimer{
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.sInterval*0.001 target:self selector:@selector(delaySend:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    if (_cmdTimerArray == nil) {
        _cmdTimerArray = [[NSMutableArray alloc] init];
    }
    [_cmdTimerArray addObject:timer];
}

/**
 * 时间延时处理
 */
-(void)delaySend:(NSTimer*)timer{
    
    // 取消该定时器
    [_cmdTimerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[timer class]]) {
            NSTimer *item = (NSTimer*)obj;
            if (item == timer) {
                [item invalidate];
                [_cmdTimerArray removeObject:item];
            }
        }
    }];
    
    if (_cmdDataArray == nil || _cmdDataArray.count <= 0) {
        
        MyLog(@"time stop");
        return ;
    }
    
    UInt64 current = [[NSDate date] timeIntervalSince1970] * 1000; //
    if ( (current - oldDate) < self.sInterval ) {
        // 创建定时器
        [self createSendTimer];
    }
    else{
        // 发送命令
        NSData *cmdData = [_cmdDataArray objectAtIndex:0];

        self.cmdBlock(cmdData);
        
        [_cmdDataArray removeObjectAtIndex:0];
        oldDate = current;
    }
    
    MyLog(@"end delay");
    
}





@end
