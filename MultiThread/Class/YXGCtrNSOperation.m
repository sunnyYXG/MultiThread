//
//  YXGCtrNSOperation.m
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//

#import "YXGCtrNSOperation.h"

#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface YXGCtrNSOperation (){
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
}

@end

@implementation YXGCtrNSOperation

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self layoutUI];
}

#pragma mark - 界面布局
- (void)layoutUI{
    //创建多个图片控件用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
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
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
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
    [NSThread sleepForTimeInterval:5];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}
#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i = [index intValue];
    NSData *data = [self requestData:i];
    //更新UI界面,此处调用了主线程队列的方法（mainQueue是UI主线程）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImage:data andIndex:i];
    }];
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    int count = ROW_COUNT * COLUMN_COUNT;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 5;
    
    for (int i = 0; i < count; i++) {
        //方法1：
//        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//            [self loadImage:[NSNumber numberWithInt:i]];
//        }];
//        [queue addOperation:blockOperation];
        //方法2：
        [queue addOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
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
