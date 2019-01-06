//
//  SMViewController.m
//  SMultiThread
//
//  Created by 王承权 on 01/06/2019.
//  Copyright (c) 2019 王承权. All rights reserved.
//

#import "SMViewController.h"
#import "SMultiThreadService.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [SMultiThreadService getOneNetWorkData];
    [SMultiThreadService getMultiNetWorkData:^(NSDictionary * _Nonnull data) {}];
}

@end
