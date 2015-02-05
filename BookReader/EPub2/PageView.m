//
//  EPubViewController.m
//  BookReader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import "PageView.h"

@interface PageView ()

@end

@implementation PageView

- (void) viewdidload
{
    self.webview = [[UIWebView alloc ] init];
    self.webview.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:self.htmlUrl];
    [self.webview loadRequest: request];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
    NSString *insertRule = [NSString stringWithFormat:@"addCSSRule('html', '-webkit-column-width: 320px;')"];
    [theWebView stringByEvaluatingJavaScriptFromString:insertRule];
    int pageOffset = self.pageIndex * 320;
    [self.webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scroll(%f,0);", pageOffset]];
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
