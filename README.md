# JFIntervalTimer
延时发送定时器，按指定时间间隔发送命令

使用例子:

<pre><oc>

JFIntervalTimer *_intervalTimer = [[JFIntervalTimer alloc] init];
_intervalTimer.sInterval = 250; // 设置时间间隔为 毫秒

uint8_t cmd[13]={0x11,0x21,0x11,0x00,0x00,0xff,0xff,0xd0,0x11,0x02,0x01,0x01,0x00};
   
NSData *cmdData = [NSData dataWithBytes:cmd length:13];

__weak typeof(self)weakSelf = self;
[_intervalTimer sendCustomCommand:cmdData block:^(NSData *data) {
  NSLog(@"%@",data);
}];
        
// 清空命令
[_intervalTimer cancelAllData];

</oc></pre>
