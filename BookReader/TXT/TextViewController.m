//
//  TextViewController.m
//  Reader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    _totalPages = 0;
    _currentPage = 0;
    _textLabel.numberOfLines = 0;
    _preferredFont = [UIFont systemFontOfSize:14];
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionNext:)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionPrevious:)];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenToolBar)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    [self.view  addGestureRecognizer:rightSwipeRecognizer];
    [self.view  addGestureRecognizer:leftSwipeRecognizer];
    [self.view  addGestureRecognizer:singleTap];
    
    
    //第一种分页
    [self pagingOfOne];
    
    //第二种
    //    _textContent = [[NSAttributedString alloc]initWithString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"厚黑学" ofType:@"txt"] encoding:NSUTF8StringEncoding error: nil]];
    //
    //    // 各页面视图初始化
    //    _curPageView  = [[TextPageView alloc] initWithFrame:self.view.bounds];
    ////    _addPageView  = [[TextPageView alloc] initWithFrame:self.view.bounds];
    ////    _backPageView = [[TextPageView alloc] initWithFrame:self.view.bounds];
    ////
    //    // 设置各页面视图的委托
    //    _curPageView.textView.delegate  = self;
    ////    _addPageView.textView.delegate  = self;
    ////    _backPageView.textView.delegate = self;
    //
    //    // 设置初始值
    //    _currentPage  = 0;
    //    _totalPages   = 0;
    //    _charsPerPage = 0;
    //    _textLength   = 0;
    //    //    curoffset    = 0.;
    //    //    alertDelegate = -1;
    //    //    minoffset    = self.view.bounds.size.width / 5;
    //
    //
    //    // 判断是否需要分页并设置currPage的内容
    //    if ([self paging] == NO) {
    //        [_curPageView.textView.textStorage  setAttributedString:_textContent];
    //    }
    //    else {
    //        [_curPageView.textView.textStorage  setAttributedString:[[_textContent attributedSubstringFromRange:NSMakeRange(_currentPage * _charsPerPage, _charsPerPage)] mutableCopy]];
    //    }
    //    [self.curPageView.pageNumber setText:[NSString stringWithFormat:@"%d/%d",_currentPage+1,_totalPages]];
    //    [self.view addSubview:_curPageView];
    //    _curPageView.clipsToBounds = YES;
    //    _curPageView.textView.font = _preferredFont;
    //    _curPageView.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //    _curPageView.textView.dataDetectorTypes   = UIDataDetectorTypeAll;
    //
    //
    
    
}

- (void)hiddenToolBar{
    //[self. setHidden:self.toolbar.isHidden? NO:YES];
    [self.navigationController.navigationBar setHidden:self.navigationController.navigationBar.isHidden ? NO :YES];
    //[self.pageSlider setHidden:self.pageSlider.isHidden ? NO: YES];
    //[self.currentPageLabel setHidden:self.currentPageLabel.isHidden ? NO: YES];
}


//第一种分页
- (void)pagingOfOne
{
    if (!_text) {
        self.text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"厚黑学" ofType:@"txt"] encoding:NSUTF8StringEncoding error: nil];
        
        // 计算文本串的大小尺寸
        NSDictionary *attribute = @{NSFontAttributeName: _preferredFont};
        CGSize totalTextSize = [_text boundingRectWithSize:CGSizeMake(_textLabel.frame.size.width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
        
        // 如果一页就能显示完，直接显示所有文本串即可。
        if (totalTextSize.height < _textLabel.frame.size.height) {
            _textLabel.text = _text;
        }
        else {
            // 计算理想状态下的页面数量和每页所显示的字符数量，只是拿来作为参考值用而已！
            NSUInteger textLength = [_text length];
            NSUInteger referTotalPages = (int)totalTextSize.height/(int)_textLabel.frame.size.height+1;
            NSUInteger referCharatersPerPage = textLength/referTotalPages;
            
            // 申请最终保存页面NSRange信息的数组缓冲区
            int maxPages = referTotalPages;
            _rangeOfPages = ((NSRange *)malloc(referTotalPages*sizeof(NSRange)));
            memset((_rangeOfPages), 0x0, referTotalPages*sizeof(NSRange));
            
            // 页面索引
            int page = 0;
            
            for (NSUInteger location = 0; location < textLength; ) {
                // 先计算临界点（尺寸刚刚超过UILabel尺寸时的文本串）
                NSRange range = NSMakeRange(location, referCharatersPerPage);
                
                NSString *pageText;
                CGSize pageTextSize;
                
                while (range.location + range.length < textLength) {
                    pageText = [_text substringWithRange:range];
                    
                    pageTextSize = [pageText boundingRectWithSize:CGSizeMake(_textLabel.frame.size.width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
                    
                    if (pageTextSize.height > _textLabel.frame.size.height) {
                        break;
                    }
                    else {
                        range.length += referCharatersPerPage;
                    }
                }
                
                if (range.location + range.length >= textLength) {
                    range.length = textLength - range.location;
                }
                
                // 然后一个个缩短字符串的长度，当缩短后的字符串尺寸小于textLabel的尺寸时即为满足
                while (range.length > 0) {
                    pageText = [_text substringWithRange:range];
                    
                    pageTextSize = [pageText boundingRectWithSize:CGSizeMake(_textLabel.frame.size.width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
                    
                    if (pageTextSize.height <= _textLabel.frame.size.height) {
                        range.length = [pageText length];
                        break;
                    }
                    else {
                        
                        range.length -= (((int)pageTextSize.height - (int)_textLabel.frame.size.height));
                    }
                }
                // 得到一个页面的显示范围
                if (page >= maxPages) {
                    maxPages += 10;
                    _rangeOfPages = ((NSRange *)realloc((_rangeOfPages), maxPages*sizeof(NSRange)));
                }
                _rangeOfPages[page++] = range;
                // 更新游标
                location += range.length;
            }
            // 获取最终页面数量
            _totalPages = page;
            
            // 更新UILabel内容
            self.textLabel.font = _preferredFont;
            _textLabel.text = [_text substringWithRange:_rangeOfPages[_currentPage]];
        }
    }
    // 显示当前页面进度信息，格式为："8/100"
    _pageInfoLabel.text = [NSString stringWithFormat:@"%d/%ld", _currentPage+1, (long)_totalPages];
}
- (IBAction)actionPrevious:(id)sender {
    if (_currentPage > 0) {
        _currentPage--;
        
        NSRange range = _rangeOfPages[_currentPage];
        NSString *pageText = [_text substringWithRange:range];
        
        _textLabel.text = pageText;
        
        //
        _pageInfoLabel.text = [NSString stringWithFormat:@"%ld/%d", _currentPage+1, _totalPages];
    }
}
- (IBAction)actionNext:(id)sender {
    if (_currentPage < _totalPages-1) {
        _currentPage++;
        
        NSRange range = _rangeOfPages[_currentPage];
        NSString *pageText = [_text substringWithRange:range];
        
        _textLabel.text = pageText;
        
        //
        _pageInfoLabel.text = [NSString stringWithFormat:@"%d/%ld", _currentPage+1, _totalPages];
    }
}


/*
 第二种
 
 */
/*
 -(void) gotoNextPage{
 
 if (_currentPage == _totalPages - 1) {
 return;
 }
 if (_currentPage == _totalPages - 2) {
 [_curPageView.textView.textStorage  setAttributedString:[[_textContent attributedSubstringFromRange:NSMakeRange((_currentPage + 1) * _charsPerPage, _charsOfLastPage)] mutableCopy]];
 _curPageView.textView.font = _preferredFont;
 _currentPage ++;
 [self.curPageView.pageNumber setText:[NSString stringWithFormat:@"%d/%d",_currentPage+1,_totalPages]];
 }
 else {
 [_curPageView.textView.textStorage  setAttributedString:[[_textContent attributedSubstringFromRange:NSMakeRange((_currentPage + 1) * _charsPerPage, _charsPerPage)] mutableCopy]];
 _curPageView.textView.font = _preferredFont;
 _currentPage ++;
 [self.curPageView.pageNumber setText:[NSString stringWithFormat:@"%d/%d",_currentPage+1,_totalPages]];
 }
 
 [self.curPageView labelChange];
 }
 
 -(void) gotoPrevPage{
 if (_currentPage == 0) {
 return;
 }
 else {
 [_curPageView.textView.textStorage  setAttributedString:[[_textContent attributedSubstringFromRange:NSMakeRange((_currentPage - 1) * _charsPerPage, _charsPerPage)] mutableCopy]];
 _curPageView.textView.font = _preferredFont;
 _currentPage --;
 [self.curPageView.pageNumber setText:[NSString stringWithFormat:@"%d/%d",_currentPage+1,_totalPages]];
 }
 [self.curPageView labelChange];
 }
 
 - (void)hiddenToolBar{
 //[self. setHidden:self.toolbar.isHidden? NO:YES];
 [self.navigationController.navigationBar setHidden:self.navigationController.navigationBar.isHidden ? NO :YES];
 //[self.pageSlider setHidden:self.pageSlider.isHidden ? NO: YES];
 //[self.currentPageLabel setHidden:self.currentPageLabel.isHidden ? NO: YES];
 }
 
 // 判断是否需要分页和进行分页
 -(BOOL)paging{
 NSString *text  = [NSString stringWithString:[_textContent string]];
 // 获取Settings中设定好的字体（主要是获取字体大小）
 //static const CGFloat textScaleFactor = 1.;                                     // 设置文字比例
 //    NSString *textStyle = [curPageView.textView textStyle];                    // 设置文字样式
 //    _preferredFont = [UIFont preferredFontForTextStyle:textStyle
 //                                                           ]; //设置prferredFont（包括样式和大小）
 _preferredFont = [UIFont systemFontOfSize:14];
 
 NSLog(@"paging: %@", _preferredFont.fontDescriptor.fontAttributes);            // 在控制台中输出字体的属性字典
 
 
 // 设定每页的页面尺寸
 NSUInteger width  = (int)self.view.frame.size.width  - 10.0;
 NSUInteger height = (int)self.view.frame.size.height - 120.0;
 
 
 //* 计算文本串的总大小尺寸 Deprecated in iOS 7.0
 NSDictionary *attribute = @{NSFontAttributeName: _preferredFont};
 CGSize totalTextSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
 NSLog(@"totalTextSize:w = %f,h = %f", totalTextSize.width, totalTextSize.height);
 
 if (totalTextSize.height < height) {
 _totalPages   = 1;
 _charsPerPage = [text length];
 _textLength   = [text length];
 return NO;
 }
 else {
 // 计算理想状态下的页面数量和每页所显示的字符数量，用来作为参考值用
 _textLength  = [text length];
 NSUInteger referTotalPages = (int)totalTextSize.height / (int)height + 1;
 NSUInteger referCharactersPerPage = _textLength / referTotalPages;
 
 //        NSLog(@"文本长度：textLength = %d", _textLength);
 //        NSLog(@"总页数：referTotalPages = %d", referTotalPages);
 //        NSLog(@"每页的字符数：referCharactersPerPage = %d", referCharactersPerPage);
 
 // 如果referCharactersPerPage过大，则直接调整至下限值，减少调整的时间
 if (referCharactersPerPage > 600) {
 referCharactersPerPage = 600;
 }
 
 // 获取理想状态下的每页文本的范围和pageText及其尺寸
 NSRange range       = NSMakeRange(referCharactersPerPage, referCharactersPerPage); // 一般第一页字符数较少，所以取第二页的文本范围作为调整的参考标准
 NSString *pageText  = [text substringWithRange:range];                             // 获取该范围内的文本
 CGSize pageTextSize = [pageText sizeWithFont:_preferredFont
 constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
 lineBreakMode:NSLineBreakByWordWrapping];           // 获取pageText的尺寸
 
 // 若pageText超出text view的显示范围，则调整referCharactersPerPage
 NSLog(@"height = %d", height);
 while (pageTextSize.height > height) {
 NSLog(@"pageTextSize.height = %f", pageTextSize.height);
 referCharactersPerPage -= 2;                                      // 每页字符数减2
 range     = NSMakeRange(0, referCharactersPerPage); // 重置每页字符的范围
 pageText   = [text substringWithRange:range];        // 重置pageText
 pageTextSize = [pageText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:  NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;// 获取pageText的尺寸
 }
 // 根据调整后的referCharactersPerPage设定好charsPerPage_
 _charsPerPage = referCharactersPerPage;
 NSLog(@"cpp: %d", _charsPerPage);
 
 // 计算totalPages_
 _totalPages = (int)text.length / _charsPerPage + 1;
 NSLog(@"ttp: %ld", (long)_totalPages);
 
 // 计算最后一页的字符数，防止范围溢出
 _charsOfLastPage = _textLength - (_totalPages - 1) * _charsPerPage;
 NSLog(@"colp: %d", _charsOfLastPage);
 
 // 分页完成
 return YES;
 }
 }
 */

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
