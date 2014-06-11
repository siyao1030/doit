//
//  APPChildViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPChildViewController.h"

@interface APPChildViewController ()

@end

@implementation APPChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        
    }
    
    return self;
    
}


- (void)skip {
    [self.target performSelector:self.action];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIImage * image;
    self.skipButton = [UIButton buttonWithType:UIButtonTypeSystem];

    if ([UIScreen mainScreen].bounds.size.height < 568)
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"intro%dsmall",self.index]];
        [self.skipButton setFrame:CGRectMake((320-80)/2, (self.view.frame.size.height-80), 80, 40)];
    }
    else
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"intro%d",self.index]];
        [self.skipButton setFrame:CGRectMake((320-80)/2, (self.view.frame.size.height-100), 80, 40)];
    }
    

    [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue"  size: 20]];
    [self.skipButton setTintColor:bgColor];
    [self.skipButton addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [imageView setImage:image];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    [self.view addSubview:imageView];
    [self.view addSubview:self.skipButton];
    // Do any additional setup after loading the view from its nib.
    
    //self.screenNumber.text = [NSString stringWithFormat:@"Screen #%d", self.index];
    

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
