//
//  ServiceFileEditorViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-21.
//
//

#import <UIKit/UIKit.h>
#import "CaseServiceFiles.h"


@protocol ServiceFileEditorDelegate;

@interface ServiceFileEditorViewController : UIViewController
- (IBAction)btnDismiss:(UIBarButtonItem *)sender;
- (IBAction)btnComfirm:(UIBarButtonItem *)sender;
- (IBAction)textFieldEditBegin:(UITextField *)sender;


@property (weak, nonatomic) IBOutlet UITextField *textFileName;
@property (weak, nonatomic) IBOutlet UITextField *textRemark;
@property (weak, nonatomic) IBOutlet UITextField *textSendAddress;
@property (weak, nonatomic) IBOutlet UITextField *textSendWay;

@property (nonatomic, retain) CaseServiceFiles *file;
@property (nonatomic, retain) NSString *caseID;
@property (nonatomic, weak) id<ServiceFileEditorDelegate> delegate;
@end

@protocol ServiceFileEditorDelegate <NSObject>

- (void)reloadDataArray;

@end