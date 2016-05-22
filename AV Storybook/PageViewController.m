//
//  PageViewController.m
//  AV Storybook
//
//  Created by Anton Moiseev on 2016-05-21.
//  Copyright © 2016 Anton Moiseev. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@property (nonatomic) NSArray<Page*>*data;
- (StoryPageViewController *)createViewControllerAtIndex:(int)index;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    [self setUpData];
    [self createInitialViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpData {
    NSMutableArray *result = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        
        [result addObject:[Page new]];
        
    }
    NSLog(@"%lu", (unsigned long)result.count);
    self.data = result;
}

- (void)createInitialViewController {
    StoryPageViewController *spvc = [self createViewControllerAtIndex:0];
    [self setViewControllers:@[spvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}

- (StoryPageViewController *)createViewControllerAtIndex:(int)index {
    
    StoryPageViewController *spvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPageViewController"];
    spvc.delegate = self;
    spvc.ourPage = self.data[index];
    spvc.index = index;
    return spvc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    StoryPageViewController *vc = (StoryPageViewController *)viewController;
    int index = vc.index;
    NSLog(@"%d", index);
    if (index >= self.data.count -1) {
        return nil;
    }
    index += 1;
    StoryPageViewController *spvc = [self createViewControllerAtIndex:index];
    return spvc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    StoryPageViewController *vc = (StoryPageViewController *)viewController;
    int index = vc.index;
    NSLog(@"%d", index);
    if (index <= 0) {
        return nil;
    }
    index -= 1;
    StoryPageViewController *spvc = [self createViewControllerAtIndex:index];
    return spvc;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.data.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return ((StoryPageViewController *)pageViewController.viewControllers[0]).index;
}

- (void)adjustPage:(Page *)page atIndex:(int)index {
    
    Page *thePage = self.data[index];
    thePage.image = page.image;
    thePage.audioURL = page.audioURL;
    
}

@end
