//
//  EnterProsConsViewController.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/23/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"
#import "Choice.h"
#import "ComparisonViewController.h"
#import "UIResponder+FirstResponder.h"

@interface EnterProsConsViewController : UIViewController

@property UITableView *choiceATableView;
@property UITableView *choiceBTableView;

@property ComparisonViewController *compareView;

@property UIButton *choiceAButton;
@property UIButton *choiceBButton;
@property UITextField *inputField;
@property UIView *dimBG;
@property UIImageView *blurredBG;
@property UIButton *isPro;
@property UIButton *isCon;
@property UIBarButtonItem * decideButton;
@property UIButton * cancelButton;
@property BOOL changeFlag;

@property Decision * decision;
@property Choice   * listening;
@property BOOL keyboardIsShown;
@property UIAlertView * alert;
@property UITextField * currentTxtField;

@property NSMutableArray *choiceAfactors;
@property NSMutableArray *choiceBfactors;
@property NSMutableArray *AtxtFields;
@property NSMutableArray *BtxtFields;

@property id target;
@property SEL action;




-(void)setUpWithDecision:(Decision *)decision;

@end
