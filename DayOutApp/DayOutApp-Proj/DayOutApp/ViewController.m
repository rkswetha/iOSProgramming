//
//  ViewController.m
//  DayOutApp
//
//  Created by Swetha RK on 11/4/14.
//  Copyright (c) 2014 Swetha RK. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView = mImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSAssert(self.imageView, @"self.imageView is nil. Check your IBOutlet connections");
    UIImage* image = [UIImage imageNamed:@"daytrip.jpg"];
    NSAssert(image, @"image is nil. Check that you added the image to your bundle and that the filename above matches the name of you image.");
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.clipsToBounds = YES;
    self.imageView.image = image;
    
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y,
                                 image.size.width, image.size.height);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
