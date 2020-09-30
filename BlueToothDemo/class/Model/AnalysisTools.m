//
//  AnalysisTools.m
//  BlueToothDemo
//
//  Created by mac on 2020/6/12.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AnalysisTools.h"

@implementation AnalysisTools

- (NSData *)codeDataWithString:(NSString *)msg
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:msg options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

@end
