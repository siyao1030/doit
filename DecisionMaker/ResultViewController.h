//
//  ResultViewController.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 12/3/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"
#import "BubbleView.h"
#import "Database.h"
#import "CompResultViewController.h"
#import "FactorRankingViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ResultViewController : UIViewController

@property Decision * decision;

@property BubbleView * bubbles;

@property BubbleView * choiceABubble;
@property BubbleView * choiceBBubble;

@property UIBarButtonItem * endButton;
@property UILabel * resultLabel;
@property UILabel * winner;

@property UIButton * analysisButton;

@property CompResultViewController * compResultView;
@property FactorRankingViewController * factorRankingView;
@property UITabBarController * tabBarView;

//AB TESTING
@property int mode;
@property UIButton * switchScoringButton;
@property UIButton * recurseButton;
@property UIButton * resetButton;
@property UIButton * convergeButton;
@property UIButton * shareButton;

@property UIImage * screenshot;

-(id)initWithDecision:(Decision *)decision;

@end
