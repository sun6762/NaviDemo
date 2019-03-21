//
//  SSImageView.m
//  SunnyCalendar
//
//  Created by sun on 2019/3/19.
//  Copyright © 2019年 sunny. All rights reserved.
//

#import "SSImageView.h"
#import <Accelerate/Accelerate.h>

@interface SSImageView ()

// 毛玻璃层
@property (nonatomic, strong)UIImageView *blurImageView;

@end

@implementation SSImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.initalBlurLevel = 0.8;
        self.blurImageView = [UIImageView new];
        [self addSubview:_blurImageView];
        _blurImageView.alpha = 0;
        _blurImageView.backgroundColor = [UIColor clearColor];
        _blurImageView.frame = self.bounds;
        _blurImageView.contentMode = UIViewContentModeScaleToFill;
        _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    CGFloat blur = -self.scrollView.contentOffset.y/self.bounds.size.height;
//    NSLog(@"blur ==== %.2f",blur);
    self.blurImageView.alpha = blur*4;
}

# pragma
# pragma mark - SET -
- (void)setScrollView:(UIScrollView *)scrollView{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
    // KVO
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)setInitalBlurLevel:(CGFloat)initalBlurLevel{
    _initalBlurLevel = initalBlurLevel;
}

- (void)setOriginalImg:(UIImage *)originalImg{
    _originalImg = originalImg;
    
    self.image = originalImg;
    dispatch_queue_t queue = dispatch_queue_create("queue_blur", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        UIImage *blurImage;
        if (originalImg) {
           blurImage = [self createBlurImageWithOriginalImage:originalImg withLevel:0.8];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blurImageView.image = blurImage; 
            self.blurImageView.alpha = 0;
        });
    });
}

// 使用vImage API进行模糊
- (UIImage *)createBlurImageWithOriginalImage:(UIImage *)originalImage withLevel:(CGFloat)level {
    if (level >1.0f || level < 0.0f) {
        level = 0.5;
    }
    
    int boxSize = (int)(level * 100);
    boxSize -= (boxSize % 2) + 1;
    CGImageRef rawImage = originalImage.CGImage;
    //
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
    CFDataRef inBitMapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(rawImage);
    inBuffer.height = CGImageGetHeight(rawImage);
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitMapData);
    
    pixelBuffer =  malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(rawImage);
    outBuffer.height = CGImageGetHeight(rawImage);
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error:%ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(rawImage));
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    // clean
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitMapData);
    CGImageRelease(imageRef);
    return returnImage;
}

-(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if (blur <0.f || blur > 1.f)
    {
        blur = 0.5f;
    }
    //判断曝光度
    int boxSize = (int)(blur * 100);//放大100 小数点后面2位有效
    boxSize = boxSize - (boxSize % 2) + 1;//如果是偶数 变奇数
    CGImageRef img = image.CGImage;//获取图片指针
    vImage_Buffer inBuffer,outBuffer;//获取缓冲区
    vImage_Error error;//一个错误类，调用画图函数的时候调用
    void *pixelBuffer;
    CGDataProviderRef inprovider = CGImageGetDataProvider(img);//放回一个数组图片
    CFDataRef inbitmapData = CGDataProviderCopyData(inprovider);//拷贝数据
    inBuffer.width = CGImageGetWidth(img);//放回位图的宽度
    inBuffer.height = CGImageGetHeight(img);//放回位图的高度
    
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);//算出位图的字节
    
    inBuffer.data = (void*)CFDataGetBytePtr(inbitmapData);//填写图片信息
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));//创建一个空间
    
    if (pixelBuffer == NULL)
    {
        NSLog(@"NO Pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error)
    {
        NSLog(@"%zd",error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inbitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


// 使用Core Image进行模糊
- (UIImage *)createBlurryImageWithImage:(UIImage *)originalImage BlurryLevel:(CGFloat)level{
    
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @(level), nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext context];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}
@end
