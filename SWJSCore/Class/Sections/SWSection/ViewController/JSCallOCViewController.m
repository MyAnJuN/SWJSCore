//
//  JSCallOCViewController.m
//  SWJSCore
//  JS调用OC的界面
//  Created by shiwei on 2017/8/15.
//  Copyright © 2017年 俊. All rights reserved.
/**
 1、创建UIWebView(属性存在)及实现UIWebViewDelegate
 2、创建上下文JSContext(很重要)
 3、实现js调用OC
    a、代理的形式
        *自定义协议及方法<继承JSExport>------>>JSExport使自定义的协议都暴露在js文件之下，相当于是js文件协议
        **通过JSExport协议关联Native的方法(使自己成为html代理)--->self.context[@"Native"] = self;
        ***实现自定义协议代理方法(关联Native的方法)
    b、block的形式
        拿到上下文中的某个方法(js文件中的某个方法)，以block的实现
 
 PS:js文件中的方法名和OC中的方法名 必须一模一样！！
 */


#import "JSCallOCViewController.h"


#define kscreenWidth     [UIScreen mainScreen].bounds.size.width
#define kscreenHeight    [UIScreen mainScreen].bounds.size.height


@interface JSCallOCViewController ()<UIWebViewDelegate,JSCallOCDelegate>
/**
 @abstract webView
 */
@property(nonatomic, strong)UIWebView *webView;

/**
 @abstract js上下文
 */
@property(nonatomic, strong)JSContext *context;
@end


@implementation JSCallOCViewController
#pragma mark----->>lazyLoad
/**
 @abstract 创建js的上下文

 @return JSContext
 */
-(JSContext *)context {
    
    if (_context == nil) {
        
        _context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    
    return _context;
}


#pragma mark----->>viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JS Call OC";

    [self setUpSubviews];
}
-(void)setUpSubviews {
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight)];
    self.webView.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JavaScriptCore" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];

    [self.view addSubview:self.webView];
}


#pragma mark----->>UIWebViewDelegate 
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    
    //1.通过JSExport协议关联Native的方法
    self.context[@"Native"] = self;
    
    
    //2.通过block形式关联JavaScript中的函数
    __weak typeof(self) weakself = self;
    weakself.context[@"deliverValue"] = ^(NSString *message) {
        
        __strong typeof(self) strongself = weakself;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This is a message" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [strongself presentViewController:alert animated:YES completion:nil];
    };
    
    
    //捕捉异常回调
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
    
        context.exception = exception;
        NSLog(@"捕获的异常信息:\n%@",exception);
    };
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"error:%@",error);
}



#pragma mark----->>JSExport Method
-(void)callme:(NSString *)string {
    
    NSLog(@"%@",string);
}

-(void)share:(NSString *)shareUrl {
    
    NSLog(@"分享的url=%@",shareUrl);
    
    JSValue *shareCallBack = self.context[@"shareCallBack"];
    [shareCallBack callWithArguments:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
