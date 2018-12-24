//
//  InquireInfoViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InquireInfoOfAdministrativePenaltyViewController.h"
#import "Systype.h"
#import "RoadSegment.h"
#import "Citizen.h"
#import "UserInfo.h"
#import "ListSelectViewController.h"

@interface InquireInfoOfAdministrativePenaltyViewController()<ListSelectPopoverDelegate>{
    //判断当前信息是否保存
    bool inquireSaved;
    //位置字符串
    NSString *localityString;
}
//所选问题的标识
@property (nonatomic,copy)   NSString *askID;
@property (nonatomic,retain) NSMutableArray *caseInfoArray;
@property (nonatomic,retain) UIPopoverController *pickerPopOver;
@property (nonatomic, strong) UIPopoverController *listSelectPopover;
@property (nonatomic, strong) NSArray *users;

-(void)loadCaseInfoArray;
-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;
-(void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up;
-(void)insertString:(NSString *)insertingString intoTextView:(UITextView *)textView;
-(NSString *)getEventDescWithCitizenName:(NSString *)citizenName;

@end

enum kUITextFieldTag {
    kUITextFieldTagAsk = 100,
    kUITextFieldTagAnswer,
    kUITextFieldTagNexus,
    kUITextFieldTagParty,
    kUITextFieldTagLocality,
    kUITextFieldTagInquireDate,
    kUITextFieldTagInquirer,
    kUITextFieldTagRecorder
};

@implementation InquireInfoOfAdministrativePenaltyViewController

@synthesize uiButtonAdd = _uiButtonAdd;
@synthesize inquireTextView = _inquireTextView;
@synthesize textAsk = _textAsk;
@synthesize textAnswer = _textAnswer;
@synthesize textNexus = _textNexus;
@synthesize textParty = _textParty;
@synthesize textLocality = _textLocality;
@synthesize textInquireDate = _textInquireDate;
@synthesize caseInfoListView = _caseInfoListView;
@synthesize caseID=_caseID;
@synthesize caseInfoArray=_caseInfoArray;
@synthesize pickerPopOver=_pickerPopOver;
@synthesize askID=_askID;
@synthesize answererName=_answererName;
@synthesize delegate=_delegate;
@synthesize navigationBar = _navigationBar;



#pragma mark - init on get
- (NSArray *)users{
    if (_users == nil) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (UserInfo *thisUserInfo in [UserInfo allUserInfo]) {
            [result addObject: thisUserInfo.username];
        }
        _users = [result copy];
    }
    return _users;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //remove UINavigationBar inner shadow in iOS 7
    [_navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    _navigationBar.shadowImage = [[UIImage alloc] init];
    

    self.askID = @"";
    self.textAsk.text = @"";
    self.textAnswer.text = @"";
    inquireSaved = YES;
    self.textNexus.text = @"当事人";
    
    // 分配tag add by xushiwen in 2013.7.26
    self.textAsk.tag = kUITextFieldTagAsk;
    self.textAnswer.tag = kUITextFieldTagAnswer;
    self.textNexus.tag = kUITextFieldTagNexus;
    self.textParty.tag = kUITextFieldTagParty;
    self.textLocality.tag = kUITextFieldTagLocality;
    self.textInquireDate.tag = kUITextFieldTagInquireDate;
    self.textFieldInquirer.tag = kUITextFieldTagInquirer;
    self.textFieldRecorder.tag = kUITextFieldTagRecorder;
    
//    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"询问笔录-bg" ofType:@"png"];
//    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    
    //监视键盘出现和隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.inquireTextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //生成常见案件信息答案
    [self loadCaseInfoArray];
    //载入询问笔录
    if (![self.answererName isEmpty]) {
        [self loadInquireInfoForCase:self.caseID andAnswererName:self.answererName];
    } else {
        [self loadInquireInfoForCase:self.caseID andAnswererName:@""];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.inquireTextView removeObserver:self forKeyPath:@"text"];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setCaseID:nil];
    [self setCaseInfoArray:nil];
    [self setInquireTextView:nil];
    [self setTextAsk:nil];
    [self setTextAnswer:nil];
    [self setAskID:nil];
    [self setTextNexus:nil];
    [self setTextParty:nil];
    [self setTextLocality:nil];
    [self setTextInquireDate:nil];
    [self setAnswererName:nil];
    [self setUiButtonAdd:nil];
    [self setCaseInfoListView:nil];
    [self setDelegate:nil];
    [self setTextFieldInquirer:nil];
    [self setTextFieldRecorder:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//添加常用问答
- (IBAction)btnAddRecord:(id)sender{
    if (![self.textAsk.text isEmpty]) {
        NSString *insertingString;
        if(![self.textAnswer.text isEmpty]){
            insertingString=[NSString stringWithFormat:@"%@\n%@",self.textAsk.text,self.textAnswer.text];
        }else{
            insertingString=[NSString stringWithFormat:@"%@",self.textAsk.text];
        }
        [self insertString:insertingString intoTextView:self.inquireTextView];
    } else {
        [self insertString:self.textAnswer.text intoTextView:self.inquireTextView];
    }
}
//返回按钮，若未保存，则提示
-(IBAction)btnDismiss:(id)sender{
    if ([self.caseID isEmpty] || [self.textParty.text isEmpty] || inquireSaved) {
        [self.delegate loadInquireForAnswerer:self.textParty.text];
        [self dismissModalViewControllerAnimated:YES];
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前询问笔录已修改，尚未保存，是否返回？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];    
        [alert show];
    }    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self dismissModalViewControllerAnimated:YES];
    }
}


//键盘出现和消失时，变动TextView的大小
-(void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.inquireTextView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    if (keyboardFrame.size.height>360) {
        newFrame.size.height = up?269:635;
    } else {
        newFrame.size.height =  up?323:635;
    }
    self.inquireTextView.frame = newFrame;
    
    [UIView commitAnimations];   
}

-(void)keyboardWillShow:(NSNotification *)aNotification{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

//保存当前询问笔录信息
-(IBAction)btnSave:(id)sender{
    if (![self.textParty.text isEmpty]) {
        inquireSaved=YES;
        [self saveInquireInfoForCase:self.caseID andAnswererName:self.textParty.text];
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"无法保存" message:@"缺少被询问人姓名，无法正常保存。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)loadInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName{
    self.textAnswer.text=@"";
    self.textAsk.text=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInquire" inManagedObjectContext:context];
    NSPredicate *predicate;
    if ([aAnswererName isEmpty]) {
        predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@",caseID];
    } else {
        predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id==%@) && (answerer_name==%@)",caseID,aAnswererName];
    }    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];   
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    CaseInquire *caseInquire;
    if (tempArray.count>0) {
        caseInquire=[tempArray objectAtIndex:0];
        self.textParty.text=caseInquire.answerer_name;
        self.textNexus.text=caseInquire.relation;
        self.inquireTextView.text=caseInquire.inquiry_note;
        if ([caseInquire.locality isEmpty]) {
            self.textLocality.text=localityString;
        } else {
            self.textLocality.text=caseInquire.locality;
        }        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textInquireDate.text=[dateFormatter stringFromDate:caseInquire.date_inquired];
        self.textFieldInquirer.text = caseInquire.inquirer_name;
        self.textFieldRecorder.text = caseInquire.recorder_name;
    } else {
        self.textParty.text=aAnswererName;
//        self.inquireTextView.text=[[Systype typeValueForCodeName:@"询问笔录固定用语"] lastObject];
        self.textLocality.text=localityString;
    }
    inquireSaved=YES;
}

-(void)loadInquireInfoForCase:(NSString *)caseID andNexus:(NSString *)aNexus{
    self.textAnswer.text=@"";
    self.textAsk.text=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInquire" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id==%@) && (relation==%@)",caseID,aNexus];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];   
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    CaseInquire *caseInquire;
    if (tempArray.count>0) {
        caseInquire=[tempArray objectAtIndex:0];
        self.textParty.text=caseInquire.answerer_name;
        self.textNexus.text=caseInquire.relation;
        self.inquireTextView.text=caseInquire.inquiry_note;
        if ([caseInquire.locality isEmpty]) {
            self.textLocality.text=localityString;
        } else {
            self.textLocality.text=caseInquire.locality;
        }        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textInquireDate.text=[dateFormatter stringFromDate:caseInquire.date_inquired];
    } else {
//        self.inquireTextView.text=[[Systype typeValueForCodeName:@"询问笔录固定用语"] lastObject];
        self.textLocality.text=localityString;
    }
    inquireSaved=YES;
}

-(void)saveInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInquire" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id==%@) && (answerer_name==%@)",caseID,aAnswererName];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    CaseInquire *caseInquire;
    if (tempArray.count>0) {
        caseInquire=[tempArray objectAtIndex:0];
    } else {
        caseInquire=[CaseInquire newDataObjectWithEntityName:@"CaseInquire"];
        caseInquire.proveinfo_id=self.caseID;
        caseInquire.answerer_name=aAnswererName;
    }


    caseInquire.inquirer_name = self.textFieldInquirer.text;
    caseInquire.recorder_name = self.textFieldRecorder.text;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    caseInquire.date_inquired=[dateFormatter dateFromString:self.textInquireDate.text];
    caseInquire.locality=self.textLocality.text;
    //分行显示，替换字符串\n 转换为\r\n
    NSString * inquiryStr = self.inquireTextView.text;
    
    inquiryStr = [inquiryStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\r"];
    
    caseInquire.inquiry_note=inquiryStr;
    
    entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id==%@) && (party==%@)",self.caseID,aAnswererName];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    tempArray=[context executeFetchRequest:fetchRequest error:nil];
    if (tempArray.count>0) {
        Citizen *citizen=[tempArray objectAtIndex:0];
        caseInquire.relation=citizen.nexus;
        caseInquire.sex=citizen.sex;
        caseInquire.age=citizen.age;
        caseInquire.company_duty=[NSString stringWithFormat:@"%@ %@",citizen.org_name?citizen.org_name:@"",citizen.org_principal_duty?citizen.org_principal_duty:@""];
        caseInquire.phone=citizen.tel_number;
        caseInquire.postalcode=citizen.postalcode;
        caseInquire.address=citizen.address;
    }    
    [[AppDelegate App] saveContext];
}


//文本框点击事件
- (IBAction)textTouched:(UITextField *)sender {
    switch (sender.tag) {
        case kUITextFieldTagAsk:{
            //点击问
            [self pickerPresentForIndex:2 fromRect:sender.frame];
        }
            break;
        case kUITextFieldTagAnswer:{
            //点击答
            [self pickerPresentForIndex:3 fromRect:sender.frame];
        }
            break;
        case kUITextFieldTagNexus:{
            //被询问人类型
            [self pickerPresentForIndex:0 fromRect:sender.frame];
        }
            break;
        case kUITextFieldTagParty:{
            //被询问人
            [self pickerPresentForIndex:1 fromRect:sender.frame];
        }
            break;
        case kUITextFieldTagLocality:{
            //询问地点
            if ([self.pickerPopOver isPopoverVisible]) {
                [self.pickerPopOver dismissPopoverAnimated:YES];
            }
        }
            break;
        case kUITextFieldTagInquireDate:{
            //询问时间
            if ([self.pickerPopOver isPopoverVisible]) {
                [self.pickerPopOver dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=1;
                datePicker.datePicker.maximumDate=[NSDate date];
                [datePicker showdate:self.textInquireDate.text];
                self.pickerPopOver=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopOver;
            }
        }
            break;
        // 询问人和记录人 add  by xushiwen in 2013.7.26
        case kUITextFieldTagInquirer:
        case kUITextFieldTagRecorder:
            [self presentPopoverFromRect:sender.frame dataSource:self.users tableViewTag:sender.tag];
            break;
        default:
            break;
    }
}

//弹窗
-(void)pickerPresentForIndex:(NSInteger )pickerType fromRect:(CGRect)rect{
    if ([_pickerPopOver isPopoverVisible]) {
        [_pickerPopOver dismissPopoverAnimated:YES];
    } else {
        AnswererPickerViewController *pickerVC=[[AnswererPickerViewController alloc] initWithStyle:
                                                UITableViewStylePlain];
        pickerVC.pickerType=pickerType;
        pickerVC.delegate=self;
        self.pickerPopOver=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        if (pickerType == 0 || pickerType == 1 ) {
            pickerVC.tableView.frame=CGRectMake(0, 0, 140, 176);
            self.pickerPopOver.popoverContentSize=CGSizeMake(140, 176);
        } 
        if (pickerType == 2 || pickerType ==3) {
            pickerVC.tableView.frame=CGRectMake(0, 0, 388, 280);
            [pickerVC.tableView setRowHeight:70];
            self.pickerPopOver.popoverContentSize=CGSizeMake(388, 280);
        } 
        [_pickerPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.pickerPopover=self.pickerPopOver;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.caseInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"CaseInfoAnswserCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text=[self.caseInfoArray objectAtIndex:indexPath.row];
    return cell;
}

//将选中的答案填到textfield和textview中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [self insertString:cell.textLabel.text intoTextView:self.inquireTextView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




//载入案件数据常用答案
-(void)loadCaseInfoArray{
    if (self.caseInfoArray==nil) {
        self.caseInfoArray=[[NSMutableArray alloc] initWithCapacity:1];
    } else {
        [self.caseInfoArray removeAllObjects];
    }        
    //事故信息
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    NSString *dateString;
    NSString *reasonString;
    if (caseInfo) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
        dateString=[formatter stringFromDate:caseInfo.happen_date];
        if (dateString) {
            //[self.caseInfoArray addObject:dateString];
        }        
        NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
        [numFormatter setPositiveFormat:@"000"];        
        NSInteger stationStartM=caseInfo.station_start.integerValue%1000;        
        NSString *stationStartKMString=[NSString stringWithFormat:@"%02d", caseInfo.station_start.integerValue/1000];
        NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
        NSString *stationString;
        if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
            stationString=[NSString stringWithFormat:@"K%@+%@M处",stationStartKMString,stationStartMString];
        } else {            
            NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
            NSString *stationEndKMString=[NSString stringWithFormat:@"%02d",caseInfo.station_end.integerValue/1000];
            NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
            stationString=[NSString stringWithFormat:@"K%@+%@M至K%@+%@M处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
        }
        NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];

        localityString=[NSString stringWithFormat:@"%@%@%@",roadName,caseInfo.side,stationString];
        //[self.caseInfoArray addObject:localityString];
        reasonString=[NSString stringWithFormat:@"由于%@",caseInfo.case_reason];
        //[self.caseInfoArray addObject:reasonString];
    }
    
    [self.caseInfoListView reloadData];
}

-(NSString *)getEventDescWithCitizenName:(NSString *)citizenName{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    //高速名称，以后确定道路根据caseInfo.roadsegment_id获取
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    
    
    NSString *caseDescString=@"";    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%02d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString=[NSString stringWithFormat:@"K%@+%@处",stationStartKMString,stationStartMString];
    NSArray *citizenArray=[Citizen allCitizenNameForCase:self.caseID];
    if (citizenArray.count>0) {
        if (citizenArray.count==1) {
            Citizen *citizen=[citizenArray objectAtIndex:0];
            
            caseDescString=[caseDescString stringByAppendingFormat:@"于%@驾驶%@%@行至%@%@%@在公路%@由于%@发生交通事故。",happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString,caseInfo.place,caseInfo.case_reason];
        }
        if (citizenArray.count>1) {
            for (Citizen *citizen in citizenArray) {
                if ([citizen.automobile_number isEqualToString:citizenName]) {
                    caseDescString=[caseDescString stringByAppendingFormat:@"于%@驾驶%@%@行至%@%@%@，与",happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString];
                }
            }
            NSString *citizenString=@"";
            for (Citizen *citizen in citizenArray) {
                if (![citizen.automobile_number isEqualToString:citizenName]) {
                    if ([citizenString isEmpty]) {
                        citizenString=[citizenString stringByAppendingFormat:@"%@%@",citizen.automobile_number,citizen.automobile_pattern];
                    } else {
                        citizenString=[citizenString stringByAppendingFormat:@"、%@%@",citizen.automobile_number,citizen.automobile_pattern];
                    }
                }
            }
            caseDescString=[caseDescString stringByAppendingFormat:@"在公路%@由于%@发生碰撞，造成交通事故。",caseInfo.place,caseInfo.case_reason];
        }
    }
    return caseDescString;
}

-(NSString *)getDeformDescWithCitizenName:(NSString *)citizenName{
    NSString *deformString=@"";
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *deformEntity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
    NSPredicate *deformPredicate=[NSPredicate predicateWithFormat:@"proveinfo_id ==%@ && citizen_name==%@",self.caseID,citizenName];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:deformEntity];
    [fetchRequest setPredicate:deformPredicate];
    NSArray *deformArray=[context executeFetchRequest:fetchRequest error:nil];
    if (deformArray.count>0) {
        for (CaseDeformation *deform in deformArray) {
            NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([roadSizeString isEmpty]) {
                roadSizeString=@"";
            } else {
                roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
            }
            NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([remarkString isEmpty]) {
                remarkString=@"";
            } else {
                remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
            }
            NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
            NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
            quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
            deformString=[deformString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
        }
        NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
        deformString=[deformString stringByTrimmingCharactersInSet:charSet];
        if ([citizenName isEqualToString:@"共同"]) {
            deformString=[NSString stringWithFormat:@"共同损坏路产：%@。",deformString];
        } else {
            Citizen *citzen = [Citizen citizenForName:citizenName nexus:@"当事人" case:self.caseID];
            if (citzen) {
                NSString *partyName=citzen.party==nil?@"":citzen.party;
                deformString=[partyName stringByAppendingFormat:@"损坏路产：%@。",deformString];
            }
        }
    } else {
        deformString=@"";
    }
    return deformString;
}

//在光标位置插入文字
-(void)insertString:(NSString *)insertingString intoTextView:(UITextView *)textView  
{  
    NSRange range = textView.selectedRange;
    if (range.location != NSNotFound) {
        NSString * firstHalfString = [textView.text substringToIndex:range.location];
        NSString * secondHalfString = [textView.text substringFromIndex: range.location];
        textView.scrollEnabled = NO;  // turn off scrolling
        
        if(![firstHalfString isEmpty] && ![secondHalfString isEmpty]){
            textView.text=[NSString stringWithFormat:@"%@\n%@%@",
                           firstHalfString,
                           insertingString,
                           secondHalfString
                           ];
            range.location += [insertingString length]+1;
        }else if(![secondHalfString isEmpty]){
            textView.text=[NSString stringWithFormat:@"%@\n%@",
                           insertingString,
                           secondHalfString
                           ];
            range.location += [insertingString length];
        }else if(![firstHalfString isEmpty]){
            textView.text=[NSString stringWithFormat:@"%@\n%@",
                           firstHalfString,
                           insertingString
                           ];
            range.location += [insertingString length]+1;
        }else{
            textView.text=[NSString stringWithFormat:@"%@\n",
                           insertingString
                           ];
            range.location += [insertingString length]+2;
        }
        textView.selectedRange = range;
        textView.scrollEnabled = YES;  // turn scrolling back on.
    } else {
        textView.text = [textView.text stringByAppendingString:insertingString];
        [textView becomeFirstResponder];
    }    
}


//delegate，返回caseID
-(NSString *)getCaseIDDelegate{
    return self.caseID;
}

//delegate，设置被询问人名称
-(void)setAnswererDelegate:(NSString *)aText{
    [self loadInquireInfoForCase:self.caseID andAnswererName:aText];
    [self loadCaseInfoArray];
}

//delegate，设置被询问人类型
-(void)setNexusDelegate:(NSString *)aText{
    if (![self.textNexus.text isEqualToString:aText]) {
        self.textNexus.text=aText;
        self.textParty.text=@"";
        [self loadInquireInfoForCase:self.caseID andNexus:aText];
        [self loadCaseInfoArray];
    }
}

//delegate，返回被询问人类型
-(NSString *)getNexusDelegate{
    if (self.textNexus.text==nil) {
        return @"";
    } else {
        return self.textNexus.text;
    }
}

//设置询问时间
-(void)setDate:(NSString *)date{
    self.textInquireDate.text=date;
}

//设置常用答案
-(void)setAnswerSentence:(NSString *)answerSentence{
    self.textAnswer.text=answerSentence;
}

//设置常用问题及问题编号
-(void)setAskSentence:(NSString *)askSentence withAskID:(NSString *)askID{
    self.askID=askID;
    self.textAsk.text=[NSString stringWithFormat:@"%@\n",askSentence];
}

//返回问题编号
-(NSString *)getAskIDDelegate{
    return self.askID;
}


//询问记录改变，保存标识设置为NO
-(void)textViewDidChange:(UITextView *)textView{
    inquireSaved=NO;
} 

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"]) {
        inquireSaved=NO;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == kUITextFieldTagInquireDate ||
        textField.tag == kUITextFieldTagNexus ||
        textField.tag == kUITextFieldTagParty ||
        textField.tag == kUITextFieldTagInquirer ||
        textField.tag == kUITextFieldTagRecorder) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - ListSelectPopoverDelegate

- (void)listSelectPopover:(ListSelectViewController *)popoverContent selectedIndexPath:(NSIndexPath *)indexPath {
    if (popoverContent.tableView.tag == kUITextFieldTagInquirer) {
        [self.textFieldInquirer setText:self.users[indexPath.row]];
    } else if (popoverContent.tableView.tag == kUITextFieldTagRecorder) {
        [self.textFieldRecorder setText:self.users[indexPath.row]];
    }
}

- (void)presentPopoverFromRect:(CGRect)rect dataSource:(NSArray *)dataArray tableViewTag:(NSInteger)tag {
    ListSelectViewController *popoverContent = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPopover"];
    popoverContent.data = dataArray;    
    popoverContent.delegate = self;
    popoverContent.tableView.tag = tag;
    if (self.listSelectPopover == nil) {
        self.listSelectPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    } else {
        [self.listSelectPopover setContentViewController:popoverContent];
    }
    popoverContent.pickerPopover = self.listSelectPopover;
    [self.listSelectPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

@end
