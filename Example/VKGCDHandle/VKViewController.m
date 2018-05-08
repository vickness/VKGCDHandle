//
//  VKViewController.m
//  VKGCDHandle
//
//  Created by 409284801@qq.com on 05/07/2018.
//  Copyright (c) 2018 409284801@qq.com. All rights reserved.
//

#import "VKViewController.h"
#import "VKGCDHandle.h"

@interface VKViewController ()

@end

@implementation VKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //子线程操作
    [VKGCDHandle asyncGlobalBlock:^{
        
        NSLog(@"子线程操作");
        
        //返回主线程
        [VKGCDHandle asyncMainBlock:^{
            
            NSLog(@"返回主线程");
        }];
    }];
    
    
    //延时操作
    [VKGCDHandle asyncAfter:5.0 block:^{
        
        NSLog(@"延迟执行");
    }];
    
    
    //加锁操作
    [VKGCDHandle lockActionBlock:^(NotifyBlock lock, NotifyBlock unlock) {
        
        for (NSInteger i=0; i<10; i++) {
            
            lock();
            NSLog(@"未加锁操作开始%@",@(i));
            
            //延时操作
            [VKGCDHandle asyncGlobalBlock:^{
                
                NSLog(@"未加锁操作结束%@",@(i));
                unlock();
            }];
        }
    }];
    
    
    ActionBlock action1 = ^(NotifyBlock notify){
        
        [VKGCDHandle asyncGlobalBlock:^{
            
            NSLog(@"操作1");
            notify();
        }];
    };
    
    ActionBlock action2 = ^(NotifyBlock notify){
        
        [VKGCDHandle asyncGlobalBlock:^{
            
            NSLog(@"操作2");
            notify();
        }];
    };
    
    ActionBlock action3 = ^(NotifyBlock notify){
        
        [VKGCDHandle asyncGlobalBlock:^{
            
            NSLog(@"操作3");
            notify();
        }];
    };
    
    [VKGCDHandle startGroupCompleteBlock:^{
        
        NSLog(@"操作全部完成");
        
    } group:action1,action2,action3, nil];
    
    
    //同步串行队列
    NSLog(@"同步串行队列");
    [VKGCDHandle syncGroupType:VKQueueSerial actions:action1, action2, action3, nil];
    
    //同步并发队列
    NSLog(@"同步并发队列");
    [VKGCDHandle syncGroupType:VKQueueConcurrent actions:action1, action2, action3, nil];
    
    //异步串行队列
    NSLog(@"异步串行队列");
    [VKGCDHandle asyncGroupType:VKQueueSerial action:action1, action2, action3, nil];
    
    //异步并发队列
    NSLog(@"异步并发队列");
    [VKGCDHandle asyncGroupType:VKQueueConcurrent action:action1, action2, action3, nil];
}


@end

