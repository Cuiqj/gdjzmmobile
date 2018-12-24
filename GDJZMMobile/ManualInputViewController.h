//
//  ManualInputViewController.h
//  GDJZMMobile
//
//  Created by luna on 14-1-15.
//
//

#import <UIKit/UIKit.h>
#import "DateSelectController.h"
#import "InspectionCheckPickerViewController.h"
#import "RoadSegmentPickerViewController.h"
#import "InspectionHandler.h"
#import "InspectionRecord.h"
#import "RoadInspectViewController.h"


//typedef enum {
//    kAddNewRecord = 0,
//    kNormalDesc
//}DescState;

@interface ManualInputViewController : UIViewController<DatetimePickerHandler,UITextFieldDelegate,InspectionPickerDelegate,RoadSegmentPickerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contectView;
@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UITextView *textInspectrecord;

@property (nonatomic,copy) NSString *inspectionID;

@property (nonatomic,retain) UIPopoverController *pickerPopover;

@property (assign, nonatomic) DescState descState;

@property (weak, nonatomic) id<InspectionHandler> delegate;

- (IBAction)ManualInputBack:(id)sender;

- (IBAction)ManualInputSave:(id)sender;

- (IBAction)textTouch:(UITextField *)sender;


@end
