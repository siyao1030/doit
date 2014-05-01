//
//  Choice.h
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Factor.h"

@interface Choice : NSObject <NSCoding>

@property NSString* title;
@property NSMutableArray* factors;

-(id)initWithTitle:(NSString *)title;
-(void)addToFactors:(Factor *)factor;
- (void)resetStats;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

-(void)changeTitle:(NSString *)title;

@end
