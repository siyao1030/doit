//
//  comparisonMaker.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/23/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Decision.h"
#import "Comparison.h"


@interface ComparisonMaker : NSObject

@property Decision * decision;
@property Choice * choiceA;
@property Choice * choiceB;
@property int randomCount;


-(id)initWithDecision:(Decision *)decision;


-(NSMutableArray *)inOrderCompsGeneratorWithArrayA:(NSMutableArray *)A andArrayB:(NSMutableArray *)B;

-(NSMutableArray *)currentWeightRankingCompsGenerator;

-(NSMutableArray *)randomCompsGenerator;

-(NSMutableArray *)inputOrderCompsGenerator;

-(NSMutableArray *)restCompsGenerator;

//-(Comparison *)singleRandomCompGeneratorWithAArray:(NSMutableArray *)A andBArray:(NSMutableArray *)B;



@end
