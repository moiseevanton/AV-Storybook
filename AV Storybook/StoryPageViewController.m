//
//  StoryPageViewController.m
//  AV Storybook
//
//  Created by Anton Moiseev on 2016-05-21.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

#import "StoryPageViewController.h"

@interface StoryPageViewController () <AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation StoryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.ourPage) {
      self.ourPage = [Page new];
    }
    
    self.session = [AVAudioSession sharedInstance];
    [self setUpButtons];
    [self setUpImageView];
    [self setupSoundFileURL];
    [self setupRecorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpButtons {
    [self.cameraButton addTarget:self action:@selector(cameraButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.audioButton addTarget:self action:@selector(audioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpImageView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
    [self.pageImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.pageImageView.image = self.ourPage.image;
    [self.pageImageView setUserInteractionEnabled:YES];
    [self.pageImageView addGestureRecognizer:tap];
    
}

- (void)cameraButtonTapped:(UIBarButtonItem *)sender {
    
    [self alertUserWithMessage:@"Take a photo or pick one from the camera roll."];
    
}

- (void)audioButtonTapped:(UIBarButtonItem *)sender {
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    } else {
        NSError *error = nil;
        [self.session setActive:YES error:&error];
        [self.session setCategory:AVAudioSessionCategoryRecord error:nil];
        NSAssert(error == nil, @"%@", error.localizedDescription);
        [self.recorder record];
    }
    [self.delegate adjustPage:self.ourPage atIndex:self.index];
}

- (void)playAudio {
    if (self.recorder.isRecording) {
        return;
    }
    if (self.player.isPlaying) {
        [self.player stop];
        return;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundFileURL error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.player.delegate = self;
    [self.player play];
}

- (void)setupSoundFileURL {
    if (!self.ourPage.audioURL) {
        NSArray *pathComponents = @[ [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString stringWithFormat:@"sound%d.m4a", self.index]];
        self.soundFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        self.ourPage.audioURL = self.soundFileURL;
    } else {
        self.soundFileURL = self.ourPage.audioURL;
    }
}
- (void)setupRecorder {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    settings[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    settings[AVSampleRateKey] = @(44100.0);
    settings[AVNumberOfChannelsKey] = @(2);
    // prepare for recording
    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.soundFileURL settings:settings error:&error];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    if (!self.ourPage.audioURL) {
    [self.recorder prepareToRecord];
    }
}

- (void)alertUserWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"What do you want to do?" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        [[UIApplication sharedApplication] openURL:url];
        NSLog(@"Camera tapped");
        [self cameraTapped];
    }];
    UIAlertAction *cameraRollAction = [UIAlertAction actionWithTitle:@"Camera roll" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Camera roll Tapped");
        [self cameraRollTapped];
    }];
    [alertController addAction:cameraRollAction];
    [alertController addAction:cameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)cameraTapped {
    UIImagePickerControllerSourceType cameraSourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = cameraSourceType;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                        cameraSourceType];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)cameraRollTapped {
    UIImagePickerControllerSourceType photoLibSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = photoLibSourceType;
    imagePickerController.delegate = self;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                        photoLibSourceType];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:^ {
        // handle image
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.ourPage.image = image;
        [self.delegate adjustPage:self.ourPage atIndex:self.index];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
        if ([info[UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
            self.pageImageView.image = image;
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"Error!");
    } else {
        NSLog(@"Success!");
    }
}
@end
