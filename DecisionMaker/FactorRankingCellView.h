//
//  FactorRankingCellView.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/20/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factor.h"

@interface FactorRankingCellView : UIView
@property Factor * factor;
@property Factor * top;
@property BOOL isA;
- (void)setUpWithFactor:(Factor *)factor andTopFactor:(Factor *)top andIsA:(bool)isA;

@end
