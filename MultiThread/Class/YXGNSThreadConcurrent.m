//
//  YXGCtrNSThreadConcurrent.m
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//  多个线程并发 加载多张图片  以及停止加载

#import "YXGNSThreadConcurrent.h"
#import "ImageData.h"

#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING ([UIScreen mainScreen].bounds.size.width-3*ROW_HEIGHT)/4

@interface YXGNSThreadConcurrent (){
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
    NSMutableArray *_threads;
}

@end

@implementation YXGNSThreadConcurrent

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
    [button addTarget:self action:@selector(loadImageWithMultiThreads) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //停止按钮
    UIButton *buttonStop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStop.frame=CGRectMake(160, self.view.frame.size.height - 50, 100, 25);
    [buttonStop setTitle:@"停止加载" forState:UIControlStateNormal];
    [buttonStop addTarget:self action:@selector(stopLoadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStop];
    
    //创建图片链接
    _imageNames=[NSMutableArray array];
    for (int i=0; i<ROW_COUNT * COLUMN_COUNT; i++) {
        [_imageNames addObject:@"http://pic7.nipic.com/20100515/2001785_115623014419_2.jpg"];
    }
     
}

#pragma mark 将图片显示到界面
-(void)updateImage:(ImageData *)imageData{
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageView = _imageViews[imageData.index];
    imageView.image = image;
    
}
#pragma mark 请求图片数据
-(NSData *)requestData:(int)index{
    //对非最后一张图片加载线程休眠2秒
    if (index!=(ROW_COUNT*COLUMN_COUNT-1)) {
        [NSThread sleepForTimeInterval:2.0];
    }

    NSURL *url=[NSURL URLWithString:@"http://pic7.nipic.com/20100515/2001785_115623014419_2.jpg"];
    [NSThread sleepForTimeInterval:3];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}
#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    NSLog(@"thread is :%@",[NSThread currentThread]);
    int i = [index intValue];
    NSData *Data = [self requestData:i];
    
    NSThread *currentThread=[NSThread currentThread];
    //    如果当前线程处于取消状态，则退出当前线程
    if (currentThread.isCancelled) {
        NSLog(@"thread(%@) will be cancelled!",currentThread);
        [NSThread exit];//取消当前线程
    }
    
    ImageData *imageData = [[ImageData alloc]init];
    imageData.index = i;
    imageData.data = Data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}

#pragma mark 多线程下载多张图片
-(void)loadImageWithMultiThread{
    for (int i=0; i<ROW_COUNT*COLUMN_COUNT; ++i) {
        //        [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:i]];
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        [thread start];
    }
    
}

#pragma mark 多线程下载多张图片 改变加载图片优先级
-(void)loadImageWithMultiThreads{
    _threads = [[NSMutableArray alloc]init];
    NSInteger count = ROW_COUNT * COLUMN_COUNT;
    for (int i=0; i<count; ++i) {
        //NSObject分类扩展方法：可以改为后台线程执行
//        [self performSelectorInBackground:@selector(loadImage:) withObject:[NSNumber numberWithInt:i]];

        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        
        //最后一张图片优先加载
        if (count - 1 == i) {
            thread.threadPriority = 1.0;
        }else{
            thread.threadPriority = 0.5;
        }
        [_threads addObject:thread];
    }
    
    for (NSInteger i = 0; i <count; i ++) {
        NSThread *thread = _threads[i];
        [thread start];
    }
    
}

#pragma mark 停止加载图片
-(void)stopLoadImage{
    for (int i=0; i<ROW_COUNT*COLUMN_COUNT; i++) {
        NSThread *thread= _threads[i];
        //判断线程是否完成，如果没有完成则设置为取消状态
        //注意设置为取消状态仅仅是改变了线程状态而言，并不能终止线程
        if (!thread.isFinished) {
            [thread cancel];
            
        }
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
