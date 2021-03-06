//
//  ResultViewController.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 12/3/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(id)initWithDecision:(Decision *)decision
{
    self.decision = decision;
    self.mode = NetworkScoreMode;
    self.view.backgroundColor = bgColor;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = titleColor; // change this color
    self.navigationItem.titleView = label;
    
    [label setText: @"Result"];
    [label sizeToFit];
    
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight < 568)
    {
        self.bubbles = [[BubbleView alloc]initWithFrame:CGRectMake(0, 60, 320, 400*0.8) andSizeFactor:0.7];
        self.resultLabel = [[UILabel alloc]initWithFrame:CGRectMake((320-250)/2, 25, 250, 30)];
    }
    else
    {
        self.bubbles = [[BubbleView alloc]initWithFrame:CGRectMake(0, 50, 320, 400) andSizeFactor:1];
        self.resultLabel = [[UILabel alloc]initWithFrame:CGRectMake((320-250)/2, 30, 250, 30)];
    }

    Choice * a = self.decision.choices[0];
    Choice * b = self.decision.choices[1];
    
    /*
    //////tantative!! delete after testing
    if (self.decision.numOfCompsDone == 0)
    {
        NSLog(@"manually setting numOfCompsDone-->Not good");
        self.decision.numOfCompsDone = MIN(3*MAX(a.factors.count, b.factors.count),a.factors.count*b.factors.count);
    }
    //////tantative!! delete after testing
    */
    
    [self.decision convergeNetworkScore];
    
    [self.bubbles setUpWithItemALabel:a.title andASize:self.decision.Arate andItemBLabel:b.title andBSize:self.decision.Brate andShouldDisplaySize:YES];
    [self.bubbles setBackgroundColor:bgColor];

    [self.view addSubview:self.bubbles];
    
    
    
    [self.resultLabel setText:@"Your Heart Belongs to"];
    [self.resultLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light"  size: 22]];
    [self.resultLabel setTextColor:redOpaque];
    [self.resultLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:self.resultLabel];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.shareButton setFrame:CGRectMake(50, self.view.frame.size.height-88-40, 88, 40)];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue"  size: 20]];
    [self.shareButton setTintColor:redOpaque];
    [self.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareButton];
    
    self.analysisButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.analysisButton setFrame:CGRectMake(self.view.frame.size.width-88-50, self.view.frame.size.height-88-40, 88, 40)];
    [self.analysisButton setTitle:@"See Why" forState:UIControlStateNormal];
    [self.analysisButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue"  size: 20]];
    [self.analysisButton setTintColor:redOpaque];
    //[self.analysisButton setBackgroundImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [self.analysisButton addTarget:self action:@selector(seeAnalysis) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.analysisButton];
    
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share to:"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"Facebook", @"Wechat", nil];
    
    [self.actionSheet setTag:0];
    /*
    self.switchScoringButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.switchScoringButton setFrame:CGRectMake((320-88)/2, self.view.frame.size.height-100, 88, 20)];
    [self.switchScoringButton setTitle:@"Switch" forState:UIControlStateNormal];
    [self.switchScoringButton addTarget:self action:@selector(switchScoring) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchScoringButton];
    
    
    self.recurseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.recurseButton setFrame:CGRectMake(20, self.view.frame.size.height-100, 88, 20)];
    [self.recurseButton setTitle:@"Recurse" forState:UIControlStateNormal];
    [self.recurseButton addTarget:self action:@selector(recurseContribution) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recurseButton];
    
    self.resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.resetButton setFrame:CGRectMake(320-88-20, self.view.frame.size.height-100, 88, 20)];
    [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetContribution) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resetButton];
    
    self.convergeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.convergeButton setFrame:CGRectMake(320-88-40, self.view.frame.size.height-150, 88, 20)];
    [self.convergeButton setTitle:@"Converge" forState:UIControlStateNormal];
    [self.convergeButton addTarget:self action:@selector(converge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.convergeButton];
    */
    
    self.endButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didPressDone)];
    
    
    UIBarButtonItem * decideAgainButton = [[UIBarButtonItem alloc]initWithTitle:@"Redecide" style:UIBarButtonItemStylePlain target:self action:@selector(decideAgain)];
    
    [self.navigationItem setRightBarButtonItem:self.endButton animated:YES];
    [self.navigationItem setLeftBarButtonItem:decideAgainButton animated:YES];
    
    
    return self;
}

- (UIImage*)captureView
{
    
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    size.width *= [layer contentsScale];
    size.height *= [layer contentsScale];
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    // Retrieve the screenshot image
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}


-(void)share
{
    /*
    //activity view
    NSString *text = @"How to add Facebook and Twitter sharing to an iOS app";
    NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
    UIImage *image = self.screenshot;
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, url, image]
     applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypeAirDrop];
    
    
    [self presentViewController:controller animated:YES completion:nil];
     */
    
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 0:
        {
            switch (buttonIndex) {
                case 0:
                {
                    [self shareToFB];
                    
                    break;
                }
                case 1:
                {
                    
                    UIActionSheet * wechatSheet = [[UIActionSheet alloc] initWithTitle:@"Share to:"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"Moments", @"Chat", nil];
                    [wechatSheet setTag:1];
                    [wechatSheet showInView:self.view];
                    
                    break;
                }
            }
            break;

        }
        case 1:
        {
            [self shareToWechatWithOption:buttonIndex];
            
        }
            
    }
    
}

//------------------Sharing a photo using the Share Dialog ------------------


-(void)shareToFB
{
    //UIImageWriteToSavedPhotosAlbum(self.screenshot, nil, nil, nil);
    
    // If the Facebook app is installed and we can present the share dialog
    if([FBDialogs canPresentShareDialogWithPhotos]) {
        // Retrieve a picture from the device's photo library
        /*
         NOTE: SDK Image size limits are 480x480px minimum resolution to 12MB maximum file size.
         In this app we're not making sure that our image is within those limits but you should.
         Error code for images that go below or above the size limits is 102.
         */
        
        
        FBPhotoParams *params = [[FBPhotoParams alloc] init];
        
        params.photos = @[self.screenshot];
        
        [FBDialogs presentShareDialogWithPhotoParams:params
                                         clientState:nil
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"Error: %@", error.description);
                                                 } else {
                                                     NSLog(@"Success!");
                                                 }
                                             }];
        
        
        
        
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Opps!" message:@"You currently don't have Facebook installed." delegate:self cancelButtonTitle:@"Got it." otherButtonTitles:nil];
        [alert show];
        //The user doesn't have the Facebook for iOS app installed, so we can't present the Share Dialog
        /*Fallback: You have two options
         1. Share the photo as a Custom Story using a "share a photo" Open Graph action, and publish it using API calls.
         See our Custom Stories tutorial: https://developers.facebook.com/docs/ios/open-graph
         2. Upload the photo making a requestForUploadPhoto
         See the reference: https://developers.facebook.com/docs/reference/ios/current/class/FBRequest/#requestForUploadPhoto:
         */
    }
}


-(void)shareToWechatWithOption:(int)option
{
    
    Choice * a = self.decision.choices[0];
    Choice * b = self.decision.choices[1];

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.decision.title;
    if (self.decision.Arate > self.decision.Brate)
        message.description = [NSString stringWithFormat:@"My heart belongs to %@", a.title];
    if (self.decision.Arate < self.decision.Brate)
        message.description = [NSString stringWithFormat:@"My heart belongs to %@", b.title];
    else
        message.description = @"I can't decide!";
    [message setThumbImage:[UIImage imageNamed:@"Icon-Small.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(self.screenshot, 0.0);
    
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    BOOL error = YES;
    if (option == 0)
    {
        //share to moments
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        error = [WXApi sendReq:req];
    }
    else if (option == 1)
    {
        //share with contact
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        error = [WXApi sendReq:req];
    }
    if (error == NO)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Opps!" message:@"You currently don't have Wechat installed." delegate:self cancelButtonTitle:@"Got it." otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)seeAnalysis
{

    //create the first view controller
    self.factorRankingView = [[FactorRankingViewController alloc] initWithDecision:self.decision];
    self.factorRankingView.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"ranking.png"] tag:1];
    [self.factorRankingView.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 20)];
    
    //create the second view controller
    self.compResultView = [[CompResultViewController alloc] initWithDecision:self.decision];
    self.compResultView.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"comps.png"] tag:2];
    [self.compResultView.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 20)];


    self.tabBarView = [[UITabBarController alloc]init];
    
    //add the viewcontrollers to the tab bar
    [self.tabBarView setViewControllers:[NSArray arrayWithObjects:self.factorRankingView, self.compResultView, nil] animated:YES];
    [self.tabBarView.tabBar setOpaque:NO];
    [self.tabBarView.tabBar setBarTintColor:bgColor];
    [self.tabBarView.tabBar setTintColor:pinkOpaque];

    
    [self.navigationController pushViewController:self.tabBarView animated:YES];
    
}

-(void)converge
{
    if (self.mode == NetworkScoreMode)
    {
        [self.decision convergeNetworkScore];
        
    }

    
    [self.bubbles setUpWithItemALabel:[self.decision.choices[0] title]
                             andASize:self.decision.Arate
                        andItemBLabel:[self.decision.choices[1] title]
                             andBSize:self.decision.Brate
                 andShouldDisplaySize:YES];
    
    [self.bubbles setNeedsDisplay];
}

/*
-(void)switchScoring
{
    if (self.mode == NetworkScoreMode)
    {
        self.mode = ContributionScoreMode;
        [self resetContribution];
        [self.convergeButton removeFromSuperview];
        //[self.bubbles setNeedsDisplay];
        //[self.view addSubview:self.recurseButton];
        //[self.view addSubview:self.resetButton];
        NSLog(@"contribution: %f : %f", self.decision.Arate, self.decision.Brate);

        
        
    }
    else if (self.mode == ContributionScoreMode)
    {
        self.mode = NetworkScoreMode;
        [self resetContribution];
        [self.view addSubview:self.convergeButton];

        NSLog(@"network: %f : %f", self.decision.Arate, self.decision.Brate);
        //[self.resetButton removeFromSuperview];
        //[self.recurseButton removeFromSuperview];
        
        
        [self.bubbles setNeedsDisplay];
    }
    
    
}
*/
/*
-(void)resetContribution
{

    for (Factor * factor in [[self.decision.choices objectAtIndex:0] factors])
    {
        factor.score = 10.0;
    }
    for (Factor * factor in [[self.decision.choices objectAtIndex:1] factors])
    {
        factor.score = 10.0;
    }
    
    if (self.mode == ContributionScoreMode)
    {
        
        [self.decision updateContributionScore];
    }
    else if (self.mode == NetworkScoreMode)
    {
        [self.decision updateNetworkScore];
    }

    [self.bubbles setUpWithItemALabel:[self.decision.choices[0] title]
                             andASize:self.decision.Arate
                        andItemBLabel:[self.decision.choices[1] title]
                             andBSize:self.decision.Brate
                 andShouldDisplaySize:YES];
    
    [self.bubbles setNeedsDisplay];
    //NSLog(@"after reset: %f : %f", self.decision.Arate, self.decision.Brate);
    
}

-(void)recurseContribution
{
    if (self.mode == ContributionScoreMode)
    {
        
        [self.decision updateContributionScore];
    }
    else if (self.mode == NetworkScoreMode)
    {
        [self.decision updateNetworkScore];
    }
    [self.bubbles setUpWithItemALabel:[self.decision.choices[0] title]
                             andASize:self.decision.Arate
                        andItemBLabel:[self.decision.choices[1] title]
                             andBSize:self.decision.Brate
                 andShouldDisplaySize:YES];
    
    [self.bubbles setNeedsDisplay];

}
 
 */
-(void)didPressDone
{
    
    [Database replaceItemWithData:self.decision atRow:self.decision.rowid];
    
    // Decision table view reload
    [[self.navigationController.viewControllers objectAtIndex:0] reload];

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)decideAgain
{
    
    
    //[self.decision resetStats];
    //comparison view reload - replace decision with tempdecision
    //[[self.navigationController.viewControllers objectAtIndex:3] reload];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    //[self.navigationController popViewControllerAnimated:NO];

    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.screenshot = [self captureView];
    self.decision.stage = ResultStage;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
