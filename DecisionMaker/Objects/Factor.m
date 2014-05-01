//
//  Factor.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "Factor.h"

@implementation Factor

-(id)initWithTitle:(NSString *)title andIsPro:(BOOL)isPro;
{
    self.title = title;
    self.isPro = isPro;
    self.averageWeight = 0;
    self.weights = [[NSMutableArray alloc] init];
    self.comparedWith = [[NSMutableArray alloc] init];
    self.score = 10.0;
    self.totalContribution = 0.0;
    self.tempScore = 0.0;
    
    
    return self;
}

- (void)resetStats
{
    self.averageWeight = 0.0;
    self.totalContribution  = 0.0;
    self.score = 10.0;
    self.weights = [[NSMutableArray alloc] init];
    self.comparedWith = [[NSMutableArray alloc] init];
    self.tempScore = 0.0;
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.weights forKey:@"weights"];
    [aCoder encodeObject:self.comparedWith forKey:@"comparedWith"];
    [aCoder encodeFloat:self.averageWeight forKey:@"averageWeight"];
    [aCoder encodeFloat:self.score forKey:@"score"];
    [aCoder encodeFloat:self.finalScore forKey:@"finalScore"];
    [aCoder encodeBool:self.isPro forKey:@"isPro"];
    [aCoder encodeFloat:self.totalContribution forKey:@"totalContribution"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.weights = [aDecoder decodeObjectForKey:@"weights"];
        self.comparedWith = [aDecoder decodeObjectForKey:@"comparedWith"];
        self.averageWeight = [aDecoder decodeFloatForKey:@"averageWeight"];
        self.score = [aDecoder decodeFloatForKey:@"score"];
        self.finalScore = [aDecoder decodeFloatForKey:@"finalScore"];
        self.isPro = [aDecoder decodeBoolForKey:@"isPro"];
        self.totalContribution = [aDecoder decodeFloatForKey:@"totalContribution"];
        
        
    }
    return self;
}



-(BOOL)alreadyComparedWithFactor:(Factor *)otherFactor
{
    for (NSArray * thisFactor in self.comparedWith)
    {
        //NSLog(@"A has already compared with: %d",i.intValue);
        if ([[[thisFactor objectAtIndex:0 ] title] isEqualToString:otherFactor.title])
            return YES;
    }
    return NO;
    
}
-(void)updateAverageWeight
{
    //NSNumber *newW = self.weights[self.weights.count-1];
    
    //self.averageWeight = (self.averageWeight * (self.weights.count-1) + newW.doubleValue)/self.weights.count;
    int sum = 0;
    for (NSNumber * weight in self.weights)
    {
        sum+=weight.floatValue;
    }
    self.averageWeight = sum/self.weights.count;
    
    
  }

- (id)copyWithZone:(NSZone *)zone
{
    Factor * copy = [[Factor alloc] initWithTitle:self.title andIsPro:self.isPro];
    
    if (copy)
    {
        copy.weights = [self.weights copyWithZone:zone];
        copy.comparedWith = [self.comparedWith copyWithZone:zone];
        copy.averageWeight = self.averageWeight;
        copy.score = self.score;
        copy.finalScore = self.finalScore;
        copy.totalContribution = self.totalContribution;
        copy.tempScore = self.tempScore;

    }
    
    return copy;
}
@end
