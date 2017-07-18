//
//  YXGCtrGCD.m
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//

#import "YXGGCD.h"
#import "ImageData.h"

#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING ([UIScreen mainScreen].bounds.size.width-3*ROW_HEIGHT)/4

@interface YXGGCD (){
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
}

@end

@implementation YXGGCD

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
}

#pragma mark - 界面布局
- (void)layoutUI{
    //创建多个图片控件用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING) + CELL_SPACING, r*ROW_HEIGHT+(r*CELL_SPACING) + 74, ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            //            imageView.backgroundColor=[UIColor redColor];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, self.view.frame.size.height - 50, 100, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThreadSerial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    for (int i=0; i<ROW_COUNT * COLUMN_COUNT; i++) {
        [_imageNames addObject:@"http://pic7.nipic.com/20100515/2001785_115623014419_2.jpg"];
    }

}

#pragma mark 将图片显示到界面
-(void)updateImage:(NSData *)imageData andIndex:(int )index{
    UIImage *image=[UIImage imageWithData:imageData];
    UIImageView *imageView= _imageViews[index];
    imageView.image=image;
}
#pragma mark 请求图片数据
-(NSData *)requestData:(int)index{
    NSURL *url=[NSURL URLWithString:@"http://pic7.nipic.com/20100515/2001785_115623014419_2.jpg"];
    [NSThread sleepForTimeInterval:3];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}
#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    //串行队列中当前线程打印无变化，因为是在一个线程中
    NSLog(@"thread is :%@",[NSThread currentThread]);
    
    int i = [index intValue];
    NSData *data = [self requestData:i];
    //更新UI界面,此处调用了GCD主线程队列的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImage:data andIndex:i];
    });
}

#pragma mark 多线程下载图片  串行队列
-(void)loadImageWithMultiThreadSerial{
    int count = ROW_COUNT * COLUMN_COUNT;
    
    /**
     创建一个串行队列
      "myThread" 队列名称
      DISPATCH_QUEUE_SERIAL 队列类型
     */
    dispatch_queue_t serialQueue = dispatch_queue_create("myThread", DISPATCH_QUEUE_SERIAL);
    //创建多个现程用于填充图片
    for (int i = 0; i < count; i ++) {
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
}

#pragma mark 多线程下载图片  并发队列
-(void)loadImageWithMultiThreadGlobal{
    int count = ROW_COUNT * COLUMN_COUNT;
    
    /**
     创建一个并发队列
     "myThread" 队列名称
     DISPATCH_QUEUE_SERIAL 队列类型
     */
//    dispatch_queue_t serialQueue = dispatch_queue_create("myThread", DISPATCH_QUEUE_CONCURRENT);
//    //创建多个现程用于填充图片
//    for (int i = 0; i < count; i ++) {
//        //异步执行队列任务
//        dispatch_async(serialQueue, ^{
//            [self loadImage:[NSNumber numberWithInt:i]];
//        });
//    }
    
    /*
     实际开发中我们通常不会利用上面的方式重新创建一个并发队列而是使用dispatch_get_global_queue()方法取得一个全局的并发队列（当然如果有多个并发队列可以使用上面的方式创建）
     */
    
    
    
    /**
     获得全局并发队列

      DISPATCH_QUEUE_PRIORITY_DEFAULT 线程优先级
      0 标记参数 目前没用 一般是0
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建多个现程用于填充图片
    for (int i = 0; i < count; i ++) {
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }

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
