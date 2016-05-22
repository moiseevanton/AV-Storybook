//
//  Page.h
//  AV Storybook
//
//  Created by Anton Moiseev on 2016-05-21.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

@import UIKit;

@interface Page : NSObject

@property (nonatomic) UIImage *image;

@property (strong, nonatomic) NSURL *audioURL;

- (instancetype)initWithImage:(UIImage *)image audioURL:(NSURL *)audioURL;

@end
