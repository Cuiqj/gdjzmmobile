//
//  InquireInfoBriefOfAdministrativePenaltyViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InquireInfoBriefOfAdministrativePenaltyViewController.h"

@interface InquireInfoBriefOfAdministrativePenaltyViewController (){
    NSInteger nexusOrParty;
}
-(void)pickerPresentForIndex:(NSInteger )iIndex fromRect:(CGRect)rect;
-(void)loadInquireInfoForCase:(NSString *)caseID andNexus:(NSString *)aNexus;
@property (nonatomic,retain) UIPopoverController *pickerPopOver;
@end

@implementation InquireInfoBriefOfAdministrativePenaltyViewController
@synthesize textNexus = _textNexus;
@synthesize textParty = _textParty;
@synthesize inquireTextView = _inquireTextView;
@synthesize caseID=_caseID;
@synthesize pickerPopOver=_pickerPopOver;

- (void)viewDidLoad
{   
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self loadInquireInfoForCase:self.caseID andAnswererName:@""];

}


- (void)viewDidUnload
{
    [self setTextNexus:nil];
    [self setTextParty:nil];
    [self setInquireTextView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

-(void)loadInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName{
    

    self.textNexus.text=@"当事人";
    self.textParty.text=@"";
    self.inquireTextView.text=@"";
    
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
        _inquireTextView.text=caseInquire.inquiry_note;
        _textParty.text=caseInquire.answerer_name;
        _textNexus.text=caseInquire.relation;
    } else {
        self.textParty.text=aAnswererName;
        self.textNexus.text=@"当事人";
        self.inquireTextView.text=@"";
    }
}

-(void)loadInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName andNexus:(NSString *) nexus{
    
    
    self.textNexus.text = nexus;
    self.textParty.text = @"";
    self.inquireTextView.text = @"";
    
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
        _inquireTextView.text=caseInquire.inquiry_note;
        _textParty.text=caseInquire.answerer_name;
        _textNexus.text=caseInquire.relation;
    } else {
        self.textParty.text = aAnswererName;
        self.textNexus.text = nexus;
        self.inquireTextView.text = @"";
    }
}
-(void)loadInquireInfoForCase:(NSString *)caseID andNexus:(NSString *)aNexus{
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
        _textParty.text=caseInquire.answerer_name;
        _textNexus.text=caseInquire.relation;
        _inquireTextView.text=caseInquire.inquiry_note;
    } else {
        _inquireTextView.text = @"";
        self.textNexus.text = aNexus;
    }
}

-(void)newDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    self.textNexus.text=@"";
    self.textParty.text=@"";
    self.inquireTextView.text=@"";
}

-(IBAction)textTouched:(id)sender{
    if ([(UITextField *)sender tag]==1000){
        [self pickerPresentForIndex:0 fromRect:[(UITextField *)sender frame]];
    }else if ([(UITextField *)sender tag]==1001){
        [self pickerPresentForIndex:1 fromRect:[(UITextField *)sender frame]];
    }   
}

-(void)pickerPresentForIndex:(NSInteger )pickerType fromRect:(CGRect)rect{
    if (([_pickerPopOver isPopoverVisible]) && (nexusOrParty==pickerType)) {
        [_pickerPopOver dismissPopoverAnimated:YES];
    } else {
        nexusOrParty=pickerType;
        AnswererPickerViewController *pickerVC=[[AnswererPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        pickerVC.tableView.frame=CGRectMake(0, 0, 140, 176);
        pickerVC.pickerType=pickerType;
        pickerVC.delegate=self;
        _pickerPopOver=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        _pickerPopOver.popoverContentSize=CGSizeMake(140, 176);
        [_pickerPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.pickerPopover=_pickerPopOver;
    }
}

//delegate，返回caseID
-(NSString *)getCaseIDDelegate{
    return self.caseID;
}

//delegate，设置被询问人名称
-(void)setAnswererDelegate:(NSString *)aText{
    self.textParty.text=aText;
    [self loadInquireInfoForCase:_caseID andAnswererName:aText andNexus:self.textNexus.text];
}

//delegate，设置被询问人类型
-(void)setNexusDelegate:(NSString *)aText{
    if (![_textNexus.text isEqualToString:aText]) {
        _textNexus.text=aText;
        _textParty.text=@"";
        [self loadInquireInfoForCase:_caseID andNexus:aText];
    }   
}

//delegate，返回被询问人类型
-(NSString *)getNexusDelegate{
    if (_textNexus.text==nil) {
        return @"";
    } else {
        return _textNexus.text;
    }
}

-(NSInteger)getNexusOrParty{
    return nexusOrParty;
}
@end
