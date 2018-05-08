//
//  VKGCDHandle.m
//
//  Created by Senvid on 2018/4/20.
//  Copyright © 2018年 senvid. All rights reserved.
//

#import "VKGCDHandle.h"

@implementation VKGCDHandle

#pragma mark -
#pragma mark - 异步操作
+(void)asyncGlobalBlock:(CompleteBlock)completeBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (completeBlock) completeBlock();
    });
}


#pragma mark -
#pragma mark - 返回主线程
+(void)asyncMainBlock:(CompleteBlock)completeBlock{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completeBlock) completeBlock();
    });
}


#pragma mark -
#pragma mark - 延时执行
+(void)asyncAfter:(CGFloat)time block:(CompleteBlock)completeBlock{
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if (completeBlock) completeBlock();
    });
}


#pragma mark -
#pragma mark - 加锁操作
+(void)lockActionBlock:(LockBlock)lockBlock{
    
    if (lockBlock) {
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        NotifyBlock lockNotify = ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        };
        
        NotifyBlock unLockNotify = ^{
            dispatch_semaphore_signal(semaphore);
        };
        
        lockBlock(lockNotify,unLockNotify);
    }
}


#pragma mark -
#pragma mark - 同步队列
+(void)syncGroupType:(VKQueueType)type actions:(ActionBlock)actionBlock, ...{
    
    dispatch_queue_t queue;
    if (type == VKQueueSerial) {
        queue = dispatch_queue_create("net.senvid.gcd", DISPATCH_QUEUE_SERIAL);
    } else {
        queue = dispatch_queue_create("net.senvid.gcd", DISPATCH_QUEUE_CONCURRENT);
    }
    
    //定义一个指向个数可变的参数列表指针；
    va_list args;
    va_start(args, actionBlock);
    
    if (actionBlock) {
        
        dispatch_sync(queue, ^{
            actionBlock(^{});
        });
        
        while (1) {
            
            //把args的位置指向变参表的下一个变量位置
            ActionBlock otherBlock = va_arg(args, ActionBlock);
            if (otherBlock == nil) break;
            
            dispatch_sync(queue, ^{
                otherBlock(^{});
            });
        }
    }
}


#pragma mark -
#pragma mark - 异步队列
+(void)asyncGroupType:(VKQueueType)type action:(ActionBlock)actionBlock, ...{
    
    dispatch_queue_t queue;
    if (type == VKQueueSerial) {
        queue = dispatch_queue_create("net.senvid.gcd", DISPATCH_QUEUE_SERIAL);
    } else {
        queue = dispatch_queue_create("net.senvid.gcd", DISPATCH_QUEUE_CONCURRENT);
    }
    
    //定义一个指向个数可变的参数列表指针；
    va_list args;
    va_start(args, actionBlock);
    
    if (actionBlock) {
        
        dispatch_async(queue, ^{
            actionBlock(^{});
        });
        
        while (1) {
            
            //把args的位置指向变参表的下一个变量位置
            ActionBlock otherBlock = va_arg(args, ActionBlock);
            if (otherBlock == nil) break;
            
            dispatch_async(queue, ^{
                otherBlock(^{});
            });
        }
    }
}


#pragma mark -
#pragma mark - 异步队列组
+(void)startGroupCompleteBlock:(CompleteBlock)completeBlock group:(ActionBlock)actionBlock, ...{
    
    //创建异步队列和组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //定义一个指向个数可变的参数列表指针；
    va_list args;
    va_start(args, actionBlock);
    
    if (actionBlock) {
        
        //添加第一个事件
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            
            //添加队列完成通知
            actionBlock(^{
                dispatch_group_leave(group);
            });
        });
        
        while (1) {
            
            //把args的位置指向变参表的下一个变量位置
            ActionBlock otherBlock = va_arg(args, ActionBlock);
            if (otherBlock == nil) break;
            
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                
                otherBlock(^{
                    dispatch_group_leave(group);
                });
            });
        }
    }
    
    //添加队列完成的通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completeBlock();
    });
    
    //清空参数列表，并置参数指针args无效。
    va_end(args);
}


@end
