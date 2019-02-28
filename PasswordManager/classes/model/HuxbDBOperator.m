//
//  HuxbDBOperator.m
//  PasswordManager
//
//  Created by J.Hu on 14/12/8.
//  Copyright (c) 2014年 J.H. All rights reserved.
//

#import "HuxbDBOperator.h"

@implementation HuxbDBOperator

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self createFile];
    }
    return self;
}

// 返回数据库路径(这里数据库是在用户home目录)
- (NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"huxbdb.plist"]; // 数据库全路径
    return dbFilePath;
}

- (void)createFile
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbFilePath = [self databaseFilePath];    // 数据库全路径
    BOOL bRet = [fileMgr fileExistsAtPath:dbFilePath];
    if (!bRet)
    {
    //  数据库没有文件则拷贝文件到数据库
        NSString *sourceFilePath =[[NSBundle mainBundle]
                                               pathForResource:@"huxbdb"
                                               ofType:@"plist"];
        NSData *sourceFileData = [NSData dataWithContentsOfFile:sourceFilePath];

        [fileMgr createFileAtPath:dbFilePath contents:sourceFileData attributes:nil];
        NSLog(@"创建/拷贝文件 --> huxbdb.plist 成功!");
    }
    
//    NSArray *array = @[@"obj1", @"obj2"];
//    [array writeToFile:dbFilePath atomically:YES];
}

// 创建plist文件数据库
+ (instancetype)createDB
{
    return [[self alloc] init];
}

// 新增记录
- (NSInteger)addRecordWithTitle:(NSString *)title andContent:(NSString *)content
{
    NSString *dbPath = [self databaseFilePath];
    NSMutableArray *arrayM;
    NSArray *array = [NSArray arrayWithContentsOfFile:dbPath];
    arrayM = [NSMutableArray arrayWithArray:array];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", content, @"content", nil];
    [arrayM addObject:dic];
    [arrayM writeToFile:dbPath atomically:YES];
    NSLog(@"Add record --> %@",dic);
    return [arrayM count]-1;
}

// 删除记录
- (void)delRecordAtIndex:(NSInteger)index
{
    NSString *dbPath = [self databaseFilePath];
    if((![NSArray arrayWithContentsOfFile:dbPath]) || ([[NSArray arrayWithContentsOfFile:dbPath] count] == 0))
    {
        NSLog(@"没有记录！");
        return;
    }
    else
    {
        NSMutableArray *arrayM = [NSMutableArray arrayWithContentsOfFile:dbPath];
        [arrayM removeObjectAtIndex:index];
        [arrayM writeToFile:dbPath atomically:YES];
        NSLog(@"Delete record at index %ld", index);
    }
}

// 修改记录
- (void)updateRecordAtIndex:(NSInteger)index withTitle:(NSString *)title andContent:(NSString *)content
{
    NSString *dbPath = [self databaseFilePath];
    if((![NSArray arrayWithContentsOfFile:dbPath]) || ([[NSArray arrayWithContentsOfFile:dbPath] count] == 0))
    {
        NSLog(@"没有记录！");
        return;
    }
    else
    {
        NSMutableArray *arrayM = [NSMutableArray arrayWithContentsOfFile:dbPath];
        [arrayM removeObjectAtIndex:index];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", content, @"content", nil];
        [arrayM insertObject:dic atIndex:index];
        [arrayM writeToFile:dbPath atomically:YES];
        NSLog(@"Update record --> %@",dic);
    }
}

// 插入记录
- (void)insertRecordAtIndex:(NSInteger)index withTitle:(NSString *)title andContent:(NSString *)content
{
    NSString *dbPath = [self databaseFilePath];
    if((![NSArray arrayWithContentsOfFile:dbPath]) || ([[NSArray arrayWithContentsOfFile:dbPath] count] == 0))
    {
        NSLog(@"没有记录！");
        return;
    }
    else
    {
        NSMutableArray *arrayM = [NSMutableArray arrayWithContentsOfFile:dbPath];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", content, @"content", nil];
        [arrayM insertObject:dic atIndex:index];
        [arrayM writeToFile:dbPath atomically:YES];
        NSLog(@"Insert record --> %@", dic);
    }
}

// 返回所有记录
- (NSArray *)getAllRecords
{
    NSString *dbPath = [self databaseFilePath];
    if((![NSArray arrayWithContentsOfFile:dbPath]) || ([[NSArray arrayWithContentsOfFile:dbPath] count] == 0))
    {
        NSLog(@"没有记录！");
        return nil;
    }
    else
    {
        return [NSArray arrayWithContentsOfFile:dbPath];
    }
}

// 获取第index条记录
- (NSDictionary *)getDicFromIndex:(NSInteger)index
{
    NSString *dbPath = [self databaseFilePath];
    if((![NSArray arrayWithContentsOfFile:dbPath]) || ([[NSArray arrayWithContentsOfFile:dbPath] count] == 0))
    {
        NSLog(@"没有记录！");
        return nil;
    }
    else
    {
        NSArray *arrayM = [NSArray arrayWithContentsOfFile:dbPath];
        NSLog(@"Get record at index --> %ld",index);
        return arrayM[index];
    }
}

// 是否存在重复title
- (BOOL)isRepeatTitle:(NSString *)title
{
    NSString *dbPath = [self databaseFilePath];
    if((![NSArray arrayWithContentsOfFile:dbPath]) || ([[NSArray arrayWithContentsOfFile:dbPath] count] == 0))
    {
        NSLog(@"没有记录！");
        return false;
    }
    else
    {
        NSArray *array = [NSArray arrayWithContentsOfFile:dbPath];
        for (NSDictionary *dic in array)
        {
            if([dic[@"title"] isEqualToString:title])
            {
                return true;
            }
        }
    }
    
    return false;
}

@end
