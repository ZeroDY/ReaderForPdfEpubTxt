//
//  EpubViewController.m
//  BookReader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import "EpubViewController.h"
#import "PageView.h"

@interface EpubViewController ()

@end

@implementation EpubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerBeforeViewController: (UIViewController *)viewController {
    PageView *p = [[PageView alloc] init];
    p.pageIndex = self.currentPageIndex - 1;
    p.htmlUrl = self.htmlUrl;
    return p;
}

- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PageView *p = [[PageView alloc] init];
    p.pageIndex = self.currentPageIndex + 1;
    p.htmlUrl = self.htmlUrl;
    return p;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
