

//
//  WBUserAccount.m
//  weibo
//
//  Created by 叮咚钱包富银 on 2017/11/1.
//  Copyright © 2017年 叮咚钱包富银. All rights reserved.
//

#import "WBUserAccount.h"
#import "NSString+CZPath.h"

@implementation WBUserAccount


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        //从磁盘读取保存的文件
        [self readFile];
        
    }
    return self;
}

- (void)readFile {
    NSString *fileName = [@"useraccount.json" cz_appendDocumentDir];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    if (data == NULL) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:@[] error:NULL];
    [self yy_modelSetWithDictionary:dic];
    
    NSLog(@"---------------");
    
}

- (void)saveAccount {
     NSDictionary *dic =  self.yy_modelToJSONObject;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:@[] error:NULL];
    
    NSString *fileName = [@"useraccount.json" cz_appendDocumentDir];
 
    [data writeToFile:fileName atomically:YES];
    
    NSLog(@"%@",fileName);

}

- (NSString *)description {
    return self.yy_modelDescription;
}

@end
