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
    
    
   
    
    self.bubbles = [[BubbleView alloc]initWithFrame:CGRectMake(0, 50, 320, 400)];

    Choice * a = self.decision.choices[0];
    Choice * b = self.decision.choices[1];
    
    
    //////tantative!! delete after testing
    if (self.decision.numOfCompsDone == 0)
    {
        NSLog(@"manually setting numOfCompsDone-->Not good");
        self.decision.numOfCompsDone = MIN(3*MAX(a.factors.count, b.factors.count),a.factors.count*b.factors.count);
    }
    //////tantative!! delete after testing
    
    
    [self.decision convergeNetworkScore];
    
    [self.bubbles setUpWithItemALabel:a.title andASize:self.decision.Arate andItemBLabel:b.title andBSize:self.decision.Brate andShouldDisplaySize:YES];
    [self.bubbles setBackgroundColor:bgColor];

    [self.view addSubview:self.bubbles];
    
    
    self.resultLabel = [[UILabel alloc]initWithFrame:CGRectMake((320-250)/2, 30, 250, 30)];
    [self.resultLabel setText:@"Your Heart Belongs to"];
    [self.resultLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light"  size: 22]];
    [self.resultLabel setTextColor:redOpaque];
    [self.resultLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:self.resultLabel];
    
    
    self.analysisButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.analysisButton setFrame:CGRectMake((self.view.frame.size.width-88)/2, self.view.frame.size.height-88-40, 88, 40)];
    [self.analysisButton setTitle:@"See Why" forState:UIControlStateNormal];
    [self.analysisButton.titleLabel setFont:[UIFont fontWithName: @"HelveticaNeue"  size: 20]];
    [self.analysisButton setTintColor:redOpaque];
    //[self.analysisButton setBackgroundImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [self.analysisButton addTarget:self action:@selector(seeAnalysis) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.analysisButton];
    
    
    
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

-(void)seeAnalysis
{
    //ResultAnalysisViewController * analysisView = [[ResultAnalysisViewController alloc]initWithDecision:self.decision];
    //FactorRankingViewController * analysisView = [[FactorRankingViewController alloc]initWithDecision:self.decision];
    
    //create the first view controller
    self.factorRankingView = [[FactorRankingViewController alloc] initWithDecision:self.decision];
    //[self.factorRankingView.view setFrame:[[UIScreen mainScreen] bounds]];
    self.factorRankingView.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"ranking.png"] tag:1];
    /*[self.factorRankingView.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               pinkOpaque, NSForegroundColorAttributeName,
                                                               [UIFont fontWithName:@"HelveticaNeue-Bold"   size:18.0], NSFontAttributeName, nil]
                                                     forState:UIControlStateNormal];*/
    [self.factorRankingView.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 20)];
    
    //create the second view controller
    self.compResultView = [[CompResultViewController alloc] initWithDecision:self.decision];
    self.compResultView.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"comps.png"] tag:2];
    
    
    /*[self.compResultView.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
     
                                            pinkOpaque, NSForegroundColorAttributeName,
                                            [UIFont fontWithName:@"HelveticaNeue-Bold"  size:15.0], NSFontAttributeName, nil]
                                  forState:UIControlStateNormal];*/
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
        /*
        [self.bubbles setUpWithItemALabel:[self.decision.choices[0] title]
                                 andASize:self.decision.Arate
                            andItemBLabel:[self.decision.choices[1] title]
                                 andBSize:self.decision.Brate
                     andShouldDisplaySize:YES];
         */
        NSLog(@"network: %f : %f", self.decision.Arate, self.decision.Brate);
        //[self.resetButton removeFromSuperview];
        //[self.recurseButton removeFromSuperview];
        
        
        [self.bubbles setNeedsDisplay];
    }
    
    
}

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
-(void)didPressDone
{
    
    [Database replaceItemWithData:self.decision atRow:self.decision.rowid];
    
    // Decision table view reload
    [[self.navigationController.viewControllers objectAtIndex:0] reload];

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)decideAgain
{
    NSLog(@"decide again %d", self.decision.comparisons.count);
    
    [self.decision resetStats];
    NSLog(@"after resetStats %d", self.decision.comparisons.count);
    
    [[self.navigationController.viewControllers objectAtIndex:3] reload];
     NSLog(@"after reload %d", self.decision.comparisons.count);
    [self.navigationController popViewControllerAnimated:YES];
     NSLog(@"after pop view %d", self.decision.comparisons.count);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
