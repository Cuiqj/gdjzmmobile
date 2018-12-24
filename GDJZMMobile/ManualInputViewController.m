//
//  ManualInputViewController.m
//  GDJZMMobile
//
//  Created by luna on 14-1-15.
//
//

#import "ManualInputViewController.h"
#import "DateSelectController.h"
#import "Global.h"
#import "Inspection.h"

@interface ManualInputViewController ()

@property (nonatomic,assign) BOOL isCurrentInspection;

@property (nonatomic, assign) BOOL isStartTime;

@property (nonatomic,retain) NSString * roadSegmentID;

@end

@implementation ManualInputViewController
@synthesize contectView,textStartTime,textEndTime,textInspectrecord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.contectView setDelaysContentTouches:NO];
    self.descState = kAddNewRecord;
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    
    [self setTextStartTime:nil];
    
    [self setTextEndTime:nil];
    
    [self setTextInspectrecord:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.contectView setContentSize:CGSizeMake(self.contectView.frame.size.width,self.contectView.frame.size.height+200)];
    }
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.contectView setContentSize:self.contectView.frame.size];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ManualInputBack:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)ManualInputSave:(id)sender {
    if (self.descState == kAddNewRecord) {
        BOOL isBlank =NO;
        if ([self.textStartTime.text isEmpty]
            || [self.textInspectrecord.text isEmpty]
            ) {
            isBlank=YES;
        }
        if (!isBlank) {
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            
            inspectionRecord.inspection_id=self.inspectionID;
            
            inspectionRecord.relationid = @"0";
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            inspectionRecord.start_time=[dateFormatter dateFromString:self.textStartTime.text];
            
            [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
            
            NSString * timeString =[dateFormatter stringFromDate:inspectionRecord.start_time];
            
            NSString * endTimeStr = nil;
            
            if (self.textEndTime.text.length>0) {
                
                NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
                [dateFormatter1 setLocale:[NSLocale currentLocale]];
                [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate * endTime = [dateFormatter1 dateFromString:self.textEndTime.text];
                
                [dateFormatter1 setDateFormat:DATE_FORMAT_HH_MM_COLON];
                
                endTimeStr = [dateFormatter1 stringFromDate:endTime];
            }

            inspectionRecord.station=@(000+000);
            
            NSString *remark = nil;
            
            if (endTimeStr ==nil||endTimeStr ==NULL) {
                remark = [NSString stringWithFormat:@"%@%@",timeString,self.textInspectrecord.text];
            }else
            {
                remark =[NSString stringWithFormat:@"%@－%@%@",timeString,endTimeStr,self.textInspectrecord.text];
            }
            inspectionRecord.remark = remark;
            
            [[AppDelegate App] saveContext];
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    self.isCurrentInspection = YES;
}

- (IBAction)textTouch:(UITextField *)sender {
    
    if (sender.tag==1001) {
        
        self.isStartTime = YES;
    }else
    {
        self.isStartTime = NO;
    }
    
    //时间选择
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        [datePicker showdate:sender.text];
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        CGRect rect;
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:sender.frame fromView:self.contectView];
        } else {
            
            rect = [self.view convertRect:sender.frame fromView:self.contectView];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }
    
}

- (void)setDate:(NSString *)date{
    if (self.descState == kAddNewRecord) {
        if (self.isStartTime)
        {
            self.textStartTime.text = date;
        }else
        {
            self.textEndTime.text = date;
        }
    } else {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        NSString *dateString=[dateFormatter stringFromDate:temp];
        if (self.isStartTime)
        {
            self.textStartTime.text = dateString;
        }else
        {
            self.textEndTime.text = dateString;
        }
    }
}


@end
