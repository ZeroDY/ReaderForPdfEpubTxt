//
//  ViewController.m
//  Reader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import "ViewController.h"
#import "PDFViewController.h"
#import "EPubViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showepub"]) {
    }
}

@end
