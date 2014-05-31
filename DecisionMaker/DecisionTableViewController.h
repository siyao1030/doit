//
//  DecisionTableViewController.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"
#import "CreateDecisionViewController.h"
#import "AddProsConsViewController.h"
#import "EnterProsConsViewController.h"
#import "ComparisonViewController.h"
#import "ResultViewController.h"
#import "Database.h"

@interface DecisionTableViewController : UITableViewController

@property CreateDecisionViewController * createDecisionView;

@property NSMutableArray * decisions;

@property id target;
@property SEL action;

-(void)addDecision:(Decision *)decision;

@end
