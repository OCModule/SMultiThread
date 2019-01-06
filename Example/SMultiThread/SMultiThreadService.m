//
//  SMultiThreadService.m
//  SMultiThread_Example
//
//  Created by Steve on 2019/1/6.
//  Copyright © 2019 王承权. All rights reserved.
//

static NSString *get_uri = @"https://httpbin.org/get";
static NSString *post_uri = @"https://httpbin.org/post";


#import "SMultiThreadService.h"

@implementation SMultiThreadService

+ (void)getMultiNetWorkData: (void(^)(NSDictionary *data))completeBlock {
    __block NSDictionary *dic1 = nil;
    __block NSDictionary *dic2 = nil;
    __block NSDictionary *dic3 = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("mine.network.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [SMultiThreadService requestWith:get_uri completionHandler:^(NSDictionary *data) {
            dic1 = data;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [SMultiThreadService requestWith:get_uri completionHandler:^(NSDictionary *data) {
            dic2 = data;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [SMultiThreadService requestWith:get_uri completionHandler:^(NSDictionary *data) {
            dic3 = data;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (dic1 && dic2 && dic3) {
            NSLog(@"3 work finished !");
        }
    });
}

+ (NSDictionary *)getOneNetWorkData {
    __block NSDictionary *tempDic = nil;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [SMultiThreadService requestWith:get_uri completionHandler:^(NSDictionary *data) {
        tempDic = data;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return tempDic;
}

+ (void)requestWith: (NSString *)uri completionHandler:(void (^)(NSDictionary *data))completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:uri];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:[request mutableCopy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *tempDic = nil;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        tempDic = [SMultiThreadService dicFromData:data];
        if (tempDic && completionHandler) {
            completionHandler(tempDic);
        }
        NSLog(@"httpCode: %ld", [httpResponse statusCode]);
    }];
    [dataTask resume];
}

+ (NSDictionary *)dicFromData: (NSData *)data {
    NSDictionary *dic = nil;
    dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dic;
}

@end
