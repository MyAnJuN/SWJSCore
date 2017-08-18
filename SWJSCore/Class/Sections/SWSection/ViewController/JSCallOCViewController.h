//
//  JSCallOCViewController.h
//  SWJSCore
//  JS调用OC的界面
//  Created by shiwei on 2017/8/15.
//  Copyright © 2017年 俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol JSCallOCDelegate <JSExport>

-(void)callme:(NSString *)string;
-(void)share:(NSString *)shareUrl;
@end


@interface JSCallOCViewController : UIViewController
@end
