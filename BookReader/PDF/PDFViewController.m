//
//  PDFViewController.m
//  Reader
//
//  Created by 周德艺 on 15/2/4.
//  Copyright (c) 2015年 周德艺. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()

@end

@implementation PDFViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    CFURLRef pdfURL = CFBundleCopyResourceURL(
                                              CFBundleGetMainBundle(),
                                              CFSTR("iosUI"),
                                              CFSTR("pdf"), NULL);
    self.pdf = CGPDFDocumentCreateWithURL(pdfURL);
    self.totalPages = CGPDFDocumentGetNumberOfPages(self.pdf);
    self.currentPage = 1;
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage:)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lastPage:)];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenToolBar)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    [self.view  addGestureRecognizer:rightSwipeRecognizer];
    [self.view  addGestureRecognizer:leftSwipeRecognizer];
    [self.view  addGestureRecognizer:singleTap];
    
    [self viewReload];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)viewReload{
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.myPageRef = CGPDFDocumentGetPage(self.pdf, self.currentPage);
    
    CGRect viewFrame = self.view.frame;
    self.tiledLayer = [CATiledLayer layer];
    self.tiledLayer.delegate = self;
    self.tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
    self.tiledLayer.levelsOfDetail = 1000;
    self.tiledLayer.levelsOfDetailBias = 1000;
    self.tiledLayer.frame = viewFrame;
    self.myContentView = [[UIView alloc] initWithFrame:viewFrame];
    [self.myContentView.layer addSublayer:self.tiledLayer];
    
    viewFrame.origin = CGPointZero;
    self.scrollView = [[UIScrollView alloc] initWithFrame:viewFrame];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = viewFrame.size;
    self.scrollView.maximumZoomScale = 100;
    [self.scrollView addSubview:self.myContentView];
    [self.view addSubview:self.scrollView];
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.myContentView;
}
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx));
    CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(self.myPageRef, kCGPDFCropBox, layer.bounds, 0, true));
    CGContextDrawPDFPage(ctx, self.myPageRef);
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    if( (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
//       (interfaceOrientation == UIInterfaceOrientationLandscapeRight)){
//        //SOMETHING TO DO FOR LANDSCAPE MODE
//    }
//    else if((interfaceOrientation == UIInterfaceOrientationPortrait)){
//        //SOMETHING TO DO TO RESTORE TO PORTRAIT
//    }
//    // Return YES for supported orientations
//    return ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
//            (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
//            (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
//}

- (void)hiddenToolBar{
    [self.navigationController.navigationBar setHidden:self.navigationController.navigationBar.isHidden ? NO :YES];
}

- (IBAction)lastPage:(id)sender {
    if(self.currentPage < 2)
        return;
    --self.currentPage;
    [self viewReload];
}

- (IBAction)nextPage:(id)sender {
    if(self.currentPage >=self.totalPages)
        return;
    ++self.currentPage;
    [self viewReload];
}

@end
