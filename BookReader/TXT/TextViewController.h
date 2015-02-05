//
//  TextViewController.h
//  Reader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextPageView.h"

@interface TextViewController : UIViewController

@property (nonatomic, strong) NSTextStorage *textStorage;

@property (strong,nonatomic) NSString *text;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageInfoLabel;
@property (strong,nonatomic) NSAttributedString *textContent;
@property (nonatomic) NSInteger totalPages;
@property (nonatomic) NSInteger charsPerPage;
@property (nonatomic) NSInteger textLength;
//@property (nonatomic) NSInteger referCharatersPerPage;
@property (nonatomic) NSInteger charsOfLastPage;
@property (nonatomic) NSRange *rangeOfPages;

@property (nonatomic) UIFont *preferredFont;


@property (nonatomic) NSInteger currentPage;
@property (strong,nonatomic) TextPageView *curPageView;
//@property (strong,nonatomic) TextPageView *addPageView;
//@property (strong,nonatomic) TextPageView *backPageView;


@property (nonatomic) float startX;


@end
