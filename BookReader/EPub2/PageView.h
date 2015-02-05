//
//  EPubViewController.h
//  BookReader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIViewController<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView  *webview;
@property (nonatomic) int pageIndex;
@property (nonatomic, strong) NSString  *htmlUrl;
@end
