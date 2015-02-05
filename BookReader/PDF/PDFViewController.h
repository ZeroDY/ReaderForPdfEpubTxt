//
//  PDFViewController.h
//  Reader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic) CGPDFDocumentRef pdf;
@property (nonatomic) CGPDFPageRef myPageRef;
@property (nonatomic)  CATiledLayer *tiledLayer;
@property (nonatomic,strong)  UIView *myContentView;
@property (nonatomic,strong)  UIScrollView *scrollView;

//总共页数
@property (nonatomic) int totalPages;
//当前得页面
@property (nonatomic) int currentPage;

- (IBAction)lastPage:(id)sender;

- (IBAction)nextPage:(id)sender;

@end
