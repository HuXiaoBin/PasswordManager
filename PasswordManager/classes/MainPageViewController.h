//
//  MainPageViewController.h
//  PasswordManager
//
//  Created by J.H on 13-12-30.
//  Copyright (c) 2013年 J.H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* array;      //存储搜索结果表数据
    NSMutableArray* arrayLoc;       //存储本地记录
    UISearchDisplayController* searchDisplay;
    UITableView* mainTableView;
    UISearchBar* mainSearchBar;
    UIButton *rBarButtonItem;
    
    //搜索结果是否为空标志
    BOOL isNull;
}
@end
