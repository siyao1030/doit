//
//  ComparisonViewController.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/24/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"
#import "Comparison.h"
#import "ComparisonMaker.h"
#import "ResultViewController.h"
#import "BubbleView.h"
#import "Database.h"
#import "ProgressView.h"


@interface ComparisonViewController : UIViewController

@property BubbleView * bubbles;
@property UILabel * choiceALabel;
@property UILabel * choiceBLabel;
@property UILabel * instructionlabel;

@property ProgressView * progressView;

@property int factorAWeight;
@property int factorBWeight;

@property UIButton * prevButton;
@property UIButton * nextButton;

@property UIAlertView * alertView;

@property Decision * decision;
@property Choice * choiceA;
@property Choice * choiceB;


@property int numOfCompPerRound;

@property Comparison *currentComparison;
@property ComparisonMaker * comparisonMaker;

-(void)reload;

-(id)initWithDecision:(Decision *)decision;

@end
