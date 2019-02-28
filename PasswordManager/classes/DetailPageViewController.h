//
//  DetailPageViewController.h
//  PasswordManager
//
//  Created by HuXiaoBin on 13-12-30.
//  Copyright (c) 2013年 J.H. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DetailPageViewController : UIViewController <UITextFieldDelegate ,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UITextField *titleText;       // 标题
    UITextView *mainTextView;     // 内容
    UILabel *placeholdLbl;        // 内容默认值
    NSInteger Row;
    BOOL New;
    NSMutableDictionary *dicContent;

    UIToolbar* toolbarView;     //键盘工具栏
    int keyboardHeight;     //键盘高度
    CGFloat   keyboardAnimationDuration;  // 键盘动画时间
    NSInteger keyboardAnimationCurve;     // 键盘动画类型
}

/******
@param dic:数据内容
@param isNew:是否新纪录
 ****/
- (id)initWithContent:(NSDictionary *)dic andRowNum:(NSInteger)rowNum andFlag:(BOOL)isNew;

@end
