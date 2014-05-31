//
//  Decision.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Choice.h"
#import "Comparison.h"

//#define CreateStage 0
//#define ProsConsStage 1
//#define ComparisonStage 2
//#define ResultStage 3
//
//#define darkGreen [UIColor colorWithRed:103/255.0 green:192/255.0 blue:145/255.0 alpha:1]
//#define lightGreen [UIColor colorWithRed:102/255.0 green:248/255.0 blue:167/255.0 alpha:0.6]
//
//#define darkOrange [UIColor colorWithRed:248/255.0 green:178/255.0 blue:3/255.0 alpha:1]
//#define lightOrange [UIColor colorWithRed:255.0/255.0 green:210/255.0 blue:0/255.0 alpha:0.6]
//
//#define bgColor [UIColor colorWithRed:247.0/255.0 green:243/255.0 blue:224/255.0 alpha:1]
//
//#define redTransparent [UIColor colorWithRed:234.0/255.0 green:86/255.0 blue:34/255.0 alpha:0.6]
//#define redOpaque [UIColor colorWithRed:234.0/255.0 green:86/255.0 blue:34/255.0 alpha:1]
//
//#define titleColor [UIColor colorWithRed:247.0/255.0 green:243/255.0 blue:224/255.0 alpha:1]
//
//#define pinkOpaque [UIColor colorWithRed:239.0/255.0 green:151/255.0 blue:112/255.0 alpha:1]


@interface Decision : NSObject <NSCoding, NSCopying>


@property NSString *title;
@property NSMutableArray *choices;
@property NSMutableArray *comparisons;
@property NSMutableArray *history;


@property float AcontributionScore;
@property float BcontributionScore;

//@property float Ascore;
//@property float Bscore;
@property float Arate;
@property float Brate;
//@property int AResult;
//@property int BResult;
@property int rowid;
@property int stage;
@property int round;
@property int numOfCompsDone;

@property Decision * tempDecision;

- (id)initWithChoiceA:(Choice *)choice1 andChoiceB:(Choice *)choice2 andTitle:(NSString *)title;

- (void)updateScore;

-(void)updateContributionScore;

-(void)updateNetworkScore;

- (void)resetStats;

-(void)convergeNetworkScore;

-(void)addComparison:(Comparison *)comparison;

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (id)initWithCoder:(NSCoder *)aDecoder;

-(void)changeTitle:(NSString *)title;


@end
