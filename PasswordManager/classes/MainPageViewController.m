//
//  MainPageViewController.m
//  PasswordManager
//
//  Created by J.H on 13-12-30.
//  Copyright (c) 2013年 J.H. All rights reserved.
//

#import "MainPageViewController.h"
#import "HuxbCommon.h"
#import "DetailPageViewController.h"
#import "HuxbDBOperator.h"

//编辑状态改变
static BOOL edit = YES;

@implementation MainPageViewController

{
    HuxbDBOperator *dbOperate;
}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 添加TableView
    UIImageView* bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f) style:UITableViewStylePlain];
    // 主table背景图
    [mainTableView setBackgroundView:bgImageView];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    // 添加SearchBar
    mainSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    mainSearchBar.placeholder = @"搜索关键字";
    mainSearchBar.delegate = self;
    mainSearchBar.translucent = YES;
    mainSearchBar.tintColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0f];
    mainSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    mainSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mainSearchBar.returnKeyType = UIReturnKeyDone;
    mainSearchBar.enablesReturnKeyAutomatically = NO;
    
    // 将SearchBar作为tableHeaderView
    mainTableView.tableHeaderView = mainSearchBar;
    //将SearchBar添加到SearchDisplayController(SearchDisplayController不能是局部变量)
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:mainSearchBar contentsController:self];
    searchDisplay.delegate = self;
    searchDisplay.searchResultsDelegate = self;
    searchDisplay.searchResultsDataSource = self;
    // 搜索结果表背景图
    searchDisplay.searchResultsTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    
    [self.view addSubview:mainTableView];
    
}

- (void)initData
{
    dbOperate = [HuxbDBOperator createDB];
//    [dbOperate addRecordWithTitle:@"title1" andContent:@"content1"];
//    [dbOperate addRecordWithTitle:@"title2" andContent:@"content2"];
//    [dbOperate delRecordAtIndex:0];
//    [dbOperate updateRecordAtIndex:1 withTitle:@"updatetitle2" andContent:@"updatecontent2"];
//    [dbOperate getDicFromIndex:0];
//    NSLog(@"isRepeatTitle = %d", [dbOperate isRepeatTitle:@"updatetitle"]);
    
    //主table内容固定
    arrayLoc = [NSMutableArray arrayWithArray:[dbOperate getAllRecords]];
}

- (void)viewWillAppear:(BOOL)animated
{
    arrayLoc = [NSMutableArray arrayWithArray:[dbOperate getAllRecords]];
    
//    NSArray *sortAry = [arrayLoc sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
//                        {
//                            NSComparisonResult result = [[[NSString stringWithFormat:@"%@",obj1[@"title"]] lowercaseString] compare:[[NSString stringWithFormat:@"%@",obj2[@"title"]] lowercaseString]];
//                            return result;
//                        }];
//    arrayLoc = [NSMutableArray arrayWithArray:sortAry];
    
    [mainTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 新建
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newDetailPage)];
    // 编辑
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked)];
    // 返回
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    
    [self initData];
    [self initView];

}

- (void)newDetailPage
{
    DetailPageViewController* detailPageViewController = [[DetailPageViewController alloc] initWithContent:nil andRowNum:0 andFlag:YES];
    [self.navigationController pushViewController:detailPageViewController animated:YES];
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonClicked
{
    if(edit)
    {
        [self setEditing:YES animated:YES];
    }
    else
    {
        [self setEditing:NO animated:YES];
    }
}

//导航栏editButton汉化
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if(editing)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonClicked)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked)];
    }
    [mainTableView setEditing:editing animated:YES];
    edit = !edit;
}


#pragma mark UISearchBarDelegate

//  取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    NSLog(@"取消");
}

// 键盘搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"搜索");
}

// 过滤搜索记录
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    isNull = NO;
    //每次将要加载到table中的array初始化,arrayLoc中的数据始终是不变的
    array = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    for (int i = 0; i < [arrayLoc count]; i++)
    {
        dic = [[NSMutableDictionary alloc] init];
        //查找arrayLoc数组元素中是否包含searchText,不区分大小写 (都转换成小写进行比较)
        NSString* lowerTStrSource = [arrayLoc[i][@"title"] lowercaseString];
        NSString* lowerCStrSource = [arrayLoc[i][@"content"] lowercaseString];
        NSString* compareStr = [searchText lowercaseString];
        NSRange tRange = [lowerTStrSource rangeOfString:compareStr];
        NSRange cRange = [lowerCStrSource rangeOfString:compareStr];
        //将符合条件的对象(检查title或content)添加到array
        if(tRange.length != 0 || cRange.length != 0)
        {
            //在array中加上实际行号标记
            [dic setValue:[NSString stringWithFormat:@"%d",i,nil] forKey:@"rowNum"];
            
            //是否匹配title
            if (tRange.length != 0)
            {
                [dic setValue:@"1" forKey:@"isMatchTitle"];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:(NSString *)arrayLoc[i][@"title"]];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(tRange.location, tRange.length)];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:NSMakeRange(tRange.location, tRange.length)];
                [dic setValue:attrStr forKey:@"sTitle"];
            }
            else
            {
                [dic setValue:(NSString *)arrayLoc[i][@"title"] forKey:@"sTitle"];
                [dic setValue:@"0" forKey:@"isMatchTitle"];
            }
            //是否匹配content
            if (cRange.length != 0)
            {
                [dic setValue:@"1" forKey:@"isMatchContent"];
                
                NSUInteger beginPositon = 0, endPosition = 0;
                for (NSUInteger j = cRange.location; j>=0; j--)
                {
                    NSString *tmpStr  = [lowerCStrSource substringWithRange:NSMakeRange(j, 1)];
                    if ([tmpStr isEqualToString:@"\n"])
                    {
                        beginPositon = j+1;
                        break;
                    }
                    if (j == 0)
                    {
                        beginPositon = j;
                        break;
                    }
                }
                for (NSUInteger j = cRange.location; j<lowerCStrSource.length; j++)
                {
                    NSString *tmpStr  = [lowerCStrSource substringWithRange:NSMakeRange(j, 1)];
                    if ([tmpStr isEqualToString:@"\n"])
                    {
                        endPosition = j-1;
                        break;
                    }
                    if (j == lowerCStrSource.length-1)
                    {
                        endPosition = j;
                        break;
                    }
                }
                NSString *showStr = [lowerCStrSource substringWithRange:NSMakeRange(beginPositon, endPosition+1-beginPositon)];
                NSRange tagRange = [showStr rangeOfString:compareStr];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:showStr];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(tagRange.location, tagRange.length)];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(tagRange.location, tagRange.length)];
                [dic setValue:attrStr forKey:@"sContent"];
            }
            else
            {
                [dic setValue:(NSString *)arrayLoc[i][@"content"] forKey:@"sContent"];
                [dic setValue:@"0" forKey:@"isMatchContent"];
            }
           
            [array addObject:dic];
        }
    }
    
//    NSArray *sortAry = [array sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2)
//                         {
//                             NSComparisonResult result = [[[NSString stringWithFormat:@"%@",obj1[@"sTitle"]] lowercaseString] compare:[[NSString stringWithFormat:@"%@",obj2[@"sTitle"]] lowercaseString]];
//                             return result;
//                         }];
//    array = [NSMutableArray arrayWithArray:sortAry];
    
    NSLog(@"search count = %lu",(unsigned long)[array count]);
    //判断搜索结果是否空
    if([array count] == 0)
    {
        isNull = YES;
    }
}

// 自定义cancel按钮
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 在searchBar的子类中找到取消按钮的那个UIView
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        UIView *topView = searchBar.subviews[0];
        for(UIView *subView in topView.subviews)
        {
            // 找到CancelButton，设置其属性
            if([subView isKindOfClass:UIButton.class])
            {
                [(UIButton*)subView setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        for(UIView *subView in searchBar.subviews)
        {
            // 找到CancelButton，设置其属性
            if([subView isKindOfClass:UIButton.class])
            {
                [(UIButton*)subView setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}


#pragma mark UISearchDisplayDelegate

//自定义搜索结果为空的中文显示
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //自定义搜索结果显示
    if (isNull)
    {
        
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        
        for( UIView *subview in tableView1.subviews )
        {
            
            if( [subview class] == [UILabel class] )
            {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                
                lbl.text = @"找不到结果。";
                
            }
            
        }
        
    }
    
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
    
}

#pragma mark UITableViewDataSource

// 删除提示按钮汉化
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailPageViewController* detailPageViewController;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        //搜索中需要用array中标记的实际行号来定行号 (实际行号为其在plist文件中的行号)
        NSInteger rowNum = [array[indexPath.row][@"rowNum"] integerValue];
        NSDictionary *content = [dbOperate getDicFromIndex:rowNum];
        
        detailPageViewController = [[DetailPageViewController alloc] initWithContent:content andRowNum:rowNum andFlag:NO];
    }
    else
    {
        detailPageViewController = [[DetailPageViewController alloc] initWithContent:[dbOperate getDicFromIndex:indexPath.row] andRowNum:indexPath.row andFlag:NO];
    }
    [self.navigationController pushViewController:detailPageViewController animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != self.searchDisplayController.searchResultsTableView)
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 44.0f;
    }
    else
    {
        return 55.0f;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [array count];
    }
    else
    {
        return [arrayLoc count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName =@"cellName";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //是搜索结果表时加载表格
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        if([[[array objectAtIndex:indexPath.row] objectForKey:@"isMatchTitle"] isEqualToString:@"1"])
        {
            cell.textLabel.attributedText = [[array objectAtIndex:indexPath.row] objectForKey:@"sTitle"];
        }
        else
        {
            cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"sTitle"];
        }
        if([[[array objectAtIndex:indexPath.row] objectForKey:@"isMatchContent"] isEqualToString:@"1"])
        {
            cell.detailTextLabel.attributedText = [[array objectAtIndex:indexPath.row] objectForKey:@"sContent"];
        }
        else
        {
            cell.detailTextLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"sContent"];
        }
    }
    //非搜索结果表时加载表格
    else
    {
        cell.textLabel.text = arrayLoc[indexPath.row][@"title"];
        cell.detailTextLabel.text = arrayLoc[indexPath.row][@"content"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

// 删除行时触发代理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [dbOperate delRecordAtIndex:indexPath.row];
        //改变缓存arrayLoc中的数据
        arrayLoc = [NSMutableArray arrayWithArray:[dbOperate getAllRecords]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 调整行位置时触发代理
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(sourceIndexPath == destinationIndexPath)
        return;
    
    NSDictionary *dic = [arrayLoc objectAtIndex:sourceIndexPath.row];
    [dbOperate delRecordAtIndex:sourceIndexPath.row];
    [dbOperate insertRecordAtIndex:destinationIndexPath.row withTitle:dic[@"title"] andContent:dic[@"content"]];
    //改变缓存arrayLoc中的数据
    arrayLoc = [NSMutableArray arrayWithArray:[dbOperate getAllRecords]];
}

@end
