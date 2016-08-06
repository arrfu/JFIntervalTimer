//
//  JFIntervalTimer.h
//  JFIntervalTimer
//
//  Created by hao123 on 16/8/5.
//  Copyright © 2016年 arrfu. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define MyLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else
#define MyLog(...)
#endif

@interface JFIntervalTimer : NSObject

@property (nonatomic,assign)int sInterval; // 发送最短时间间隔 毫秒

/**
 * 按指定时间间隔发送命令
 */
//-(BOOL)sendCustomCommand:(NSData*)cmd;
-(BOOL)sendCustomCommand:(NSData*)cmd block:(void (^)(NSData *data))block;

/**
 * 清空数据缓存
 */
-(void)cancelAllData;
@end
