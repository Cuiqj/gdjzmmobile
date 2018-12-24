//
//  InquireInfoBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InquireInfoViewController.h"
#import "AnswererPickerViewController.h"

@interface InquireInfoBriefOfAdministrativePenaltyViewController : UIViewController<UITextFieldDelegate,setAnswererDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textNexus;
@property (weak, nonatomic) IBOutlet UITextField *textParty;
@property (weak, nonatomic) IBOutlet UITextView *inquireTextView;
@property (nonatomic,copy) NSString *caseID;

-(void)newDataForCase:(NSString *)caseID;
-(IBAction)textTouched:(id)sender;
-(void)loadInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName;
-(void)loadInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName andNexus:(NSString *) nexus;
@end
