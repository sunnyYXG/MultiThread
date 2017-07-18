//
//  ViewController.m
//  MultiThread
//
//  Created by rongyun on 2017/7/17.
//  Copyright © 2017年 YXGang. All rights reserved.
//

#import "ViewController.h"
#import "YXGNSThread.h"
#import "YXGNSThreadConcurrent.h"

#import "YXGBlockOperation.h"
#import "YXGNSInvocationOperation.h"

#import "YXGGCD.h"

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
            [self.navigationController pushViewController:[YXGNSThreadConcurrent new] animated:YES];
//            [self presentViewController:[YXGNSThreadConcurrent new] animated:YES completion:nil];
            break;
        case 1:
            [self.navigationController pushViewController:[YXGBlockOperation new] animated:YES];

//            [self presentViewController:[YXGBlockOperation new] animated:YES completion:nil];
//          [self presentViewController:[YXGNSInvocationOperation new] animated:YES completion:nil];

            break;
        case 2:
            [self.navigationController pushViewController:[YXGGCD new] animated:YES];

//            [self presentViewController:[YXGGCD new] animated:YES completion:nil];

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
