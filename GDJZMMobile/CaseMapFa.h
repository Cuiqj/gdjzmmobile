//
//  CaseMapFa.h
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-29.
//
//

#import "CaseMap.h"

/*
 *  违法案件 现场勘验图
 *  这些数据暂时保存在本地，不上传
 */
@interface CaseMapFa : BaseManageObject

@property (copy, nonatomic) NSString *myid; // 与caseMap.myid 相同
@property (copy, nonatomic) NSString *roadName; // 高速
@property (copy, nonatomic) NSString *roadDirection; // 方向
@property (copy, nonatomic) NSString *startK; // 桩号 K
@property (copy, nonatomic) NSString *startM; //     m
@property (copy, nonatomic) NSString *caseReason; // 违法项目:案由

+ (CaseMapFa *)caseMapFaForMap:(NSString *)mapId;

@end
