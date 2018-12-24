
//
//  AdministrativePenaltyViewController
//  GDRMMobile
//
//  Created by yu hongwu on 14-11-01.
//  Copyright (c) 2014年 中交宇科. All rights reserved.
//

#import "AdministrativePenaltyViewController.h"
#import "CaseServiceFiles.h"
#import "FileCode.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"


#define WIDTH_OFF_SET 654.0
#define HEIGHT_OFF_SET 0
#define SCROLLVIEW_WIDTH 654.0
#define SCROLLVIEW_HEIGHT 336.0
#define INFO_VIEW_SCROLLVIEW_HEIGHT 450.0

@interface AdministrativePenaltyViewController(){
    NSString *currentFileName;
    //弹窗标识，为0弹出天气选择，为1弹出车型选择，为2弹出损坏程度选择
    NSInteger touchedTag;
    NSDate *proveDate;//由于在创建案件的时候会创建勘验检查笔录，为了保证案件的时间跟勘验检查笔录的开始时间一样
}
- (void)loadCaseDocList:(NSString *)caseID;
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect;
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;


//案由数组
@property (nonatomic,retain) NSArray *caseDescArray;
//已有文书数组
@property (nonatomic,retain) NSArray *docListArray;
@property (nonatomic,retain) NSArray *docTmplArray;


@property (nonatomic,retain) UIPopoverController *caseInfoPickerpopover;
//右上角中的"已立案件"
@property (nonatomic,retain) UIPopoverController *caseListpopover;
//设定文书查看状态，编辑模式或者PDF查看模式
@property (nonatomic,assign) DocPrinterState docPrinterState;

//路段ID
//地点的路段在数据库中保存的是id，但是在界面上显示的文本
@property (nonatomic,copy) NSString *roadSegmentID;

@property (nonatomic,assign) RoadSegmentPickerState roadSegmentPickerState;

@property (nonatomic,assign) NSInteger imageIndex;
@property (nonatomic,retain) UIImageView *leftImageView;
@property (nonatomic,retain) UIImageView *midImageView;
@property (nonatomic,retain) UIImageView *rightImageView;

@end



@implementation AdministrativePenaltyViewController

@synthesize infoView=_infoView;
@synthesize caseID=_caseID;
@synthesize textCasemark2=_textCasemark2;
@synthesize textCasemark3=_textCasemark3;
@synthesize textWeatheer=_textWeatheer;
@synthesize textSide = _textSide;
@synthesize textPlace = _textPlace;
@synthesize textRoadSegment = _textRoadSegment;
@synthesize textStationStartKM = _textStationStartKM;
@synthesize textStationStartM = _textStationStartM;
@synthesize textStationEndKM = _textStationEndKM;
@synthesize textStationEndM = _textStationEndM;
@synthesize textHappenDate = _textHappenDate;
@synthesize textCaseDesc = _textCaseDesc;
@synthesize segInfoPage = _segInfoPage;
@synthesize uiButtonEdit = _uiButtonEdit;
@synthesize uiButtonNewCase = _uiButtonNewCase;
@synthesize uiButtonSave = _uiButtonSave;
@synthesize docListView = _docListView;
@synthesize docTemplatesView = _docTemplatesView;
@synthesize caseInfo=_caseInfo;
@synthesize citizenInfoBriefVC=_citizenInfoBriefVC;
@synthesize inquireInfoBriefVC=_inquireInfoBriefVC;
@synthesize paintBriefVC=_paintBriefVC;
@synthesize needsMove=_needsMove;
@synthesize caseListpopover=_caseListpopover;
@synthesize caseInfoPickerpopover=_caseInfoPickerpopover;
@synthesize caseDescArray=_caseDescArray;
@synthesize docListArray=_docListArray;
@synthesize docTmplArray=_docTmplArray;
@synthesize docPrinterState=_docPrinterState;
@synthesize roadSegmentID = _roadSegmentID;
@synthesize roadSegmentPickerState = _roadSegmentPickerState;
@synthesize inspectionID = _inspectionID;
@synthesize roadInspectVC = _roadInspectVC;

#pragma mark - init
- (NSString *)caseID{
    if (_caseID==nil) {
        _caseID=@"";
    }
    return _caseID;
}

-(NSArray *)caseDescArray{
    if (_caseDescArray==nil) {
        _caseDescArray=[NSArray newAdministrativePenaltyCaseDescArray];
    }
    return _caseDescArray;
}

-(NSArray*)docTmplArray{
    if (_docTmplArray == nil) {
        _docTmplArray = ADMINISTRATIVE_PENALTY_DOC_TEMPLATES_NAME_ARRAY;
    }
    return _docTmplArray;
}



- (UIImageView *)leftImageView{
    if (_leftImageView==nil) {
        _leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)midImageView{
    if (_midImageView==nil) {
        _midImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _midImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _midImageView;
}

- (UIImageView *)rightImageView{
    if (_rightImageView==nil) {
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH * 2, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (void)viewDidLoad{
    [CaseInfo deleteEmptyCaseInfo];//删除无用的案件数据
    
    
    [super viewDidLoad];
    
    
    currentFileName=@"";
    self.caseInfo=nil;
    proveDate=nil;
    touchedTag=-1;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.needsMove=NO;
    
    
    
    //云梧高赔字  payLabel
    FileCode *peiFileCode = [FileCode fileCodeWithPredicateFormat:@"赔补偿案件编号"];
    [self.payLabel setText:[NSString stringWithFormat:@"%@",@"中江高[罚]"]];
    //案号 textCasemark2
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy"];
    self.textCasemark2.text =[dateformat stringFromDate:newDate];
    //案号 textCasemark3
    UILabel *casemarkPaddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    [casemarkPaddingView setText:peiFileCode.lochus_code];
    [self.textCasemark3 setLeftView:casemarkPaddingView];
    [self.textCasemark3 setLeftViewMode:UITextFieldViewModeAlways];
    
    
    
    //分段控件
    UIFont *segFont = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.segInfoPage setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    //默认选中当事人页面
    self.segInfoPage.selectedSegmentIndex=0;
    
    
    //内容滚动视图
    self.infoView.layer.cornerRadius=4;
    self.infoView.layer.masksToBounds=YES;
    
    //界面的背景
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"案件信息-bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    //新增案件按钮uiButtonNewCase
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底按钮" ofType:@"png"];
    UIImage *btnBlueImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonNewCase setBackgroundImage:btnBlueImage forState:UIControlStateNormal];
    
    //编辑按钮
    //小按钮进入图片缓存，否则在旋转之后，显示将不正常
    UIImage *btnWhiteImage=[[UIImage imageNamed:@"小按钮.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonEdit setBackgroundImage:btnWhiteImage forState:UIControlStateNormal];
    [self.uiButtonEdit setAlpha:0.0];
    [self.uiButtonEdit setHidden:YES];
    //保存按钮
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底主按钮" ofType:@"png"];
    UIImage *btnYelloImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonSave setBackgroundImage:btnYelloImage forState:UIControlStateNormal];
    
    
    
    //当事人信息页面初始化
    self.citizenInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CitizenBriefInfoOfAdministrativePenalty"];
    self.citizenInfoBriefVC.delegate=self;
    self.citizenInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, 500.0);
    [self.infoView addSubview:self.citizenInfoBriefVC.view];
    self.infoView.contentMode=UIViewContentModeLeft;
    self.infoView.bounces=NO;
    self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, INFO_VIEW_SCROLLVIEW_HEIGHT);
    self.infoView.contentInset=UIEdgeInsetsZero;
    
    //当事人附加信息页面初始化
    self.citizenAdditionalInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CitizenAdditionalInfoBriefViewController"];
    self.citizenAdditionalInfoBriefVC.delegate = self;
    self.citizenAdditionalInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    
    //勘验草图显示页面初始化
    self.paintBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PaintBriefOfAdministrativePenalty"];
    self.paintBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    
    //询问笔录页面初始化
    self.inquireInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"InquireInfoBriefOfAdministrativePenalty"];
    self.inquireInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:NO];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [[self.infoView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setInfoView:nil];
    [self setCaseID:nil];
    [self setTextCasemark2:nil];
    [self setTextCasemark3:nil];
    [self setTextWeatheer:nil];
    [self setTextSide:nil];
    [self setTextPlace:nil];
    [self setTextRoadSegment:nil];
    [self setTextStationStartKM:nil];
    [self setTextStationStartM:nil];
    [self setTextStationEndKM:nil];
    [self setTextStationEndM:nil];
    [self setTextHappenDate:nil];
    [self setTextCaseDesc:nil];
    [self setSegInfoPage:nil];
    [self setUiButtonEdit:nil];
    [self setUiButtonNewCase:nil];
    [self setUiButtonSave:nil];
    [self setCaseInfo:nil];
    [self setCitizenInfoBriefVC:nil];
    [self setCitizenAdditionalInfoBriefVC:nil];
    [self setInquireInfoBriefVC:nil];
    [self setPaintBriefVC:nil];
    [self setRoadSegmentID:nil];
    [self setCaseListpopover:nil];
    [self setCaseInfoPickerpopover:nil];
    [self setCaseDescArray:nil];
    [self setDocListArray:nil];
    [self setDocListView:nil];
    [self setDocTemplatesView:nil];
    [self setPayLabel:nil];
	[self setUiButtonCaseCharacter:nil];
	[self setRadioButtonCaseDisposal2:nil];
	[self setRadioButtonCaseDisposal:nil];
	[self setRadioButtonCaseDisposal3:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)setCaseIDdelegate2:(NSString *)caseID{
    [self loadCaseInfoForCase:caseID];
    if (self.segInfoPage.selectedSegmentIndex!=0) {
        for (UIView *view in self.infoView.subviews) {
            [view removeFromSuperview];
        }
        self.infoView.pagingEnabled=NO;
        self.infoView.delegate=nil;
        self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        [self.infoView setContentOffset:CGPointZero animated:NO];
        [UIView transitionWithView:self.infoView duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.uiButtonEdit setAlpha:0.0];
                            [self.infoView addSubview:self.citizenInfoBriefVC.view];
                        }
                        completion:^(BOOL finished){
                            [self.uiButtonEdit setHidden:YES];
                        }];
        [self.segInfoPage setSelectedSegmentIndex:0];
    }
}

#pragma mark - textField Delegate
//使日期选择框不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==3) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - TableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number=0;
    if (tableView.tag==1000) {
        number=self.docListArray.count;
    } else if (tableView.tag==1001) {
        number=self.docTmplArray.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag==1001) {
        static NSString *CellIdentifier = @"DocTemplatesCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text=self.docTmplArray[indexPath.row];
    } else if (tableView.tag==1000) {
        static NSString *CellIdentifier = @"DocListCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text=[self.docListArray objectAtIndex:indexPath.row];
    }
    return cell;
}

//点击进入文书编辑和打印页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1001) {
        self.docPrinterState=1;
    } else if (tableView.tag==1000) {
        self.docPrinterState=kPDFView;
    }
    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
    currentFileName = myCell.textLabel.text;
    if (![self.caseID isEmpty]) {
        [self saveCaseInfoForCase:self.caseID];
    }
    CaseDocumentsViewController *documentsVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"caseDocumentsViewController"];;
    documentsVC.fileName = currentFileName;
    documentsVC.caseID = self.caseID;
    documentsVC.docPrinterState = self.docPrinterState;
    documentsVC.docReloadDelegate = self;
    [[self navigationController] pushViewController:documentsVC animated: YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - IBActions

//各信息页面切换
- (IBAction)changeInfoPage:(UISegmentedControl *)sender {
    for(UIView *subview in [self.infoView subviews]) {
        [subview removeFromSuperview];
    }
    
    self.infoView.pagingEnabled=NO;
    self.infoView.delegate=nil;
    if (sender.selectedSegmentIndex==0) {
        self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, INFO_VIEW_SCROLLVIEW_HEIGHT);
    } else {
        self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    }
    [self.infoView setContentOffset:CGPointZero animated:NO];
    
    switch (sender.selectedSegmentIndex) {
            //当事人信息
        case 0:{
            if ( [self.caseID isEmpty]) {//当案件页面没有caseID的时候，
                [self.citizenInfoBriefVC newDataForCase:self.caseID];
            } else {
                [self.citizenInfoBriefVC loadCitizenInfoForCase:self.caseID andNexus:@"当事人"];
            }
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.infoView addSubview:self.citizenInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                            }];
        }
            break;
            //询问笔录
        case 1:{
            self.inquireInfoBriefVC.caseID=self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.infoView addSubview:self.inquireInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                            }];
        }
            break;
            //现场勘验图
        case 2:{
            self.paintBriefVC.caseID = self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.infoView addSubview:self.paintBriefVC.view];
                            }
                            completion:^(BOOL finished){
                            }];
        }
            break;
        default:
            break;
    }
}


//显示各信息详细编辑页面按钮
- (IBAction)btnClickToEditor:(id)sender {
    [[AppDelegate App]saveContext];
    switch ([self.segInfoPage selectedSegmentIndex]) {
        case 1:{
            InquireInfoViewController *iiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InquireInfoOfAdministrativePenaltyViewController"];
            iiVC.caseID=self.caseID;
            iiVC.delegate=self;
            iiVC.answererName=self.inquireInfoBriefVC.textParty.text;
            [self presentViewController:iiVC animated:YES completion:nil];
        }
            break;
        case 2:{
            CasePaintViewController *cpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"casePaintViewController"];
            cpVC.delegate = self;
            cpVC.caseID=self.caseID;
            [[self navigationController] pushViewController:cpVC animated: YES];
        }
            break;
        default:
            break;
    }
}

//新增案件按钮
- (IBAction)btnNewCase:(id)sender;{
    self.caseInfo=nil;
    self.caseDescArray = nil;
    self.roadSegmentID = @"";
    self.caseID = @"";
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    
    proveDate=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString=[dateFormatter stringFromDate:proveDate];
    NSString *yearString=[dateString substringToIndex:4];
    self.textCasemark2.text=yearString;
    self.textHappenDate.text=dateString;
    
    NSInteger caseMark3InCoreData = [CaseInfo maxCaseMark3ForAdministrativePenalty];
    NSInteger caseMark3InDefaults=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark3ForAdministrativePenalty"].integerValue;
    NSString *caseMark3 = [[NSString alloc] initWithFormat:@"%d",MAX(caseMark3InDefaults, caseMark3InCoreData)+1];
    NSString *oldCaseMark2=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark2ForAdministrativePenalty"];
    if (yearString.integerValue>oldCaseMark2.integerValue) {
        caseMark3=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2ForAdministrativePenalty"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2ForAdministrativePenalty"];
    [[NSUserDefaults standardUserDefaults] setObject:caseMark3 forKey:@"CaseMark3ForAdministrativePenalty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.textCasemark3.text=caseMark3;
    
    
    self.textCaseReason.text = @"已移交综合执法局";
    
    [self.citizenInfoBriefVC newDataForCase:nil];
    [self.inquireInfoBriefVC newDataForCase:nil];
    [self.paintBriefVC.Image setImage:nil];
    
    [self.segInfoPage setSelectedSegmentIndex:0];
    [self changeInfoPage:self.segInfoPage];
    
    _docListArray = [NSArray array];
    [_docListView beginUpdates];
    [_docListView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [_docListView insertSections:[NSIndexSet indexSetWithIndex:0]  withRowAnimation:UITableViewRowAnimationFade];
    [_docListView endUpdates];
}

//弹出以往案件选择框
- (IBAction)btnPreviousCase:(id)sender {
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:YES];
    } else {
        CaseListViewController *caseListVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseListView"];
        caseListVC.caseType = CaseTypeIDFa;
        self.caseListpopover=[[UIPopoverController alloc] initWithContentViewController:caseListVC];
        caseListVC.delegate=self;
        caseListVC.myPopover=self.caseListpopover;
        [self.caseListpopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

//保存案件信息按钮
- (IBAction)btnSaveCaseInfo:(id)sender {
    //检查必填的字段是否没有填写
    if([self checkCaseBaseInfo] == NO){
        return;
    }
    
    if (![self.textCasemark2.text isEmpty] && ![self.textCasemark3.text isEmpty]) {
        if (self.caseID == nil || [self.caseID isEmpty]) {
            self.caseInfo=[CaseInfo newDataObjectWithEntityName:@"CaseInfo"];
            self.caseID = self.caseInfo.myid;
        }
        [self saveCaseInfoForCase:self.caseID];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCaseID" object:self userInfo:[NSDictionary dictionaryWithObject:self.caseID forKey:@"caseID"]];
    }
}



#pragma mark - CaseID Handler Delegate
//新打印文档后，重新载入文书列表
- (void)reloadDocuments{
    [self loadCaseDocList:self.caseID];
}

- (void)loadInquireForAnswerer:(NSString *)answererName{
    [self.inquireInfoBriefVC loadInquireInfoForCase:self.caseID andAnswererName:answererName];
}









//为其他ViewController返回当前caseID
- (NSString *)getCaseIDdelegate{
    return self.caseID;
}

//返回当前选定的案由
- (NSArray *)getCaseDescArrayDelegate{
    return self.caseDescArray;
}




//根据caseID删除以往案件
- (void)deleteCaseAllDataForCase:(NSString *)caseID{
    if ([self.caseID isEqualToString:caseID]) {
        self.caseID=@"";
        self.roadSegmentID=@"";
        for (UITextField *text in [self.view subviews]) {
            if ([text isKindOfClass:[UITextField class]]) {
                text.text=@"";
            }
        }
        [self.citizenInfoBriefVC newDataForCase:@""];
        self.caseInfo=nil;
        self.caseDescArray=nil;
    }
    [self deleteDataForEntityName:@"CaseProveInfo" andCaseID:caseID];
    [self deleteDataForEntityName:@"Citizen" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseDeformation" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseInquire" andCaseID:caseID];
    [CaseInfo deleteCaseInfoForID:caseID];
    [self deleteDataForEntityName:@"ParkingNode" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseDocuments" andCaseID:caseID];
    [self deleteDataForEntityName:@"CasePhoto" andCaseID:caseID];
}

//根据案号删除对应表数据
- (void)deleteDataForEntityName:(NSString *)aEntiyName andCaseID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:aEntiyName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;
    if ([aEntiyName isEqualToString:@"Citizen"] || [aEntiyName isEqualToString:@"CaseDeformation"] || [aEntiyName isEqualToString:@"CaseInquire"]) {
        predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@",caseID];
    } else {
        predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    }
    [fetchRequest setPredicate:predicate];
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        for (NSManagedObject *tableInfo in fetchResult) {
            [context deleteObject:tableInfo];
        }
    }
    [[AppDelegate App] saveContext];
}



#pragma mark - ReloadPaintDelegate
- (void)reloadPaint{
    if (self.segInfoPage.selectedSegmentIndex == 3) {
        [self.paintBriefVC loadCasePaint];
    }
}

#pragma mark - keyboard show&hide events
//左下输入框delegate，设定scrollview需要上移
- (void)scrollViewNeedsMove{
    self.needsMove=YES;
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.needsMove) {
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,302,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        if (self.segInfoPage.selectedSegmentIndex==0) {
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, INFO_VIEW_SCROLLVIEW_HEIGHT);
        } else {
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.needsMove) {
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,18,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        CGSize tempSize;
        if (self.segInfoPage.selectedSegmentIndex==0) {
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, INFO_VIEW_SCROLLVIEW_HEIGHT);
        } else {
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        tempSize=CGSizeMake(tempSize.width, keyboardEndFrame.size.width - (704 - 18 - self.infoView.frame.size.height) + tempSize.height);
        self.infoView.contentSize=tempSize;
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//左上普通文本框点击时，scrollview不移动
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.needsMove=NO;
}


#pragma mark - methods save&load
//根据caseID载入相应案件数据
- (void)loadCaseInfoForCase:(NSString *)caseID{
    self.caseInfo=nil;
    self.caseID=caseID;
    self.caseInfo = [CaseInfo caseInfoForID:caseID];
    if (self.caseInfo) {
        self.textCasemark2.text=self.caseInfo.case_mark2;
        self.textCasemark3.text=self.caseInfo.case_mark3;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textHappenDate.text=[formatter stringFromDate:self.caseInfo.happen_date];
        self.textRoadSegment.text=[RoadSegment roadNameFromSegment:self.caseInfo.roadsegment_id];
        self.roadSegmentID=self.caseInfo.roadsegment_id;
        self.textPlace.text=self.caseInfo.place;
        self.textSide.text=self.caseInfo.side;
        self.textWeatheer.text=self.caseInfo.weater;
        
        
        self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
        self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
        self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
        self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];
        
        self.textCaseType.text = self.caseInfo.case_type;
        self.textPeccancyType.text = self.caseInfo.peccancy_type;
        self.textCaseReason.text = self.caseInfo.case_reason;
        if (self.caseInfo.case_character.intValue == 1) {
            self.uiButtonCaseCharacter.selected = YES;
        }else{
            self.uiButtonCaseCharacter.selected = NO;
        }
        switch (self.caseInfo.case_disposal.intValue) {
            case 6:{
                self.radioButtonCaseDisposal.selected = YES;
                self.radioButtonCaseDisposal2.selected = NO;
                self.radioButtonCaseDisposal3.selected = NO;
            }
                break;
            case 7:{
                self.radioButtonCaseDisposal.selected = NO;
                self.radioButtonCaseDisposal2.selected = YES;
                self.radioButtonCaseDisposal3.selected = NO;
            }
                break;
            case 8:{
                self.radioButtonCaseDisposal.selected = NO;
                self.radioButtonCaseDisposal2.selected = NO;
                self.radioButtonCaseDisposal3.selected = YES;
            }
                break;
            default:
                break;
        }
    }
    
    [self loadCaseProveInfoForCase:caseID];
    [self loadCaseDocList:caseID];
    [self.citizenInfoBriefVC loadCitizenInfoForCase:caseID andNexus:@"当事人"];
}

//将当前页面显示数据保存至该caseID下
- (void)saveCaseInfoForCase:(NSString *)caseID{
    self.caseInfo.myid=caseID;
    self.caseInfo.case_mark2=self.textCasemark2.text;
    self.caseInfo.case_mark3=self.textCasemark3.text;
    self.caseInfo.case_type_id = CaseTypeIDFa;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (![self.textHappenDate.text isEmpty]) {
        self.caseInfo.happen_date=[formatter dateFromString:self.textHappenDate.text];
    }else{
        self.caseInfo.happen_date = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
        self.textHappenDate.text=[formatter stringFromDate:self.caseInfo.happen_date];
    }
    
    self.caseInfo.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
    self.caseInfo.place=self.textPlace.text;
    
    self.caseInfo.side=self.textSide.text;
    
    self.caseInfo.weater=self.textWeatheer.text;
    
    self.caseInfo.station_start=[NSNumber numberWithInteger:(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue)];
    self.caseInfo.station_end=[NSNumber numberWithInteger:(self.textStationEndKM.text.integerValue*1000+self.textStationEndM.text.integerValue)];
    if (self.caseInfo.station_end.integerValue == 0) {
        self.caseInfo.station_end = [self.caseInfo.station_start copy];
    }
    self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
    self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
    self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
    self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];
    
    
    self.caseInfo.case_type = self.textCaseType.text;
    self.caseInfo.peccancy_type = self.textPeccancyType.text;
    self.caseInfo.case_reason = self.textCaseReason.text;
    
    if (self.uiButtonCaseCharacter.selected == YES) {
        self.caseInfo.case_character = [NSNumber numberWithInt:1];
    }else{
        self.caseInfo.case_character = [NSNumber numberWithInt:0];
    }
    
    if (self.radioButtonCaseDisposal.selected == YES) {
        self.caseInfo.case_disposal = [NSNumber numberWithInt:6];
    }else if (self.radioButtonCaseDisposal2.selected == YES) {
        self.caseInfo.case_disposal = [NSNumber numberWithInt:7];
    }else if (self.radioButtonCaseDisposal3.selected == YES) {
        self.caseInfo.case_disposal = [NSNumber numberWithInt:8];
    }
    
    [[AppDelegate App] saveContext];
    
    //案由是保存在勘验检查笔录中的
    [self saveCaseProveInfoForCase:caseID];
    
    switch (self.segInfoPage.selectedSegmentIndex) {
        case 0:
            [self.citizenInfoBriefVC saveCitizenInfoForCase:caseID];
            break;
        default:
            break;
    }
}



- (void)saveCaseProveInfoForCase:(NSString *)caseID{
    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    if (!caseProveInfo) {
        caseProveInfo = [CaseProveInfo newDataObjectWithEntityName:@"CaseProveInfo"];
        caseProveInfo.caseinfo_id = caseID;
        if (proveDate == nil) {
            proveDate = [NSDate date];
        }
        caseProveInfo.start_date_time = proveDate;
    }
    
    NSString *caseDescID = @"";
    for (CaseDescString *temp in self.caseDescArray) {
        if (temp.isSelected) {
            if ([caseDescID isEmpty]) {
                caseDescID=[caseDescID stringByAppendingString:temp.caseDescID];
            } else {
                caseDescID=[caseDescID stringByAppendingFormat:@"#%@",temp.caseDescID];
            }
        }
    }
    caseProveInfo.case_desc_id = caseDescID;
    
    
    caseProveInfo.case_short_desc = self.textCaseDesc.text;
    
    //在案件编辑页面传入参数
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    caseProveInfo.start_date_time=[formatter dateFromString:self.textHappenDate.text];
    if (caseProveInfo.end_date_time == nil) {
        caseProveInfo.end_date_time=[formatter dateFromString:self.textHappenDate.text];
    }
    
    caseProveInfo.remark = [NSString stringWithFormat:@"%@%@%@",self.textRoadSegment.text,self.textSide.text,self.textPlace.text];
    
    
    //根据不同的nexus来获取名字、单位和职务
    Citizen *citizen1=[Citizen citizenByCaseID:caseID];
    caseProveInfo.citizen_name = citizen1.party;
    
    
    Citizen *citizen2=[Citizen citizenByCaseID:caseID andNexus:@"组织代表"];
    if (citizen2) {
        caseProveInfo.organizer = citizen2.party;
        caseProveInfo.organizer_org_duty = [NSString stringWithFormat:@"%@%@",[citizen2.org_name length]==0?@"":citizen2.org_name, [citizen2.org_principal_duty length]==0?@"":citizen2.org_principal_duty];
    }
    
    Citizen *citizen3=[Citizen citizenByCaseID:caseID andNexus:@"被邀请人"];
    if(citizen3){
        caseProveInfo.invitee = citizen3.party;
        caseProveInfo.invitee_org_duty = [NSString stringWithFormat:@"%@%@",[citizen3.org_name length]==0?@"":citizen3.org_name, [citizen3.org_principal_duty length]==0?@"":citizen3.org_principal_duty];
    }
    
    [[AppDelegate App] saveContext];
}


//根据caseID载入勘验信息
- (void)loadCaseProveInfoForCase:(NSString *)caseID{
    CaseProveInfo *info = [CaseProveInfo proveInfoForCase:caseID];
    if (info) {
        self.textCaseDesc.text = info.case_short_desc;
        for (CaseDescString *caseDescString in self.caseDescArray) {
            caseDescString.isSelected = NO;
        }
        NSString *temp = info.case_desc_id;
        if (![temp isEmpty]) {
            NSArray *descIDArray=[temp componentsSeparatedByString:@"#"];
            for (NSString *descID in descIDArray) {
                for (CaseDescString *caseDesc in self.caseDescArray) {
                    if ([descID isEqualToString:caseDesc.caseDescID]) {
                        caseDesc.isSelected=YES;
                    }
                }
            }
        }
    }
}




//载入案件已生成文书信息
- (void)loadCaseDocList:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",self.caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    self.docListArray=[temp valueForKeyPath:@"@distinctUnionOfObjects.document_name"];
    [self.docListView reloadData];
}


-(BOOL)canBecomeFirstResponder{
    return YES;
}


#pragma mark - 检验信息的完整性
//检查案件基本信息是否为空
-(BOOL)checkCaseBaseInfo{
    NSString *message = nil;
    //检查案号
    if([_textCasemark2.text isEmpty] || [_textCasemark3.text isEmpty]){
        message = @"请填写完整案号信息";
    }else if([_textHappenDate.text isEmpty]){
		message = @"请选择时间";
    }else if([_textRoadSegment.text isEmpty] ){
		message = @"请选择高速公路";
	}else if([_textCaseDesc.text isEmpty]){
		message = @"请选择案由";
	}
    
    if(message != nil){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return NO;
    }
    return  YES;
}


#pragma mark - 弹出选择框
//选择路段级路段号
- (IBAction)selectRoadSegmet:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:sender.frame];
}

//选择方向
- (IBAction)selectRoadSide:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:sender.frame];
}

//选择位置
- (IBAction)selectRoadPlace:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:sender.frame];
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState=state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(150, 243)];
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.caseInfoPickerpopover;
    }
}


//弹出天气选择框
- (IBAction)selectWeather:(id)sender {
    [self pickerPresentForIndex:0 fromRect:[(UITextField*)sender frame]];
}


//弹出来源选择框
- (IBAction)selectCaseType:(id)sender {
    [self pickerPresentForIndex:4 fromRect:[(UITextField*)sender frame]];
}
//弹出违章类型选择框
- (IBAction)selectPeccancyType:(id)sender {
    [self pickerPresentForIndex:3 fromRect:[(UITextField*)sender frame]];
}

//弹窗
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect{
    if ((iIndex==touchedTag) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        touchedTag=iIndex;
        CaseInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseInfoPicker"];
        acPicker.pickerType=iIndex;
        acPicker.delegate=self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        switch (iIndex) {
            case 0:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(140, 264)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 140, 264)];
            }
                break;
            case 3:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(250,308)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 250, 308)];
            }
                break;
            case 4:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(100, 176)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 100, 176)];
            }
                break;
            default:
                break;
        }
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.caseInfoPickerpopover;
    }
}



//弹出案由选择
- (IBAction)selectCaseDesc:(id)sender {
    [self caseDescPicker:[(UITextField*)sender frame]];
}
- (void)caseDescPicker:(CGRect)rect{
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        CaseDescListViewController *cdlVC = [self.storyboard instantiateViewControllerWithIdentifier:@"caseDescListPicker"];;
        cdlVC.delegate = self;
        cdlVC.caseID = self.caseID;
        self.caseInfoPickerpopover = [[UIPopoverController alloc] initWithContentViewController:cdlVC];
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        cdlVC.popOver = self.caseInfoPickerpopover;
    }
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender {
    [self dateTimePicker:[(UITextField*)sender frame]];
}
- (void)dateTimePicker:(CGRect)rect{
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *dsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        dsVC.delegate = self;
        dsVC.pickerType = 1;
        dsVC.datePicker.maximumDate = [NSDate date];
        [dsVC showdate:self.textHappenDate.text];
        self.caseInfoPickerpopover = [[UIPopoverController alloc] initWithContentViewController:dsVC];
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        dsVC.dateselectPopover = self.caseInfoPickerpopover;
    }
}

#pragma mark - 弹出选择框的回调函数

//显示所选天气
- (void)setWeather:(NSString *)textWeather{
    self.textWeatheer.text=textWeather;
}

//RoadPickerDelegate
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    self.roadSegmentID=aRoadSegmentID;
    self.textRoadSegment.text=roadName;
}

- (void)setRoadPlace:(NSString *)place{
    self.textPlace.text=place;
}

- (void)setRoadSide:(NSString *)side{
    self.textSide.text=side;
}

//显示所选时间
- (void)setDate:(NSString *)date{
    self.textHappenDate.text=date;
}

//显示来源
- (void)setCaseType:(NSString *)caseType{
    self.textCaseType.text = caseType;
}


//显示违章类型
- (void)setPeccancyType:(NSString *)peccancyType{
    self.textPeccancyType.text = peccancyType;
}
//设定案由
- (void)setCaseDescArrayDelegate:(NSArray *)aCaseDescArray{
    self.caseDescArray = aCaseDescArray;
    NSString *caseFullDesc = @"";
    for (CaseDescString *temp in aCaseDescArray) {
        if (temp.isSelected) {
            if ([caseFullDesc isEmpty]) {
                caseFullDesc = [caseFullDesc stringByAppendingString:temp.caseDesc];
            } else {
                caseFullDesc = [caseFullDesc stringByAppendingFormat:@"，%@",temp.caseDesc];
            }
        }
    }
    self.textCaseDesc.text=caseFullDesc;
}

//右上角的『已立案件』点击之后会弹出一个弹出框，点中任意一行都会调用下面这个回调函数
//已立案件delegate，以设定所选案件的caseID，并载入相关数据，并切换到事故信息页面
- (void)setCaseIDdelegate:(NSString *)caseID{
    if (![self.caseID isEmpty]) {
        [self btnSaveCaseInfo:nil];
    }
    
    [self loadCaseInfoForCase:caseID];
    if (self.segInfoPage.selectedSegmentIndex!=0) {
        for (UIView *view in self.infoView.subviews) {
            [view removeFromSuperview];
        }
        self.infoView.pagingEnabled=NO;
        self.infoView.delegate=nil;
        self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        [self.infoView setContentOffset:CGPointZero animated:NO];
        [UIView transitionWithView:self.infoView duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.uiButtonEdit setAlpha:0.0];
                            [self.infoView addSubview:self.citizenInfoBriefVC.view];
                        }
                        completion:^(BOOL finished){
                            [self.uiButtonEdit setHidden:YES];
                        }];
        [self.segInfoPage setSelectedSegmentIndex:0];
    }
}



#pragma mark - 已反馈单选按钮     选中之后显示选中状态，再次单击则取消选中状态
- (IBAction)btnClickFreeback:(UIButton *)sender{
	if (self.uiButtonCaseCharacter.selected == YES) {
		self.uiButtonCaseCharacter.selected = NO;
	}else{
		self.uiButtonCaseCharacter.selected = YES;
	}
}
@end
