//
//  Choice.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "Choice.h"

@implementation Choice

-(id)initWithTitle:(NSString *)title
{
    self.title = title;
    self.factors = [[NSMutableArray alloc]init];
    
    return self;
}


- (void)resetStats
{
    for (Factor * factor in self.factors)
        [factor resetStats];
        
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.factors forKey:@"factors"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.factors = [aDecoder decodeObjectForKey:@"factors"];

    }
    return self;
}

-(void)changeTitle:(NSString *)title
{
    self.title = title;
}

-(void)addToFactors:(Factor *)factor
{
    [self.factors addObject:factor];
}

@end
