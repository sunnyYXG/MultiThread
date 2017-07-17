//
//  ImageData.h
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageData : NSObject

#pragma mark 索引
@property (nonatomic,assign) int index;

#pragma mark 图片数据
@property (nonatomic,strong) NSData *data;

@end
