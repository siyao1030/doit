//
//  Comparison.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/24/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Factor.h"


@interface Comparison : NSObject <NSCopying>

@property Factor * factorA;
@property Factor * factorB;
@property int factorAIndex;
@property int factorBIndex;


@property float factorAWeight;
@property float factorBWeight;

-(id)initWithFactorA:(Factor *)factorA andFactorB:(Factor *)factorB;

-(id)initWithFactorA:(Factor *)factorA andIndex:(int)a andFactorB:(Factor *)factorB andindex:(int)b;

- (void)resetStats;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
