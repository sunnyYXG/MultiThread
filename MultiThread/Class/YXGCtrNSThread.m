//
//  YXGCtrNSThread.m
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//

#import "YXGCtrNSThread.h"

@interface YXGCtrNSThread (){
    UIImageView *_imageView;
}

@end

@implementation YXGCtrNSThread

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
}

#pragma mark - 界面布局
- (void)layoutUI{
    _imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height - 100)];
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, _imageView.frame.size.height + 50, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark 将图片显示到界面
-(void)updateImage:(NSData *)imageData{
    UIImage *image = [UIImage imageWithData:imageData];
    _imageView.image = image;
    
}
#pragma mark 请求图片数据
-(NSData *)requestData{
    NSURL *url=[NSURL URLWithString:@"http://pic7.nipic.com/20100515/2001785_115623014419_2.jpg"];
    [NSThread sleepForTimeInterval:5];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}
#pragma mark 加载图片
-(void)loadImage{
    NSData *Data = [self requestData];
    /*将数据显示到UI控件,注意只能在主线程中更新UI,
     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
     waitUntilDone:是否线程任务完成执行
     */
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:Data waitUntilDone:YES];
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    //使用对象方法
//    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //启动线程并不一定立即执行 只是就绪状态 当系统调用才真正执行
//    [thread start];
    
    //使用类方法
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];

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
