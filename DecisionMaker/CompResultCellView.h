//
//  CompResultCellView.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 12/29/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comparison.h"

@interface CompResultCellView : UIView

@property Comparison * comparison;
//@property UILabel * factorALabel;
//@property UILabel * factorBLabel;

- (id)initWithFrame:(CGRect)frame withComparison:(Comparison *)comparison;
- (void)setUpWithComparison:(Comparison *)comparison;

@end
