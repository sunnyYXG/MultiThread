//
//  YXGCtrGCD.m
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//

#import "YXGCtrGCD.h"

@interface YXGCtrGCD ()

@end

@implementation YXGCtrGCD

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}

#pragma mark - 界面布局
- (void)layoutUI{
    
}

#pragma mark 将图片显示到界面
-(void)updateImage:(NSData *)imageData{
    
}
#pragma mark 请求图片数据
-(NSData *)requestData{
    NSURL *url=[NSURL URLWithString:@"http://images.apple.com/iphone-6/overview/images/biggest_right_large.png"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}
#pragma mark 加载图片
-(void)loadImage{
    
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
