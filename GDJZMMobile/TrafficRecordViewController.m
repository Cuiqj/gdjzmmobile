//
//  TrafficRecordViewController.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-9.
//
//

#import "TrafficRecordViewController.h"
#import "TrafficRecord.h"

typedef enum{
    KNULL = 0,
    KTextCar = 100,
    KTextInfocom,
    KTextFix,
    KTextProperty,
    KTextType,
    KTextHappentime,
    KTextStation,
    KTextRoadsituation,
    KTextZjend,
    KTextZjstart,
    KTextLost,
    KTextIsend,
    KTextPaytype,
    KTextRemark,
    KTextClstart,
    KTextClend,
    KTextWdsituation,
} KUITextFiledTag;

@interface TrafficRecordViewController ()
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@end

@implementation TrafficRecordViewController

@synthesize textCar;
@synthesize textInfocom;
@synthesize textFix;
@synthesize textProperty;
@synthesize textType;
@synthesize textHappentime;
@synthesize textStation;
@synthesize textRoadsituation;
@synthesize textZjend;
@synthesize textZjstart;
@synthesize textLost;
@synthesize textIsend;
@synthesize textPaytype;
@synthesize textRemark;
@synthesize textClstart;
@synthesize textClend;
@synthesize textWdsituation;
@synthesize rel_id;
@synthesize pickerPopover;
@synthesize scrollView;

@synthesize roadVC;

KUITextFiledTag KSelectedField = KNULL;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    //text fields tag
    self.textCar.tag = KTextCar;
    self.textInfocom.tag = KTextInfocom;
    self.textFix.tag = KTextFix;
    self.textProperty.tag = KTextProperty;
    self.textType.tag = KTextType;
    self.textHappentime.tag = KTextHappentime;
    self.textStation.tag = KTextStation;
    self.textRoadsituation.tag = KTextRoadsituation;
    self.textZjend.tag = KTextZjend;
    self.textZjstart.tag = KTextZjstart;
    self.textLost.tag = KTextLost;
    self.textIsend.tag = KTextIsend;
    self.textPaytype.tag = KTextPaytype;
    self.textRemark.tag = KTextRemark;
    self.textClstart.tag = KTextClstart;
    self.textClend.tag = KTextClend;
    self.textWdsituation.tag = KTextWdsituation;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView setContentSize:self.self.scrollView.frame.size];
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    UIResponder *firstResponder = nil;
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isFirstResponder] && [subView isKindOfClass:[UITextField class]]) {
            firstResponder = subView;
        }
    }
    if (firstResponder) {
        CGRect firstResponderFrame = [(UIView *)firstResponder frame];
        CGRect keyboardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGSize viewSize = [self.view bounds].size;
        int realkbH = keyboardFrame.size.height;
        if ((self.interfaceOrientation==UIDeviceOrientationLandscapeRight || self.interfaceOrientation==UIDeviceOrientationLandscapeLeft) && keyboardFrame.size.width < keyboardFrame.size.height) {
            realkbH = keyboardFrame.size.width;
        }
        int realkbY = viewSize.height - realkbH - self.scrollView.frame.origin.y;
        if (firstResponderFrame.size.height+firstResponderFrame.origin.y > realkbY) {
            int offset = firstResponderFrame.size.height+firstResponderFrame.origin.y - realkbY;
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+offset)];
            [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSave:(id)sender{
    if (![self.rel_id isEmpty]) {
        TrafficRecord *tr = [TrafficRecord newDataObjectWithEntityName:@"TrafficRecord"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        tr.rel_id = self.rel_id;
        tr.car = self.textCar.text;
        tr.infocome = self.textInfocom.text;
        tr.fix = self.textFix.text;
        tr.property = self.textProperty.text;
        tr.type = self.textType.text;
        tr.happentime = [dateFormatter dateFromString:self.textHappentime.text];
        tr.station = [NSNumber numberWithInt:[self.textStation.text intValue]];
        tr.roadsituation = self.textRoadsituation.text;
        tr.zjend = [dateFormatter dateFromString:self.textZjend.text];
        tr.zjstart =  [dateFormatter dateFromString:self.textZjstart.text];
        tr.lost = self.textLost.text;
        tr.isend = self.textIsend.text;
        tr.paytype = self.textPaytype.text;
        tr.remark = self.textRemark.text;
        tr.clstart = [dateFormatter dateFromString:self.textClstart.text];
        tr.clend = [dateFormatter dateFromString:self.textClend.text];
        tr.wdsituation = self.textWdsituation.text;
        [[AppDelegate App] saveContext];
        if (![self.rel_id isEmpty] && self.roadVC) {
            [self.roadVC createRecodeByTrafficRecord:tr];
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)btnCancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    switch (textField.tag) {
        case KTextClstart:
        case KTextClend:
        case KTextHappentime:
        case KTextZjstart:
        case KTextZjend:
        
        case KTextInfocom:
        case KTextFix:
        case KTextProperty:
        case KTextType:
        case KTextPaytype:
            if (!self.pickerPopover || ![self.pickerPopover isPopoverVisible]){
                [self textTouch:textField];
            }
            return NO;
            break;
        default:
            break;
    }
    return YES;
}

- (IBAction)textTouch:(UITextField *)sender {
    NSLog(@"textTouch");
    if (sender.tag == KSelectedField) {
        if (self.pickerPopover && [self.pickerPopover isPopoverVisible]) {
            [self.pickerPopover dismissPopoverAnimated:YES];
            KSelectedField = KNULL;
            return;
        }
    }else{
        if (self.pickerPopover && [self.pickerPopover isPopoverVisible]) {
            [self.pickerPopover dismissPopoverAnimated:YES];
        }
    }
    KSelectedField = sender.tag;
    switch (sender.tag) {
        case KTextClstart:
        case KTextClend:
        case KTextHappentime:
        case KTextZjstart:
        case KTextZjend:
            [self showDateSelect:sender];
            break;
        case KTextInfocom:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"交警", @"监控", @"路政", nil]];
            break;
        case KTextFix:
            [self showRoadSideSelect:sender];
            break;
        case KTextProperty:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"简易程序", @"轻微", @"一般", @"重大" , @"特大", nil]];
            break;
        case KTextType:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"碰撞", @"碾压", @"刮擦", @"翻车", @"坠落", @"爆炸", @"着火", nil]];
            break;
        case KTextPaytype:
            [self showListSelect:sender WithData:[NSArray arrayWithObjects:@"直接赔偿", @"保险理赔", nil]];
            break;
        default:
            break;
    }
}

-(void)showRoadSideSelect:(UITextField *)sender{
    RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
    icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
    icPicker.pickerState=kRoadSide;
    icPicker.delegate=self;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
    [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
    CGRect rect = sender.frame;
    [self.pickerPopover presentPopoverFromRect:rect inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    icPicker.pickerPopover=self.pickerPopover;
}

-(void)showListSelect:(UITextField *)sender WithData:(NSArray *)data{
    ListSelectViewController *listPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPopover"];
    listPicker.delegate=self;
    listPicker.data = data;
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:listPicker];
    CGRect rect = sender.frame;
    [self.pickerPopover presentPopoverFromRect:rect inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    listPicker.pickerPopover=self.pickerPopover;
}

-(void)showDateSelect:(UITextField *)sender{
    DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=1;
    [datePicker showdate:sender.text];
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    CGRect rect = sender.frame;
    [self.pickerPopover presentPopoverFromRect:rect inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    datePicker.dateselectPopover=self.pickerPopover;
}

-(void)setDate:(NSString *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *temp=[dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *dateString=[dateFormatter stringFromDate:temp];
    switch (KSelectedField) {
        case KTextClstart:
            self.textClstart.text = dateString;
            break;
        case KTextClend:
            self.textClend.text = dateString;
            break;
        case KTextHappentime:
            self.textHappentime.text = dateString;
            break;
        case KTextZjstart:
            self.textZjstart.text = dateString;
            break;
        case KTextZjend:
            self.textZjend.text = dateString;
            break;
        default:
            break;
    }
}

- (void)setSelectData:(NSString *)data{
    switch (KSelectedField) {
        case KTextInfocom:
            self.textInfocom.text = data;
            break;
        case KTextProperty:
            self.textProperty.text = data;
            break;
        case KTextType:
            self.textType.text = data;
            break;
        case KTextPaytype:
            self.textPaytype.text = data;
            break;
        default:
            break;
    }
}

- (void)setRoadSide:(NSString *)side{
    self.textFix.text = side;
}
@end
