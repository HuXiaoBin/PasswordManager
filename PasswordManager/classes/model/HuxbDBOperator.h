//
//  HuxbDBOperator.h
//  PasswordManager
//
//  Created by J.Hu on 14/12/8.
//  Copyright (c) 2014年 J.H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuxbDBOperator : NSObject

+ (instancetype)createDB;
- (NSDictionary *)getDicFromIndex:(NSInteger)index;
- (NSArray *)getAllRecords;
- (NSInteger)addRecordWithTitle:(NSString *)title andContent:(NSString *)content;
- (void)delRecordAtIndex:(NSInteger)index;
- (void)updateRecordAtIndex:(NSInteger)index withTitle:(NSString *)title andContent:(NSString *)content;
- (void)insertRecordAtIndex:(NSInteger)index withTitle:(NSString *)title andContent:(NSString *)content;
- (BOOL)isRepeatTitle:(NSString *)title;

@end
