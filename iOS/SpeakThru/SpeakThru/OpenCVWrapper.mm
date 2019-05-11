//
//  OpenCVWrapper.mm
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 10/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"

@interface OpenCVWrapper ()

@end

@implementation OpenCVWrapper

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s", CV_VERSION];
}

+ (NSArray< NSArray<NSNumber*>* > *)prepareForML:(UIImage *)image {
    cv::Mat srcMat = [OpenCVWrapper cvMatFromUIImage:image];
    
    int cols = 512;
    int rows = 64;
    
    cv::Mat resizedMat(rows, cols, srcMat.type());
    
    cv::resize(srcMat, resizedMat, resizedMat.size(), 0, 0, cv::INTER_LINEAR);
    
    cv::Mat grayMat(rows, cols, CV_8UC1);
    
    cv::cvtColor(resizedMat, grayMat, cv::COLOR_BGR2GRAY);
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:rows];
    
    for (int i = 0; i < rows; i++) {
        NSMutableArray* row = [NSMutableArray arrayWithCapacity:cols];
        for (int j = 0; j < cols; j++) {
            double val = grayMat.at<uchar>(i,j) / 255.;
            [row addObject:[NSNumber numberWithDouble:val]];
        }
        [result addObject:row];
    }
    
    return result;
}

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(
        rows,
        cols,
        CV_8UC4
    );
    
    CGContextRef contextRef = CGBitmapContextCreate(
        cvMat.data,
        cols,
        rows,
        8,
        cvMat.step[0],
        colorSpace,
        kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault
    );
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
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
