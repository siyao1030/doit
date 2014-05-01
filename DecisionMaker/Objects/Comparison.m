//
//  Comparison.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/24/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "Comparison.h"

@implementation Comparison

-(id)initWithFactorA:(Factor *)factorA andFactorB:(Factor *)factorB
{
    self.factorA = factorA;
    self.factorB = factorB;
    self.factorAWeight = 50;
    self.factorBWeight = 50;
    
    return self;
}

-(id)initWithFactorA:(Factor *)factorA andIndex:(int)a andFactorB:(Factor *)factorB andindex:(int)b;
{
    self.factorA = factorA;
    self.factorB = factorB;
    self.factorAIndex = a;
    self.factorBIndex = b;
    self.factorAWeight = 50;
    self.factorBWeight = 50;
    
    return self;
}

- (void)resetStats
{
    [self.factorA resetStats];
    [self.factorB resetStats];
    self.factorAWeight = 50;
    self.factorBWeight = 50;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.factorA forKey:@"factorA"];
    [aCoder encodeObject:self.factorB forKey:@"factorB"];
    [aCoder encodeFloat:self.factorAWeight forKey:@"factorAWeight"];
    [aCoder encodeFloat:self.factorBWeight forKey:@"factorBWeight"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.factorA = [aDecoder decodeObjectForKey:@"factorA"];
        self.factorB = [aDecoder decodeObjectForKey:@"factorB"];
        self.factorAWeight = [aDecoder decodeFloatForKey:@"factorAWeight"];
        self.factorBWeight = [aDecoder decodeFloatForKey:@"factorBWeight"];
        
    }
    return self;
}

@end
