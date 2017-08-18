//
//  OCCallJSViewController.m
//  SWJSCore
//  OC调用JS的界面
//  Created by shiwei on 2017/8/15.
//  Copyright © 2017年 俊. All rights reserved.
//

#import "OCCallJSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface OCCallJSViewController (){
    
    UITextField *_numberTextF;
    UILabel *_resultL;
    
    dispatch_source_t _timer;
}
/**
 @abstract js上下文
 */
@property(nonatomic, strong)JSContext *context;
@end


@implementation OCCallJSViewController
#pragma mark---->>lazyLoad
-(JSContext *)context {
    
    if (_context == nil) {
        
        _context = [[JSContext alloc] init];
        [_context evaluateScript:[self loadJSFile:@"Test"]];
    }
    
    return _context;
}
-(NSString *)loadJSFile:(NSString *)fileName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *jsScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return jsScript;
}


#pragma mark---->>
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _timer = nil;
}


#pragma mark---->>viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"oc call js";
    self.view.backgroundColor = [UIColor grayColor];
   
    [self setUpSubviews];
    
    
    //测试定时器用
    [self setTimer];
}
-(void)setUpSubviews {
    
    //数字输入
    _numberTextF = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    _numberTextF.placeholder = @"请输入数字";
    _numberTextF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_numberTextF];
    

    //计算按钮
    UIButton *caculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    caculateBtn.frame = CGRectMake(100, 200, 200, 50);
    caculateBtn.backgroundColor = [UIColor blueColor];
    [caculateBtn setTitle:@"调用js方法计算" forState:UIControlStateNormal];
    [caculateBtn addTarget:self action:@selector(caculateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:caculateBtn];
    
    
    //结果显示
    _resultL = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    _resultL.backgroundColor = [UIColor orangeColor];
    _resultL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_resultL];
    
}
-(void)caculateButtonAction:(UIButton *)sender {
    
    NSNumber *inputNumber = [NSNumber numberWithInteger:[_numberTextF.text integerValue]];
    JSValue *function = [self.context objectForKeyedSubscript:@"factorial"];
    JSValue *result = [function callWithArguments:@[inputNumber]];
    
    _resultL.text = [NSString stringWithFormat:@"%@",[result toNumber]];
}


-(void)setTimer {
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 5 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (_timer) {
            
            NSLog(@"*****");
        }
    });
    
    dispatch_resume(_timer);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
