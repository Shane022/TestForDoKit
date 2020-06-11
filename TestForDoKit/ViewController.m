//
//  ViewController.m
//  TestForDoKit
//
//  Created by Shane on 2020/6/11.
//  Copyright © 2020 Shane. All rights reserved.
//

#import "ViewController.h"
#import <DoraemonKit/DoraemonKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DoraemonManager shareInstance] installWithPid:@"84f719dfc21db6e21f27568b65ca55bb"];//productId为在“平台端操作指南”中申请的产品id
}

@end
