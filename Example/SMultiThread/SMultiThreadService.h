//
//  SMultiThreadService.h
//  SMultiThread_Example
//
//  Created by Steve on 2019/1/6.
//  Copyright © 2019 王承权. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMultiThreadService : NSObject

+ (void)getMultiNetWorkData: (void(^)(NSDictionary *data))completeBlock;

// 通过信号量将一个异步回调转换为同步返回
+ (NSDictionary *)getOneNetWorkData;

@end

NS_ASSUME_NONNULL_END
