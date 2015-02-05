//
//  TextPageView.h
//  BookReader
//
//  Created by ZDY on 14-10-22.
//  Copyright (c) 2014年 ZDY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextPageView : UIView


@property (strong, nonatomic) UILabel *textLabel;
@property (strong,nonatomic) UITextView *textView;
@property (nonatomic, strong) NSTextStorage *textStorage;

-(void)labelChange;

@end
