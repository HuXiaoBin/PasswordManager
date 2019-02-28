//
//  DetailPageViewController.m
//  PasswordManager
//
//  Created by HuXiaoBin on 13-12-30.
//  Copyright (c) 2013年 J.H. All rights reserved.
//

#import "DetailPageViewController.h"
#import "HuxbCommon.h"
#import "MBProgressHUD+MJ.h"
#import "HuxbDBOperator.h"


@implementation DetailPageViewController

{
    HuxbDBOperator *dbOperate;
}

// 初始化过程中传递对应内容字典
- (id)initWithContent:(NSDictionary *)dic andRowNum:(NSInteger)rowNum andFlag:(BOOL)isNew;
{
    if([super init])
    {
        New = isNew;
        Row = rowNum;
        if(!New)
        {
            dicContent = [[NSMutableDictionary alloc] initWithDictionary:dic];
        }
        return self;
    }
    return nil;
}

- (void)initData
{
    dbOperate = [HuxbDBOperator createDB];
}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect frame;
    
    // titleText
    frame.origin.x = 10;
    frame.origin.y = 64+5;
    frame.size.width = 300;
    frame.size.height = 30;
    titleText = [[UITextField alloc] initWithFrame:frame];
    [titleText setFont:[UIFont fontWithName:@"Arial" size:18.0f]];
    titleText.placeholder = @"请输入标题";
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.textColor = [UIColor blackColor];
    titleText.backgroundColor = [UIColor lightGrayColor];
    titleText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleText.delegate = self;
    titleText.returnKeyType = UIReturnKeyDone;
    titleText.clearButtonMode = UITextFieldViewModeWhileEditing;   // 编辑时会出现个修改的X
    titleText.autocorrectionType = UITextAutocorrectionTypeNo;  // 关闭自动语法错误提示
    titleText.autocapitalizationType = UITextAutocapitalizationTypeNone;  // 关闭自动大小写
    titleText.layer.cornerRadius = 15.;
    titleText.layer.borderColor = [UIColor greenColor].CGColor;
    titleText.layer.borderWidth = 1.0f;
    [self.view addSubview:titleText];
    
    // mainTextView
    frame.origin.y += titleText.frame.size.height + 5;
    frame.size.height = 568 - 64 - titleText.frame.size.height - 295;
    mainTextView = [[UITextView alloc] initWithFrame:frame];
    mainTextView.backgroundColor = [UIColor lightGrayColor];
    mainTextView.delegate = self;
    mainTextView.textColor = [UIColor blackColor];
    mainTextView.font = [UIFont fontWithName:@"Arial" size:16.0f];
    mainTextView.returnKeyType = UIReturnKeyDefault;
    mainTextView.scrollEnabled = YES;
    mainTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mainTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    mainTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mainTextView.layer.borderColor = [UIColor greenColor].CGColor;
    mainTextView.layer.borderWidth = 1.f;
    mainTextView.layer.cornerRadius = 20.f;
    [self.view addSubview:mainTextView];
    
    // placeholdLbl
    frame.origin.x +=7;
    frame.origin.y +=4;
    frame.size.height = 25;
    placeholdLbl = [[UILabel alloc] initWithFrame:frame];
    placeholdLbl.text = @"请输入内容";
    placeholdLbl.textColor = [UIColor grayColor];
    placeholdLbl.alpha = 0.9;
    placeholdLbl.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:placeholdLbl];
    
    if(!New)
    {
        //显示内容
        titleText.text = [NSString stringWithFormat:@"%@", [dicContent objectForKey:@"title"]];
        mainTextView.text = [NSString stringWithFormat:@"%@", [dicContent objectForKey:@"content"]];
        placeholdLbl.hidden = YES;
    }
    else
        placeholdLbl.hidden = NO;
    
//    // 照相按钮
//    UIButton *cameraBtnItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cameraBtnItem.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
//    [cameraBtnItem setTitle:@"照相" forState:UIControlStateNormal];
//    [cameraBtnItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cameraBtnItem setBackgroundColor:[UIColor clearColor]];
//    [cameraBtnItem addTarget:self action:@selector(cameraBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtnItem];
//    
//    // 相册按钮
//    UIButton *photoBtnItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    photoBtnItem.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
//    [photoBtnItem setTitle:@"相册" forState:UIControlStateNormal];
//    [photoBtnItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [photoBtnItem setBackgroundColor:[UIColor clearColor]];
//    [photoBtnItem addTarget:self action:@selector(photoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *photoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:photoBtnItem];
    
    // 空白填充按钮
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // 隐藏键盘按钮
    UIButton *hiddenBtnItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    hiddenBtnItem.frame = CGRectMake(0.0f, 0.0f, 70.0f, 30.0f);
    [hiddenBtnItem setTitle:@"隐藏键盘" forState:UIControlStateNormal];
    [hiddenBtnItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hiddenBtnItem setBackgroundColor:[UIColor clearColor]];
    [hiddenBtnItem addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hiddenBtnItem];
    
    // 在弹出小键盘上添加工具栏
    toolbarView = [[UIToolbar alloc] init];
    toolbarView.barStyle = UIBarStyleDefault;
    toolbarView.items = [NSArray arrayWithObjects:spaceButtonItem, hiddenButtonItem,nil];
    [self.view addSubview:toolbarView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //增加监听，当键盘出现或消失时发出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [titleText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 移除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [titleText removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}


#pragma mark Toolbar buttons' method

//照相
- (void)cameraBtnClicked
{
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

//打开相册
- (void)photoBtnClicked
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
    else
    {
        [MBProgressHUD showError:@"不能打开相片库，请在系统设置中打开"];
        return;
    }
}

//隐藏键盘
- (void)hiddenKeyBoard
{
    [mainTextView resignFirstResponder];
}


#pragma mark UIImagePickerControllerDelegate

//照相机照完后use图片或在图片库中点击图片触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextViewDelegate

// textView文本变化时是否显示默认文字
- (void)textViewDidChange:(UITextView *)textView
{
    if([mainTextView.text isEqualToString:@""])
        placeholdLbl.hidden = NO;
    else
        placeholdLbl.hidden = YES;
    //内容有改动时出现Save按钮
    if(!([[dicContent objectForKey:@"content"] isEqualToString:mainTextView.text] && [[dicContent objectForKey:@"title"] isEqualToString:titleText.text]))
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    else
        self.navigationItem.rightBarButtonItem = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        toolbarView.frame = CGRectMake(0,568,320,40);
    else
        toolbarView.frame = CGRectMake(0,504,320,40);
    
    //升起工具栏
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:keyboardAnimationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)keyboardAnimationCurve];
    
    toolbarView.transform = CGAffineTransformTranslate(toolbarView.transform, 0, -(keyboardHeight + 40));
    
    [UIView commitAnimations];
}

// 收起小键盘时操作
- (void)textViewDidEndEditing:(UITextView *)textView
{
    // 收起工具栏动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:keyboardAnimationDuration];
    
    toolbarView.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
}

// 保存数据
- (void)save
{
    if([titleText.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"请输入标题~"];
        return;
    }
    else if([mainTextView.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"请输入内容~"];
        return;
    }
    else if(New && [dbOperate isRepeatTitle:titleText.text])
    {
        // 新创建的同名记录
        [MBProgressHUD showError:@"存在相同标题，请修改标题~"];
        return;
    }
    
    NSString* strTitle = [NSString stringWithFormat:@"%@",titleText.text];
    NSString* strBody = [NSString stringWithFormat:@"%@", mainTextView.text];
    NSLog(@"title = %@, content = %@",strTitle, strBody);
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:strTitle, @"title", strBody, @"content",nil];
    
    if(New)
    {
        Row = [dbOperate addRecordWithTitle:strTitle andContent:strBody];
        New = false;  // 保存一次后就为修改记录,且不用检查同名
    }
    else
    {
        [dbOperate updateRecordAtIndex:Row withTitle:strTitle andContent:strBody];
    }
    
    dicContent = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [titleText resignFirstResponder];
    [mainTextView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度、动画时间、动画类型
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardHeight = keyboardRect.size.height;
    keyboardAnimationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    keyboardAnimationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    NSLog(@"keyboardHeight = %i, Duration = %f, Curve = %ld",keyboardHeight, keyboardAnimationDu/ration, (long)keyboardAnimationCurve);
    
}

//当键盘消失时调用
- (void)keyboardWillDisappear:(NSNotification *)aNotification
{
    //获取键盘的动画时间
    NSDictionary *userInfo = [aNotification userInfo];
    keyboardAnimationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSLog(@"Duration = %f",keyboardAnimationDuration);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    //内容有改动时出现Save按钮
    if(!([[dicContent objectForKey:@"content"] isEqualToString:mainTextView.text] && [[dicContent objectForKey:@"title"] isEqualToString:titleText.text]))
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    else
        self.navigationItem.rightBarButtonItem = nil;
}

@end
