//
//  PLEpisodeDetailViewController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/11/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import "PLEpisodeDetailViewController.h"

@interface PLEpisodeDetailViewController ()

@end

@implementation PLEpisodeDetailViewController
@synthesize images;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    PLEpisodeContentViewController *startingViewController = [self viewControllerAtIndex:0];
     NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height - 40);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PLEpisodeContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PLEpisodeContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == images.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.images.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 1;
}

#pragma mark - Page view controller delegate

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
}

#pragma mark - Get content for episode
- (PLEpisodeContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((images.count == 0) || (index >= images.count)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PLEpisodeContentViewController *contentController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
    
    EpisodeImages *episodeImage = [images objectAtIndex:index];
    contentController.episodeImage = episodeImage.image;
    contentController.pageIndex = index;
    return contentController;
}

@end
