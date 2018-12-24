//
//  CaseViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModelsHeader.h"
#import "AccInfoBriefViewController.h"
#import "CitizenInfoBriefViewController.h"
#import "DeformInfoBriefViewController.h"
#import "DeformationInfoViewController.h"
#import "InquireInfoViewController.h"
#import "InquireInfoBriefViewController.h"
#import "PaintBriefViewController.h"
#import "CasePaintViewController.h"
#import "CasePaintViewController.h"
#import "CaseDocumentsViewController.h"
#import "CaseListViewController.h"
#import "CaseIDHandler.h"
#import "CasePhoto.h"
#import "UserInfo.h"
#import "CaseInfoPickerViewController.h"

#import "CitizenListViewController.h"
#import "CaseDescListViewController.h"
#import "DateSelectController.h"

#import "CaseDocuments.h"
#import "RoadSegmentPickerViewController.h"
#import "RoadInspectViewController.h"
#import "RadioButton.h"
#import "CitizenInfoBriefOfAdministrativePenaltyViewController.h"
#import "InquireInfoBriefOfAdministrativePenaltyViewController.h"
#import "PaintBriefOfAdministrativePenaltyViewController.h"
#import "CitizenAdditionalInfoBriefViewController.h"

@interface AdministrativePenaltyViewController : UIViewController<UITextFieldDelegate,CaseIDHandler,DatetimePickerHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,RoadSegmentPickerDelegate,ReloadPaintDelegate>

//云梧高
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
//案号1
@property (weak, nonatomic) IBOutlet UITextField *textCasemark2;
//案号2
@property (weak, nonatomic) IBOutlet UITextField *textCasemark3;
//时间
@property (weak, nonatomic) IBOutlet UITextField *textHappenDate;
//地点1
@property (weak, nonatomic) IBOutlet UITextField *textRoadSegment;
//地点2
@property (weak, nonatomic) IBOutlet UITextField *textSide;
//地点3
@property (weak, nonatomic) IBOutlet UITextField *textPlace;
//天气
@property (weak, nonatomic) IBOutlet UITextField *textWeatheer;

//桩号
@property (weak, nonatomic) IBOutlet UITextField *textStationStartKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationStartM;
@property (weak, nonatomic) IBOutlet UITextField *textStationEndKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationEndM;

//来源
@property (weak, nonatomic) IBOutlet UITextField *textCaseType;
//违章类型
@property (weak, nonatomic) IBOutlet UITextField *textPeccancyType;
//处罚结果
@property (weak, nonatomic) IBOutlet UITextField *textCaseReason;
//已反馈
@property (weak, nonatomic) IBOutlet UIButton *uiButtonCaseCharacter;
//案由
@property (weak, nonatomic) IBOutlet UITextField *textCaseDesc;
//未立案
@property (weak, nonatomic) IBOutlet RadioButton *radioButtonCaseDisposal;
//已立案并结案
@property (weak, nonatomic) IBOutlet RadioButton *radioButtonCaseDisposal2;
//已结案
@property (weak, nonatomic) IBOutlet RadioButton *radioButtonCaseDisposal3;


//分段控件
@property (weak, nonatomic) IBOutlet UISegmentedControl *segInfoPage;
//内容滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *infoView;
//编辑
@property (weak, nonatomic) IBOutlet UIButton *uiButtonEdit;
//新增案件
@property (weak, nonatomic) IBOutlet UIButton *uiButtonNewCase;
//保存
@property (weak, nonatomic) IBOutlet UIButton *uiButtonSave;

//已生成文书
@property (weak, nonatomic) IBOutlet UITableView *docListView;
//文书模板
@property (weak, nonatomic) IBOutlet UITableView *docTemplatesView;





@property (nonatomic,retain) NSString *caseID;
//这个页面就一个案件，这个caseInfo就是保存这个案件的
@property (nonatomic,retain) CaseInfo *caseInfo;


@property (nonatomic,retain) CitizenInfoBriefOfAdministrativePenaltyViewController *citizenInfoBriefVC;
@property (nonatomic,retain) CitizenAdditionalInfoBriefViewController *citizenAdditionalInfoBriefVC;
@property (nonatomic,retain) InquireInfoBriefOfAdministrativePenaltyViewController *inquireInfoBriefVC;
@property (nonatomic,retain) PaintBriefOfAdministrativePenaltyViewController *paintBriefVC;

@property (nonatomic,assign) BOOL needsMove;

@property (nonatomic, retain) NSString *inspectionID;
@property (nonatomic, assign) RoadInspectViewController *roadInspectVC;


- (IBAction)btnClickToEditor:(id)sender;
- (IBAction)btnNewCase:(id)sender;
- (IBAction)selectWeather:(id)sender;
- (IBAction)selectRoadSegmet:(UITextField *)sender;
- (IBAction)selectRoadSide:(UITextField *)sender;
- (IBAction)selectRoadPlace:(UITextField *)sender;
- (IBAction)selectCaseDesc:(id)sender;
- (IBAction)selectDateAndTime:(id)sender;
- (IBAction)btnSaveCaseInfo:(id)sender;
- (IBAction)btnPreviousCase:(id)sender;
- (IBAction)btnClickFreeback:(UIButton *)sender;
//违章类型 选择框
- (IBAction)selectPeccancyType:(id)sender;
//弹出来源选择框
- (IBAction)selectCaseType:(id)sender;

- (IBAction)changeInfoPage:(UISegmentedControl *)sender;

-(void)saveCaseInfoForCase:(NSString *)caseID;
-(void)loadCaseInfoForCase:(NSString *)caseID;



-(void)saveCaseProveInfoForCase:(NSString *)caseID;
-(void)loadCaseProveInfoForCase:(NSString *)caseID;
-(BOOL)checkCaseBaseInfo;
@end
