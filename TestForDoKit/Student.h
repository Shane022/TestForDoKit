//
//  Student.h
//  TestForDoKit
//
//  Created by Shane on 2020/6/11.
//  Copyright © 2020 Shane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (nonatomic, assign) NSInteger studentID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *score;

@end

NS_ASSUME_NONNULL_END
