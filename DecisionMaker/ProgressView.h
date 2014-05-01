//
//  ProgressView.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/22/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"

@interface ProgressView : UIView

@property Decision * decision;

-(void)setUpWithDecision:(Decision *)decision;

@end
