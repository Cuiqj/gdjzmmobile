//
//  AutoNumerPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kAutoNumber = 0,
    kNexus,
    kAPNexus,//行政处罚的当事人的类型
    kCarOwner,
    kNation,//民族
    kOrgPrincipalDuty,//职务
    kOriginalHome,//籍贯
    kNationality,//国籍
}CasePickerType;
@protocol AutoNumberPickerDelegate;

@interface AutoNumerPickerViewController : UITableViewController
@property (nonatomic,assign) CasePickerType pickerType;
@property (nonatomic,copy) NSString *caseID;
@property (nonatomic,weak) UIPopoverController *popOver;
@property (nonatomic,weak) id<AutoNumberPickerDelegate> delegate;
@end

@protocol AutoNumberPickerDelegate <NSObject>

-(void)setAutoNumberText:(NSString *)aAuotNumber;

@end