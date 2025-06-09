//
//  ParseDataTool.h
//  数据转换工具类
//
//  Created by BJSTTLP185 on 2025/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数据转换工具类
@interface ParseDataTool : NSObject

/// 小端NSData转整数
+ (NSInteger)transLittleEndianDataToInteger:(NSData *)data;

/// 大端NSData转整数
+ (NSInteger)convertDataToInteger:(NSData *)data;

/// NSData 转十六进制字符串
+ (NSString *)transDataToHexString:(NSData *)data;

/// 十六进制字符串转 NSData
+ (NSData *)transToDataWithString:(NSString *)hexString;

/// 十六进制字符串倒序排列
+ (NSString *)invertedOrderWithStr:(NSString *)str;

/// 十六进制字符串转十进制整数
+ (NSInteger)convertToDecimalFromHex:(NSString *)hexString;

/// 格式化为 "aa bb cc dd"
+ (NSString *)describeBlankFormatWithString:(NSString *)dataString;

/// 格式化为 "0xaa, 0xbb, 0xcc, 0xdd"
+ (NSString *)describeBytesFormatWithString:(NSString *)dataString;

/// 字节序转换：小端 <-> 大端
+ (NSData *)convertNSData:(NSData *)source;

/// 将字符串按大端字节序排列（默认倒序）
+ (NSString *)transString2BigMode:(NSString *)string;

/// 字节异或校验值（返回字符串）
+ (NSString *)xorWithDataString:(NSString *)dataString;

/// 比较 NSData 异或校验结果是否为某个值
+ (BOOL)compareImageData:(NSData *)imageData withXORValue:(NSInteger)xorValue;

/// 安全截取NSData（越界不会崩溃）
+ (NSData *)subMyData:(NSData *)data range:(NSRange)range;

/// 长度交换：16位数（用于字节反转）
+ (UInt16)numswap:(int)len;

@end

NS_ASSUME_NONNULL_END
