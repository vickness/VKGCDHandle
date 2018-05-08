# VKGCDHandle

[![CI Status](https://img.shields.io/travis/409284801@qq.com/VKGCDHandle.svg?style=flat)](https://travis-ci.org/409284801@qq.com/VKGCDHandle)
[![Version](https://img.shields.io/cocoapods/v/VKGCDHandle.svg?style=flat)](https://cocoapods.org/pods/VKGCDHandle)
[![License](https://img.shields.io/cocoapods/l/VKGCDHandle.svg?style=flat)](https://cocoapods.org/pods/VKGCDHandle)
[![Platform](https://img.shields.io/cocoapods/p/VKGCDHandle.svg?style=flat)](https://cocoapods.org/pods/VKGCDHandle)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

VKGCDHandle is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VKGCDHandle'
```

## Example
```
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
        NSLog(@"加锁操作开始%@",@(i));

        //延时操作
        [VKGCDHandle asyncGlobalBlock:^{

            NSLog(@"加锁操作结束%@",@(i));
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
```

## Author

409284801@qq.com, hbcsw123@163.com

## License

VKGCDHandle is available under the MIT license. See the LICENSE file for more info.
