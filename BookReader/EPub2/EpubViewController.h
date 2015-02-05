//
//  EpubViewController.h
//  BookReader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"

@interface EpubViewController : UIPageViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic) int currentPageIndex;
@property (nonatomic, strong) NSString  *htmlUrl;

@end
