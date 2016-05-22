//
//  StoryPageViewController.h
//  AV Storybook
//
//  Created by Anton Moiseev on 2016-05-21.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

@import UIKit;
@import AVFoundation;
#import "Page.h"

@protocol StoryPageViewControllerDelegate <NSObject>

- (void)adjustPage:(Page *)page atIndex:(int)index;

@end

@interface StoryPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
@property (nonatomic) AVAudioPlayer *player;
@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) NSURL *soundFileURL;
@property (nonatomic) AVAudioSession *session;
@property (nonatomic) Page *ourPage;
@property (assign, nonatomic) int index;
@property (weak, nonatomic) id<StoryPageViewControllerDelegate> delegate;

@end
