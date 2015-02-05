//
//  TextPageView.m
//  BookReader
//
//  Created by ZDY on 14-10-22.
//  Copyright (c) 2014年 ZDY. All rights reserved.
//

#import "TextPageView.h"

@implementation TextPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect textViewRect = CGRectInset(self.frame, 15.0, 20.0);
        
        // NSTextContainer
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:textViewRect.size];//CGSizeMake(textViewRect.size.width, CGFLOAT_MAX)]; // new in iOS 7.0
        container.widthTracksTextView = YES; // Controls whether the receiveradjusts the width of its bounding rectangle when its text view is resized
        
        
        // NSLayoutManager
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init]; // new in iOS 7.0
        [layoutManager addTextContainer:container];
        
        
        // NSTextStorage subclass
        self.textStorage = [[NSTextStorage alloc] init]; // new in iOS 7.0
        [self.textStorage addLayoutManager:layoutManager];
        
        // set TextStorage
        [self.textStorage beginEditing];
        /* New letterpress text style added to iOS 7 */
        
         NSDictionary *attrsDic = @{NSTextEffectAttributeName: NSTextEffectLetterpressStyle};
         UIKIT_EXTERN NSString *const NSTextEffectAttributeName NS_AVAILABLE_IOS(7_0);          // NSString, default nil: no text effect
         NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] initWithString:@"Letterpress" attributes:attrsDic];
         NSAttributedString *appendAttrString = [[NSAttributedString alloc] initWithString:@" Append:Letterpress"];
         [mutableAttrString appendAttributedString:appendAttrString];
         [_textStorage setAttributedString:mutableAttrString];
        
        
        [self.textStorage endEditing];
        
        
         //UITextView
        UITextView *newTextView            = [[UITextView alloc] initWithFrame:textViewRect textContainer:container];
        newTextView.autoresizingMask       = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        newTextView.keyboardDismissMode    = UIScrollViewKeyboardDismissModeOnDrag;
        newTextView.dataDetectorTypes      = UIDataDetectorTypeAll;
        newTextView.backgroundColor        = [UIColor whiteColor];
        newTextView.hidden                 = NO;
        newTextView.editable               = NO;
        newTextView.pagingEnabled          = YES;
        newTextView.scrollEnabled          = YES;
        newTextView.userInteractionEnabled = YES;
        newTextView.selectable             = YES;
        self.textView                      = newTextView;
       // [self addSubview:self.textView];
        
        //UILabel
        UILabel *newTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 548)];
        newTextLabel.numberOfLines = 0;
        self.textLabel = newTextLabel;
        [self addSubview:self.textLabel];
        
        
//        self.pageNumber = [[UILabel alloc]initWithFrame:CGRectMake(100, 520, 120, 30)];
//        self.pageNumber.textAlignment = NSTextAlignmentCenter;
//        self.pageNumber.textColor = [UIColor blueColor];
//        [self addSubview:self.pageNumber];
    }
    return self;
}

-(void)labelChange
{
    
    [self.textLabel setText:self.textView.text];
    
}


@end
