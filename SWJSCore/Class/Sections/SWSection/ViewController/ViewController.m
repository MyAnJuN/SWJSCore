//
//  ViewController.m
//  SWJSCore
//  控制器界面
//  Created by shiwei on 2017/8/15.
//  Copyright © 2017年 俊. All rights reserved.
//


#import "ViewController.h"
#import "JSCallOCViewController.h"
#import "OCCallJSViewController.h"


@interface ViewController ()
@end


@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpSubviews];
}
-(void)setUpSubviews {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(87, 100, 200, 30);
    btn.backgroundColor = [UIColor cyanColor];
    btn.tag = 101;
    [btn setTitle:@"JSCallOC" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(87, 150, 200, 30);
    secondBtn.backgroundColor = [UIColor cyanColor];
    secondBtn.tag = 102;
    [secondBtn setTitle:@"OCCallJS" forState:UIControlStateNormal];
    [secondBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondBtn];
}

-(void)buttonClick:(UIButton *)sender {
    
    //进入JS调用OC的界面
    if (sender.tag == 101) {
        
        JSCallOCViewController *jsVC = [JSCallOCViewController new];
        [self.navigationController pushViewController:jsVC animated:YES];
    }
    //进入OC调用JS的界面
    else {
        
        OCCallJSViewController *ocVC  = [OCCallJSViewController new];
        [self.navigationController pushViewController:ocVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
