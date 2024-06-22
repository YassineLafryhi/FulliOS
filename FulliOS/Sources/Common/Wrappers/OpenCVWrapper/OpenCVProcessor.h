//
//  OpenCVProcessor.h
//  FulliOS
//
//  Created by Yassine Lafryhi on 7/6/2024.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVProcessor : NSObject

+ (UIImage *)convertToGrayscale:(UIImage *)image;
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)applyGaussianBlur:(UIImage *)image;
+ (UIImage *)detectEdges:(UIImage *)image;
+ (UIImage *)applyThreshold:(UIImage *)image withValue:(double)value;
+ (UIImage *)convertColorSpace:(UIImage *)image;
+ (UIImage *)equalizeHistogram:(UIImage *)image;
+ (UIImage *)rotateImage:(UIImage *)image byAngle:(double)angle;
+ (UIImage *)flipImage:(UIImage *)image vertically:(BOOL)vertically;
+ (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect;
+ (UIImage *)dilateImage:(UIImage *)image;
+ (UIImage *)erodeImage:(UIImage *)image;
+ (UIImage *)applyAdaptiveThreshold:(UIImage *)image;
+ (NSArray *)findContoursInImage:(UIImage *)image;
+ (UIImage *)applySobelEdgeDetection:(UIImage *)image;
+ (UIImage *)applyLaplacianEdgeDetection:(UIImage *)image;
+ (UIImage *)applyBilateralFilter:(UIImage *)image;
+ (UIImage *)enhanceContrastUsingCLAHE:(UIImage *)image;
+ (NSArray *)detectCirclesInImage:(UIImage *)image;
+ (UIImage *)applyPerspectiveTransformation:(UIImage *)image withPoints:(NSArray<NSValue *> *)points;
+ (NSArray *)matchFeaturesBetweenImage:(UIImage *)image1 andImage:(UIImage *)image2;

@end
