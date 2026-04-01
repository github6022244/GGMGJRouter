//
//  GGJSONConvert.m
//  GGMGJRouter_Example
//
//  Created by GG on 2026/3/30.
//  Copyright © 2026 github6022244. All rights reserved.
//

#import "GGJSONConvert.h"

@implementation GGJSONConvert

+ (NSDictionary * _Nullable)dictionaryWithJSONFileName:(NSString *)jsonFileName {
    // 1. 获取文件路径
    // 因为它在主 Bundle 中，使用 [NSBundle mainBundle] 获取
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];

    // 2. 读取数据
    NSData *data = [NSData dataWithContentsOfFile:path];

    if (data) {
        // 3. 解析 JSON
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];

        if (error) {
            NSLog(@"JSON 解析失败: %@", error.localizedDescription);
        } else {
            // 4. 使用数据
            // 根据你的 JSON 结构，它可能是字典或数组
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = (NSDictionary *)jsonObject;
                return jsonDict;
            }
        }
    } else {
        NSLog(@"未找到 JSON 文件，请检查文件名或路径");
    }
    
    return nil;
}

@end
