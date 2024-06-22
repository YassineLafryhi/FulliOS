//
//  OpenCVProcessor.mm
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

#import "OpenCVProcessor.h"

@implementation OpenCVProcessor : NSObject

+ (UIImage *)convertToGrayscale:(UIImage *)image {
    cv::Mat colorMat;
    UIImageToMat(image, colorMat);
    
    cv::Mat grayMat;
    cvtColor(colorMat, grayMat, cv::COLOR_BGR2GRAY);
    
    return MatToUIImage(grayMat);
}


+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    cv::Mat resizedImage;
    cv::resize(cvImage, resizedImage, cv::Size(size.width, size.height));
    
    return MatToUIImage(resizedImage);
}


+ (UIImage *)applyGaussianBlur:(UIImage *)image {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    cv::Mat blurredImage;
    cv::GaussianBlur(cvImage, blurredImage, cv::Size(5, 5), 0);
    
    return MatToUIImage(blurredImage);
}


+ (UIImage *)detectEdges:(UIImage *)image {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    cv::Mat edges;
    cv::Canny(cvImage, edges, 100, 200);
    
    return MatToUIImage(edges);
}


+ (UIImage *)applyThreshold:(UIImage *)image withValue:(double)value {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    cv::Mat thresholdedImage;
    cv::threshold(cvImage, thresholdedImage, value, 255, cv::THRESH_BINARY);
    
    return MatToUIImage(thresholdedImage);
}


+ (UIImage *)convertColorSpace:(UIImage *)image {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    cv::Mat convertedImage;
    cv::cvtColor(cvImage, convertedImage, cv::COLOR_BGR2RGB);
    
    return MatToUIImage(convertedImage);
}


+ (UIImage *)equalizeHistogram:(UIImage *)image {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    
    cv::Mat grayImage;
    cvtColor(cvImage, grayImage, cv::COLOR_BGR2GRAY);
    
    cv::Mat histEqualizedImage;
    cv::equalizeHist(grayImage, histEqualizedImage);
    
    return MatToUIImage(histEqualizedImage);
}

+ (UIImage *)rotateImage:(UIImage *)image byAngle:(double)angle {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Point2f center(src.cols / 2.0, src.rows / 2.0);
    cv::Mat rotationMatrix = cv::getRotationMatrix2D(center, angle, 1.0);
    
    cv::Mat dst;
    cv::warpAffine(src, dst, rotationMatrix, src.size());
    
    return MatToUIImage(dst);
}

+ (UIImage *)flipImage:(UIImage *)image vertically:(BOOL)vertically {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat dst;
    int flipCode = vertically ? 0 : 1;
    cv::flip(src, dst, flipCode);
    
    return MatToUIImage(dst);
}


+ (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Rect cvRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    cv::Mat dst = src(cvRect);
    
    return MatToUIImage(dst);
}


+ (UIImage *)dilateImage:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat dst;
    cv::dilate(src, dst, cv::Mat());
    
    return MatToUIImage(dst);
}


+ (UIImage *)erodeImage:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat dst;
    cv::erode(src, dst, cv::Mat());
    
    return MatToUIImage(dst);
}


+ (UIImage *)applyAdaptiveThreshold:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat gray, dst;
    cvtColor(src, gray, cv::COLOR_BGR2GRAY);
    cv::adaptiveThreshold(gray, dst, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 11, 2);
    
    return MatToUIImage(dst);
}


+ (NSArray *)findContoursInImage:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat gray;
    cvtColor(src, gray, cv::COLOR_BGR2GRAY);
    cv::threshold(gray, gray, 100, 255, cv::THRESH_BINARY);
    
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(gray, contours, cv::RETR_LIST, cv::CHAIN_APPROX_SIMPLE);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (const auto &contour : contours) {
        NSMutableArray *contourPoints = [NSMutableArray array];
        for (const auto &point : contour) {
            [contourPoints addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
        }
        [resultArray addObject:contourPoints];
    }
    
    return resultArray;
}


+ (UIImage *)applySobelEdgeDetection:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat gray, grad;
    cvtColor(src, gray, cv::COLOR_BGR2GRAY);
    cv::Sobel(gray, grad, CV_16S, 1, 1);
    cv::convertScaleAbs(grad, grad);
    
    return MatToUIImage(grad);
}

+ (UIImage *)applyLaplacianEdgeDetection:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat gray, dst;
    cvtColor(src, gray, cv::COLOR_BGR2GRAY);
    cv::Laplacian(gray, dst, CV_16S);
    cv::convertScaleAbs(dst, dst);
    
    return MatToUIImage(dst);
}


+ (UIImage *)applyBilateralFilter:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat dst;
    cv::bilateralFilter(src, dst, 9, 75, 75);
    
    return MatToUIImage(dst);
}


+ (UIImage *)enhanceContrastUsingCLAHE:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat gray, claheResult;
    cvtColor(src, gray, cv::COLOR_BGR2GRAY);
    cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE();
    clahe->setClipLimit(4);
    clahe->apply(gray, claheResult);
    
    return MatToUIImage(claheResult);
}

+ (NSArray *)detectCirclesInImage:(UIImage *)image {
    cv::Mat src;
    UIImageToMat(image, src);
    
    cv::Mat gray;
    cvtColor(src, gray, cv::COLOR_BGR2GRAY);
    cv::GaussianBlur(gray, gray, cv::Size(9, 9), 2, 2);
    
    std::vector<cv::Vec3f> circles;
    cv::HoughCircles(gray, circles, cv::HOUGH_GRADIENT, 1, gray.rows / 8, 200, 100, 0, 0);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (auto &circle : circles) {
        CGPoint center = CGPointMake(circle[0], circle[1]);
        CGFloat radius = circle[2];
        [resultArray addObject:@{@"center": [NSValue valueWithCGPoint:center], @"radius": @(radius)}];
    }
    
    return resultArray;
}

@end
