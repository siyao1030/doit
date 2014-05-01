//
//  FactorRankingViewController.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/20/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"
#import "FactorRankingCellView.h"

@interface FactorRankingViewController : UIViewController


@property UITableView * tableView;
@property Decision * decision;
@property NSMutableArray * A;
@property NSMutableArray * B;
@property NSMutableArray * factors;

-(id)initWithDecision:(Decision *)decision;

@end
