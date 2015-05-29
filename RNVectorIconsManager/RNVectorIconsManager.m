//
//  RNVectorIconsManager.m
//  RNVectorIconsManager
//
//  Created by Joel Arvidsson on 2015-05-29.
//  Copyright (c) 2015 Joel Arvidsson. All rights reserved.
//

#import "RNVectorIconsManager.h"
#import "RCTConvert.h"
#import "RCTBridge.h"
#import "RCTUtils.h"

@implementation RNVectorIconsManager

@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getImageForFont:(NSString*)fontName withGlyph:(NSString*)glyph withFontSize:(CGFloat)fontSize callback:(RCTResponseSenderBlock)callback){
  CGFloat screenScale = RCTScreenScale();
  NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/RNVectorIcons_%@_%@_%.f@%.fx.png", fontName, glyph, fontSize, screenScale];

  if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    // No cached icon exists, we need to create it and persist to disk

    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:glyph attributes:@{NSFontAttributeName: font}];

    CGSize iconSize = [attributedString size];

    CGSize imageSize = CGSizeMake(fontSize, fontSize);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
  
    //Center in case height doesn't equal fontSize
    CGRect centeredRect = CGRectMake((imageSize.width - iconSize.width) / 2.0, (imageSize.height - iconSize.height) / 2.0, iconSize.width, iconSize.height);
    [attributedString drawInRect:centeredRect];
  
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    NSData *imageData = UIImagePNGRepresentation(iconImage);
    [imageData writeToFile:filePath atomically:YES];
  }
  callback(@[[NSNull null], filePath]);

}
@end