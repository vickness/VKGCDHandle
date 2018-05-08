//
//  VKGCDHandle.h
//
//  Created by Senvid on 2018/4/20.
//  Copyright © 2018年 senvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VKQueueType) {
    VKQueueSerial,
    VKQueueConcurrent,
};

//操作通知
typedef void (^NotifyBlock) (void);
//操作完成
typedef void (^CompleteBlock) (void);
//操作事件
typedef void (^ActionBlock) (NotifyBlock notify);
//加锁事件
typedef void (^LockBlock) (NotifyBlock lock, NotifyBlock unlock);


@interface VKGCDHandle : NSObject


/** 全局异步线程*/
+(void)asyncGlobalBlock:(CompleteBlock)completeBlock;


/** 全局主线程*/
+(void)asyncMainBlock:(CompleteBlock)completeBlock;


/** 添加线程锁*/
+(void)lockActionBlock:(LockBlock)lockBlock;


/** 延迟执行
 @param time 延迟时间
 @param completeBlock 执行事件
 */
+(void)asyncAfter:(CGFloat)time block:(CompleteBlock)completeBlock;


/** 同步队列
 @param type 串行/并发
 @param actionBlock 操作事件
 */
+(void)syncGroupType:(VKQueueType)type actions:(ActionBlock)actionBlock, ...NS_REQUIRES_NIL_TERMINATION;


/** 异步队列
 @param type 串行/并发
 @param actionBlock 操作事件
 */
+(void)asyncGroupType:(VKQueueType)type action:(ActionBlock)actionBlock, ...NS_REQUIRES_NIL_TERMINATION;


/** 队列组
 @param completeBlock 结束事件
 @param actionBlock 操作事件
 */
+(void)startGroupCompleteBlock:(CompleteBlock)completeBlock group:(ActionBlock)actionBlock, ...NS_REQUIRES_NIL_TERMINATION;

@end
