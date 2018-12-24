//
//  CaseInquirePrinterViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-9.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CaseInquirePrinterViewController.h"
#import "UserInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"
#import "TBXML+TBXML_TraverseAddition.h"
#import "TBXML.h"
static NSString * const xmlName = @"InquireTable";
static NSString * const secondPageXmlName = @"InquireTable2_new"; //该文件改用来作为第二页 |  | 2013.7.30

enum kPageInfo {
    kPageInfoFirstPage = 0,
    kPageInfoSucessivePage
};

@interface CaseInquirePrinterViewController (){
    BOOL isPei;// 是否是赔补偿案件
}
@property (nonatomic, retain) CaseInquire *caseInquire;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@end

@implementation CaseInquirePrinterViewController
@synthesize caseID=_caseID;
@synthesize textFieldTag = _textFieldTag;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        isPei = [[CaseInfo caseInfoForID:self.caseID].case_type_id isEqualToString:CaseTypeIDPei];
        self.caseInquire = [CaseInquire inquireForCase:self.caseID];
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)pageSaveInfo{
    Citizen *citizen = [Citizen citizenForCitizenName:self.caseInquire.answerer_name nexus:self.caseInquire.relation caseId:self.caseID];
    citizen.tel_number = self.textphone.text;
    citizen.age = [NSNumber numberWithInt: [self.textage.text intValue]];
    citizen.address = self.textaddress.text;
    
    self.caseInquire.locality = self.textlocality.text;
    self.caseInquire.phone = self.textphone.text;
    self.caseInquire.address = self.textaddress.text;
    
    citizen.postalcode = self.textpostalcode.text;
    self.caseInquire.postalcode = self.textpostalcode.text;
    self.caseInquire.inquiry_note = self.textinquiry_note.text;
    
    self.caseInquire.company_duty = NSStringNilIsBad(self.textcompany_duty.text);
    self.caseInquire.inquirer_name = self.textinquirer_name.text;
    self.caseInquire.recorder_name = self.textrecorder_name.text;
    self.caseInquire.relation = NSStringNilIsBad(self.textrelation.text);
    
    
    
    [[AppDelegate App] saveContext];
}


- (void)pageLoadInfo{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    self.textdate_inquired.text =[dateFormatter stringFromDate:self.caseInquire.date_inquired];
    self.textlocality.text = self.caseInquire.locality;
    self.textinquirer_name.text = self.caseInquire.inquirer_name;
    self.textrecorder_name.text = self.caseInquire.recorder_name;
    self.textanswerer_name.text = self.caseInquire.answerer_name;
    self.textsex.text = self.caseInquire.sex;
    self.textage.text = (self.caseInquire.age.integerValue==0)?@"":[NSString stringWithFormat:@"%d",self.caseInquire.age.integerValue];
    self.textrelation.text = self.caseInquire.relation;
    
    Citizen *citizen = [Citizen citizenForCitizenName:self.caseInquire.answerer_name nexus:self.caseInquire.relation case:self.caseID];
    if ([self.caseInquire.company_duty isEmpty] || !self.caseInquire.company_duty) {
        self.caseInquire.company_duty = [NSString stringWithFormat:@"%@%@", citizen.org_name, citizen.profession];
    }
    self.textcompany_duty.text = self.caseInquire.company_duty;
    if ([self.caseInquire.phone isEmpty]) {
        self.caseInquire.phone = citizen.tel_number;
    }
    self.textphone.text = self.caseInquire.phone;
    if ([self.caseInquire.address isEmpty]) {
        self.caseInquire.address = citizen.address;
    }
    self.textaddress.text = self.caseInquire.address;
    if ([self.caseInquire.postalcode isEmpty]) {
        self.caseInquire.postalcode = citizen.postalcode;
    }
    self.textpostalcode.text = [NSStringNilIsBad(self.caseInquire.postalcode) emptyFor:@"无"];
    self.textinquiry_note.text = self.caseInquire.inquiry_note;
    [[AppDelegate App] saveContext];
}

//add by nx 2013.11.28
#pragma mark - CasePrintProtocol
- (NSString *)templateNameKey
{
    return isPei?DocNameKeyPei_AnJianXunWenBiLu:DocNameKeyFa_XunWenBiLu;
}


- (id)dataForPDFTemplate
{
    id caseData = @{};
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        caseData = @{
                     @"mark2": caseInfo.case_mark2,
                     @"mark3": caseInfo.full_case_mark3,
                     @"weather": caseInfo.weater,
                     };
    }
    NSDate *date;
    NSString *dateString = @"";
    NSString *address = @"";
    NSString *inquirerName = @"";
    NSString *recorderName = @"";
    NSString *answererName = @"";
    NSString *answererSex = @"";
    NSString *answererAge = @"";
    NSString *answererRelation = @"";
    NSString *answererOrgDuty = @"";
    NSString *answererPhoneNum = @"";
    NSString *answererAddress = @"";
    NSString *answererPostalCode = @"";
    NSString *inquireNote = @"";
    NSString *pagesCount = @"";
    NSString *pageNum = @"";
    NSMutableArray *inquireNotePages = [NSMutableArray arrayWithCapacity:1];
    
    self.caseInquire = [CaseInquire inquireForCase:self.caseID];
    if (self.caseInquire) {
        date = self.caseInquire.date_inquired;
        address = NSStringNilIsBad(self.caseInquire.locality);
        inquirerName = NSStringNilIsBad(self.caseInquire.inquirer_name);
        recorderName = NSStringNilIsBad(self.caseInquire.recorder_name);
        answererName = NSStringNilIsBad(self.caseInquire.answerer_name);
        answererRelation = NSStringNilIsBad(self.caseInquire.relation);
        answererPhoneNum = NSStringNilIsBad(self.caseInquire.phone);
        inquireNote = NSStringNilIsBad(self.caseInquire.inquiry_note);
        inquireNotePages = (NSMutableArray *)[self pagesSplitted];
        pagesCount = [NSString stringWithFormat:@"%d",[inquireNotePages count]];
        pageNum = @"1";
    }
    
    if (date) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        dateString =[dateFormatter stringFromDate:date];
    }
    
    
    Citizen *citizen = [Citizen citizenForCitizenName:self.caseInquire.answerer_name nexus:self.caseInquire.relation case:self.caseID];
    if (citizen != nil) {
        answererSex = NSStringNilIsBad(citizen.sex);
        answererAge = NSStringNilIsBad((NSString *)citizen.age);
        answererOrgDuty = NSStringNilIsBad(citizen.org_principal_duty);
        answererAddress = NSStringNilIsBad(citizen.address);
        answererPostalCode = [NSStringNilIsBad(citizen.postalcode) emptyFor:@"无"];
        
    }
    
    id caseInquireData = @{
                           @"date":dateString,
                           @"place":address,
                           @"inquirerName":inquirerName,
                           @"recorderName":recorderName,
                           @"answererName":answererName,
                           @"answererSex":answererSex,
                           @"answererAge":answererAge,
                           @"answererRelation":answererRelation,
                           @"answererOrgDuty":answererOrgDuty,
                           @"answererPhoneNum":answererPhoneNum,
                           @"answererAddress":answererAddress,
                           @"answererPostalCode":answererPostalCode,
                           @"inquireNote":inquireNotePages
                           };
    
    id page = @{
                @"pageCount":pagesCount,
                @"pageNum":pageNum
                };
    
    id data = @{
                @"case": caseData,
                @"caseInquire": caseInquireData,
                @"page":page
                };
    
    return data;
}




//-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
//
//    if (!self.caseInquire) {
//        return nil;
//    }
//    [self pageSaveInfo];
//    if (![filePath isEmpty]) {
//        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
//
//        NSArray *pages = [self pagesSplitted];
//        NSMutableDictionary *dataInfo = [self getDataInfo];
//        if ([pages count] <2) {
//            dataInfo[@"PageNumberInfo"][@"pageCount"][@"value"] = @([pages count]);
//            dataInfo[@"PageNumberInfo"][@"pageNumber"][@"value"] = @([pages count]);
//            UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//            [self drawDateTable:xmlName withDataModel:dataInfo];
//        }else{
//            for (int i = [pages count] - 1 ; i >= kPageInfoFirstPage; i--) {
//                //第i页
//                dataInfo[@"CaseInquire"][@"inquiry_note"][@"value"] = pages[i];     //也会影响到dataInfo[@"Default"]对应的值
//                dataInfo[@"PageNumberInfo"][@"pageCount"][@"value"] = @([pages count]);
//                dataInfo[@"PageNumberInfo"][@"pageNumber"][@"value"] = @(i+1);
//
//                UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//                if (i == kPageInfoFirstPage) {
//                    [self drawDataTable:xmlName withDataInfo:dataInfo];
//                    //[self drawDateTable:xmlName withDataModel:self.caseInquire];
//                } else {
//                    [self drawDataTable:secondPageXmlName withDataInfo:dataInfo];
//                    //[self drawDateTable:xmlName withDataModel:self.caseInquire];
//                }
//            }
//        }
//
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:formatFilePath];
//    } else {
//        return nil;
//    }
//
//}

/*
 -(NSURL *)toFullPDFWithPath:(NSString *)filePath{
 
 if (!self.caseInquire) {
 return nil;
 }
 [self pageSaveInfo];
 if (![filePath isEmpty]) {
 // NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
 CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
 UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
 
 NSArray *pages = [self pagesSplitted];
 NSMutableDictionary *dataInfo = [self getDataInfo];
 if ([pages count] <2) {
 dataInfo[@"PageNumberInfo"][@"pageCount"][@"value"] = @([pages count]);
 dataInfo[@"PageNumberInfo"][@"pageNumber"][@"value"] = @([pages count]);
 UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
 [self drawStaticTable:xmlName];
 [self drawDataTable:xmlName withDataInfo:dataInfo];
 }else{
 for (int i = [pages count] - 1 ; i >= kPageInfoFirstPage; i--) {
 //第i页
 dataInfo[@"CaseInquire"][@"inquiry_note"][@"value"] = pages[i];     //也会影响到dataInfo[@"Default"]对应的值
 dataInfo[@"PageNumberInfo"][@"pageCount"][@"value"] = @([pages count]);
 dataInfo[@"PageNumberInfo"][@"pageNumber"][@"value"] = @(i+1);
 
 UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
 if (i == kPageInfoFirstPage) {
 [self drawStaticTable:xmlName];
 [self drawDataTable:xmlName withDataInfo:dataInfo];
 } else {
 [self drawStaticTable:secondPageXmlName];
 [self drawDataTable:secondPageXmlName withDataInfo:dataInfo];
 }
 }
 }
 
 UIGraphicsEndPDFContext();
 return [NSURL fileURLWithPath:filePath];
 } else {
 return nil;
 }
 
 //
 //    if (!self.caseInquire) {
 //        return nil;
 //    }
 //    [self pageSaveInfo];
 //    if (![filePath isEmpty]) {
 //        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
 //        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
 //        //NSArray *pages = [self ];
 //
 //        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
 //        [self drawStaticTable:xmlName];
 //        [self drawDateTable:xmlName withDataModel:self.caseInquire];
 //        UIGraphicsEndPDFContext();
 //        return [NSURL fileURLWithPath:filePath];
 //    } else {
 //        return nil;
 //    }
 }
 
 */

- (NSArray *)pagesSplitted {
    NSString *inquiryNote = self.caseInquire.inquiry_note;
    inquiryNote = [inquiryNote stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGFloat lineHeight1 = 26.9291;
    UIFont *font1 = [UIFont fontWithName:FONT_SongTi size:10.5];
    CGRect page1Rect = [self rectInPage:kPageInfoSucessivePage];
    page1Rect.size.width = 453.543;
    page1Rect.size.height = 360.0;
    
    CGFloat lineHeight2 = 26.9291;
    UIFont *font2 = [UIFont fontWithName:FONT_SongTi size:10.5];
    CGRect page2Rect = [self rectInPage:kPageInfoSucessivePage];
    page2Rect.size.width = 453.543;
    page2Rect.size.height = 360.0;
    
    
    NSArray *pages = [inquiryNote pagesWithFont:font1 lineHeight:lineHeight1 horizontalAlignment:UITextAlignmentLeft page1Rect:page1Rect followPageRect:page2Rect];
    
    if ([pages count] > 2) {
        //        NSString *textInFirstPage = pages[kPageInfoFirstPage];
        //        NSRange firstpageRange = NSMakeRange(0, [textInFirstPage length]);
        //        NSString *textInSuccessivePage = [inquiryNote stringByReplacingCharactersInRange:firstpageRange withString:@""];
        NSArray *successivePages = [inquiryNote pagesWithFont:font2 lineHeight:lineHeight2 horizontalAlignment:UITextAlignmentLeft page1Rect:page2Rect followPageRect:page2Rect];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        //        [tempArr addObject:pages[kPageInfoFirstPage]];
        for (NSUInteger i = 0; i < [successivePages count]; i++) {
            [tempArr addObject:successivePages[i]];
        }
        pages = [tempArr copy];
    }
    return pages;
}
- (CGFloat)fontSizeInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *fontSizeElement = [TBXML childElementNamed:@"fontSize" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    return [[TBXML textForElement:fontSizeElement] floatValue];
}

- (CGFloat)lineHeightInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *lineHeightElement = [TBXML childElementNamed:@"lineHeight" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    return [[TBXML textForElement:lineHeightElement] floatValue];
}


- (CGRect)rectInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *sizeElement = [TBXML childElementNamed:@"size" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    TBXMLElement *originElement = [TBXML childElementNamed:@"origin" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    NSAssert(sizeElement != nil && originElement != nil, @"Fail when looking up child element 'size' or 'origin'");
    
    CGFloat x = [[TBXML valueOfAttributeNamed:@"x" forElement:originElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat y = [[TBXML valueOfAttributeNamed:@"y" forElement:originElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat width = [[TBXML valueOfAttributeNamed:@"width" forElement:sizeElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat height = [[TBXML valueOfAttributeNamed:@"height" forElement:sizeElement] floatValue] * MMTOPIX * SCALEFACTOR +110;
    return CGRectMake(x, y, width, height);
}
- (NSMutableDictionary *)getDataInfo{
    // dataInfo用法:
    // (1) id value = dataInfo[实体名][属性名][@"value"]
    // (2) NSAttributeDescription *desc = dataInfo[实体名][属性名][@"valueType"]
    // (3) dataInfo[@"Default"]针对XML中未指名实体的项
    NSMutableDictionary *dataInfo = [[NSMutableDictionary alloc] init];
    
    //将CaseInquire的属性名、属性值、属性描述装入dataInfo
    NSMutableDictionary *caseInquireDataInfo = [[NSMutableDictionary alloc] init];
    NSDictionary *caseInquireAttributes = [self.caseInquire.entity attributesByName];
    for (NSString *attribName in caseInquireAttributes.allKeys) {
        id attribValue = [self.caseInquire valueForKey:attribName];
        NSAttributeDescription *attribDesc = [caseInquireAttributes objectForKey:attribName];
        NSAttributeType attribType = attribDesc.attributeType;
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     attribValue,@"value",
                                     @(attribType),@"valueType",nil];
        [caseInquireDataInfo setObject:data forKey:attribName];
        
    }
    
    //将CaseInfo的属性名、属性值、属性描述装入dataInfo
    CaseInfo *relativeCaseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSMutableDictionary *caseInfoDataInfo = [[NSMutableDictionary alloc] init];
    NSDictionary *caseInfoAttributes = [relativeCaseInfo.entity attributesByName];
    for (NSString *attribName in caseInfoAttributes.allKeys) {
        id attribValue = [relativeCaseInfo valueForKey:attribName];
        NSAttributeDescription *attribDesc = [caseInfoAttributes objectForKey:attribName];
        NSAttributeType attribType = attribDesc.attributeType;
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     attribValue,@"value",
                                     @(attribType),@"valueType",nil];
        [caseInfoDataInfo setObject:data forKey:attribName];
    }
    
    //设置一个Default（针对xml里没有entityName的节点），指向caseInquireDataInfo
    [dataInfo setObject:caseInquireDataInfo forKey:@"Default"];
    [dataInfo setObject:caseInquireDataInfo forKey:[self.caseInquire.entity name]];
    
    [dataInfo setObject:caseInfoDataInfo forKey:[relativeCaseInfo.entity name]];
    
    //预留页码位置
    NSMutableDictionary *pageCountInfo = [[NSMutableDictionary alloc] init];
    [pageCountInfo setObject:@(NSInteger32AttributeType) forKey:@"valueType"];
    NSMutableDictionary *pageNumberInfo = [[NSMutableDictionary alloc] init];
    [pageNumberInfo setObject:@(NSInteger32AttributeType) forKey:@"valueType"];
    [dataInfo setObject:[@{@"pageCount":pageCountInfo, @"pageNumber":pageNumberInfo} mutableCopy]
                 forKey:@"PageNumberInfo"];
    
    return dataInfo;
}


#pragma mark - CasePrintProtocol

//- (NSString *)templateNameKey
//{
//    return DocNameKeyPei_AnJianXunWenBiLu;
//}
//
//- (id)dataForPDFTemplate {
//
//
//    id caseData = @{};
//    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//    if (caseInfo) {
//        NSString *mark2 = NSStringNilIsBad(caseInfo.case_mark2);
//        NSString *mark3 = NSStringNilIsBad(caseInfo.full_case_mark3);
//        caseData = @{
//                     @"mark2": mark2,
//                     @"mark3": mark3
//                     };
//    }
//
//    id caseInquireData = @{};
//
//    if (self.caseInquire) {
//        NSString *dateString = NSStringFromNSDateAndFormatter(self.caseInquire.date_inquired, NSDateFormatStringCustom1);
//        NSString *place = NSStringNilIsBad(self.caseInquire.locality);
//        NSString *inquirerName = NSStringNilIsBad(self.caseInquire.inquirer_name);
//        NSString *recorderName = NSStringNilIsBad(self.caseInquire.recorder_name);
//        NSString *answererName = NSStringNilIsBad(self.caseInquire.answerer_name);
//        NSString *answererAge = NSStringNilIsBad([self.caseInquire.age stringValue]);
//        NSString *answererSex = NSStringNilIsBad(self.caseInquire.sex);
//        NSString *answererRelation = NSStringNilIsBad(self.caseInquire.relation);
//        NSString *answererOrgDuty = NSStringNilIsBad(self.caseInquire.company_duty);
//        NSString *answererPhoneNum = NSStringNilIsBad(self.caseInquire.phone);
//        NSString *answererAddress = NSStringNilIsBad(self.caseInquire.address);
//        NSString *answererPostalCode = NSStringNilIsBad(self.caseInquire.postalcode);
//        NSString *inquireNote = NSStringNilIsBad(self.caseInquire.inquiry_note);
//
//        caseInquireData = @{
//                            @"date": dateString,
//                            @"place": place,
//                            @"inquirerName": inquirerName,
//                            @"recorderName": recorderName,
//                            @"answererName": answererName,
//                            @"answererAge": answererAge,
//                            @"answererSex": answererSex,
//                            @"answererRelation": answererRelation,
//                            @"answererOrgDuty": answererOrgDuty,
//                            @"answererPhoneNum": answererPhoneNum,
//                            @"answererAddress": answererAddress,
//                            @"answererPostalCode": answererPostalCode,
//                            @"inquireNote": inquireNote
//                            };
//    }
//
//    id pageData = @{
//                    @"pageNum": @(1),
//                    @"pageCount": @(1),
//                    };
//
//    id data = @{
//                @"case": caseData,
//                @"caseInquire": caseInquireData,
//                @"page": pageData,
//                };
//    return data;
//}
//
//#pragma mark -
//#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    switch (textField.tag) {
//        case 100:
//        case 101:
//        case 200:
//        case 201:
//        case 202:
//            return NO;
//            break;
//        default:
//            return YES;
//            break;
//    }
//}
//
- (IBAction)userSelect:(UITextField *)sender {
    self.textFieldTag = sender.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (self.textFieldTag == 200) {
        self.textinquirer_name.text = name;
    }else if (self.textFieldTag == 201){
        self.textrecorder_name.text = name;
    }
}
@end
