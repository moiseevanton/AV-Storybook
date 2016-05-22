//
//  Page.m
//  AV Storybook
//
//  Created by Anton Moiseev on 2016-05-21.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

#import "Page.h"

@implementation Page

- (instancetype)init {
    return [self initWithImage:nil audioURL:nil];
}

- (instancetype) initWithImage:(UIImage *)image audioURL:(NSURL *)audioURL {
    self = [super init];
    if (self) {
        _image = image;
        _audioURL = audioURL;
    }
    return self;
}

@end
