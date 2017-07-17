//
//  ViewController.m
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//

#import "ViewController.h"
#import "YXGCtrNSThread.h"
#import "YXGCtrNSThreadConcurrent.h"

#import "YXGCtrNSOperation.h"
#import "YXGctrNSInvocationOperation.h"

#import "YXGCtrGCD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)layoutUI{
    CGFloat _w = self.view.frame.size.width/3;
    NSArray *title = @[@"thread",@"operation",@"GCD"];
    for (NSInteger i = 0; i < title.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(_w, 100 + i * 40, _w, 30)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(pushCtr:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor grayColor];
        [self.view addSubview:button];
    }
}

- (void)pushCtr:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self presentViewController:[YXGCtrNSThreadConcurrent new] animated:YES completion:nil];
//            [self.navigationController pushViewController:[YXGCtrNSThread new] animated:YES];
            break;
        case 1:
            [self presentViewController:[YXGctrNSInvocationOperation new] animated:YES completion:nil];

            break;
        case 2:
            [self presentViewController:[YXGCtrGCD new] animated:YES completion:nil];

            break;
 
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
