//
//  OpenCVWrapper.h
//  SpeakThru
//
//  Created by Дмитрий Ткаченко on 10/05/2019.
//  Copyright © 2019 klabertants. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : UIViewController

+ (NSString *)openCVVersionString;
+ (NSArray< NSArray<NSNumber*>* > *)prepareForML:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
