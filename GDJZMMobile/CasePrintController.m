//
//  CasePrintController.m
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-8-29.
//
//

#import "CasePrintController.h"



/* 常用自定义日期格式化字符串 */
NSString * const NSDateFormatStringCustom1 = @"yyyy年MM月dd日";
/* 公路赔补偿案件 */
NSString * const DocNameKeyPei_PeiBuChangQingDan                    = @"GongLuPeiBuChangQingDan";
NSString * const DocNameKeyPei_AnJianKanYanJianChaBiLu              = @"GongLuPeiBuChangAnJianKanYanJianChaBiLu";
NSString * const DocNameKeyPei_AnJianDiaoChaBaoGao                  = @"GongLuPeiBuChangAnJianDiaoChaBaoGao";
NSString * const DocNameKeyPei_AnJianJieAnBaoGao                    = @"GongLuPeiBuChangAnJianJieAnBaoGao";
NSString * const DocNameKeyPei_AnJianXunWenBiLu                     = @"GongLuPeiBuChangAnJianXunWenBiLu";
NSString * const DocNameKeyPei_AnJianXunWenBiLuExtra                = @"GongLuPeiBuChangAnJianXunWenBiLuExtra";
NSString * const DocNameKeyPei_AnJianGuanLiWenShuSongDaHuiZheng     = @"GongLuPeiBuChangAnJianGuanLiWenShuSongDaHuiZheng";
NSString * const DocNameKeyPei_PeiBuChangTongZhiShu                   = @"GongLuPeiBuChangTongZhiShu";
NSString * const DocNameKeyPei_LuZhengAnJianXianChangKanYanTu       = @"LuZhengAnJianXianChangKanYanTu";
NSString * const DocNameKeyPei_ZeLingCheLiangTingShiTongZhiShu      = @"ZeLingCheLiangTingShiTongZhiShu";
/* 交通行政处罚案件 */
NSString * const DocNameKeyFa_ZeLingGaiZhengTongZhiShu              = @"ZeLingGaiZhengTongZhiShu";
//NSString * const DocNameKeyFa_ZeLingGaizhengTongZhi               = @"ZeLingGaizhengTongZhi";
NSString * const DocNameKeyFa_SheXianWeiFaXingWeiGaoZhiShu          = @"SheXianWeiFaXingWeiGaoZhiShu";

//NSString *const DocNameKeyFa_KanYanJianChaBiLu                      =@"KanYanJianChaBiLu";

NSString * const DocNameKeyFa_JiaoTongWeiFaXingWeiGaoZhiShu         = @"GongLuWeiFaAnJianJiaoTongWeiFaXingWeiGaoZhiShu";
NSString * const DocNameKeyFa_GongLuWeiFaAnJianGaoZhiBiao         = @"DocNameKeyFa_GongLuWeiFaAnJianGaoZhiBiao";
NSString * const DocNameKeyFa_XianChangKanYanTu                     = @"GongLuWeiFaAnJianXianChangKanYanTu";

NSString *const DocNameKeyFa_KanYanJianChaBiLu                      = @"GongLuWeiFaAnJianKanYanJianChaBiLu";
NSString *const DocNameKeyFa_XunWenBiLu                             = @"GongLuWeiFaAnJianXunWenBiLu";
/* 默认文档目录 */
NSString * const DefaultTemplateDirectory = @"DocTemplates";


@implementation CasePrintController

- (id)init
{
    self = [super init];
    [GRMustacheConfiguration defaultConfiguration].contentType = GRMustacheContentTypeText;
    NSString *templatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DefaultTemplateDirectory];
    self.templateRepo = [GRMustacheTemplateRepository templateRepositoryWithDirectory:templatesPath];
    self.templateNameDictionary = @{
                                    DocNameKeyPei_PeiBuChangQingDan:
                                        @"GongLuPeiBuChangQingDan.xml",
                                    DocNameKeyPei_AnJianKanYanJianChaBiLu:
                                        @"GongLuPeiBuChangAnJianKanYanJianChaBiLu.xml",
                                    DocNameKeyPei_AnJianXunWenBiLu:
                                        @"GongLuPeiBuChangAnJianXunWenBiLu.xml",
                                    DocNameKeyPei_AnJianXunWenBiLuExtra:
                                        @"GongLuPeiBuChangAnJianXunWenBiLuExtra.xml",
                                    DocNameKeyPei_AnJianDiaoChaBaoGao:
                                        @"GongLuPeiBuChangAnJianDiaoChaBaoGao.xml",
                                    DocNameKeyPei_AnJianJieAnBaoGao:
                                        @"GongLuPeiBuChangAnJianJieAnBaoGao.xml",
                                    DocNameKeyPei_AnJianGuanLiWenShuSongDaHuiZheng:
                                        @"GongLuPeiBuChangAnJianGuanLiWenShuSongDaHuiZheng.xml",
                                    DocNameKeyPei_PeiBuChangTongZhiShu:
                                        @"GongLuPeiBuChangTongZhiShu.xml",
                                    DocNameKeyPei_LuZhengAnJianXianChangKanYanTu:
                                        @"LuZhengAnJianXianChangKanYanTu.xml",
                                    DocNameKeyPei_ZeLingCheLiangTingShiTongZhiShu:
                                        @"ZeLingCheLiangTingShiTongZhiShu.xml",
                                    DocNameKeyFa_SheXianWeiFaXingWeiGaoZhiShu:
                                        @"SheXianWeiFaXingWeiGaoZhiShu.xml",
                                    DocNameKeyFa_KanYanJianChaBiLu:
                                        @"GongLuWeiFaKanYanJianChaBiLu.xml",
                                    DocNameKeyFa_JiaoTongWeiFaXingWeiGaoZhiShu:
                                        @"GongLuWeiFaJiaoTongWeiFaXingWeiGaoZhiShu.xml",
                                    DocNameKeyFa_GongLuWeiFaAnJianGaoZhiBiao:
                                        @"GongLuWeiFaAnJianGaoZhiBiao.xml",
                                    DocNameKeyFa_XunWenBiLu:
                                        @"GongLuWeiFaXunWenBiLu.xml",
                                    DocNameKeyFa_XianChangKanYanTu:
                                        @"GongLuWeiFaXianChangKanYanTu.xml"
                                    };
//     NSLog(@"%@", [[NSBundle mainBundle]pathForResource:@"ZeLingGaizhengTongZhiShu" ofType:@"xml"]);
//     NSLog(@"1111%@", [[NSBundle mainBundle]pathForResource:@"ZeLingCheLiangTingShiTongZhiShu.xml" ofType:@"mustache"]);
    return self;
}

- (BOOL)saveAsPDF:(NSString *)path dataOnly:(BOOL)isDataOnly
{
    if ([self.delegate respondsToSelector:@selector(templateNameKey)]) {
        NSString *templateNameKey = [self.delegate templateNameKey];
        NSString *templateName = [self.templateNameDictionary objectForKey:templateNameKey];
        NSError *err = nil;
        GRMustacheTemplate *template = [self.templateRepo templateNamed:templateName error:&err];
        if (err == nil && template != nil) {
            if ([self.delegate respondsToSelector:@selector(dataForPDFTemplate)]) {
                id data = [self.delegate dataForPDFTemplate];
                
                if ([data objectForKey:@"caseInquire"]) {
                    
                    NSMutableDictionary *dataDic = [[NSMutableDictionary dictionaryWithDictionary:data] mutableCopy];
                    NSMutableDictionary *caseInquire = [NSMutableDictionary dictionaryWithDictionary:[dataDic valueForKey:@"caseInquire"]];
                    NSArray * pagesArray = [caseInquire objectForKey:@"inquireNote"];
                    NSMutableArray *strings = [[NSMutableArray alloc]init];
                    if (pagesArray.count >= 2) {
                        NSMutableDictionary * dataDic = [[NSMutableDictionary dictionaryWithDictionary:data] mutableCopy];
                        for (NSInteger i = 0; i < [pagesArray count];i++) {
                            
                            NSMutableDictionary *caseInquire = [NSMutableDictionary dictionaryWithDictionary:[dataDic valueForKey:@"caseInquire"]];
                            NSMutableDictionary *page = [NSMutableDictionary dictionaryWithDictionary:[dataDic valueForKey:@"page"]];
                            
                            [page setObject:[NSString stringWithFormat:@"%d",i + 1] forKey:@"pageNum"];
                            [dataDic setObject:page forKey:@"page"];
                            
                            
                            NSString *inquireNotePage = [[pagesArray objectAtIndex:i] copy];
                            [caseInquire setObject:inquireNotePage forKey:@"inquireNote"];
                            [dataDic setObject:caseInquire forKey:@"caseInquire"];
                            
                            NSString *rendering = [template renderObject:dataDic error:&err];
                            
                            [strings addObject:rendering];
                        }
                        
                        
                        if (err == nil) {
                            self.pdfRenderer = [[XMLPDFRenderer alloc] init];
                            [self.pdfRenderer renderFromXMLStrings:strings toPDF:path dataOnly:isDataOnly];
                            return YES;
                        }
                    }
                }
                    NSString *rendering = [template renderObject:data error:&err];
                    
                    if (err == nil) {
                        self.pdfRenderer = [[XMLPDFRenderer alloc] init];
                        
                        [self.pdfRenderer renderFromXML:rendering toPDF:path dataOnly:isDataOnly];
                        
                        
                        return YES;
                    }
            
            } else {
                NSLog(@"CasePrintController的委托对象未实现相关协议中的dataForPDFTemplate方法");
            }
        }
        else{
            NSLog(@"%@",err);
        }
    } else {
        NSLog(@"CasePrintController的委托对象未实现相关协议中的templateNameKey方法");
    }
    
    return NO;
}

- (NSRange)rangeOfString:(NSString *)str drawInRect:(CGRect)rect withFont:(UIFont *)font headIndent:(CGFloat)indent andLineHeight:(CGFloat)lineHeight
{
    return NSMakeRange(0, 0);
}
@end




