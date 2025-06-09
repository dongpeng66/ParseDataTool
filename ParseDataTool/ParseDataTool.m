//
//  ParseDataTool.m
//  数据转换工具类
//
//  Created by BJSTTLP185 on 2025/6/9.
//

#import "ParseDataTool.h"

@implementation ParseDataTool

#pragma mark - 十六进制与整数转换

+ (NSInteger)transLittleEndianDataToInteger:(NSData *)data {
    if (!data || data.length == 0) return 0;
    UInt32 value = 0;
    [data getBytes:&value length:MIN(sizeof(value), data.length)];
    return CFSwapInt32LittleToHost(value);
}

+ (NSInteger)convertDataToInteger:(NSData *)data {
    if (!data || data.length == 0) return 0;
    UInt32 value = 0;
    [data getBytes:&value length:MIN(sizeof(value), data.length)];
    return CFSwapInt32BigToHost(value);
}

#pragma mark - 十六进制与字符串转换

+ (NSString *)transDataToHexString:(NSData *)data {
    if (!data || data.length == 0) return @"";
    const unsigned char *dataBuffer = data.bytes;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:data.length * 2];
    for (int i = 0; i < data.length; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}

+ (NSData *)transToDataWithString:(NSString *)hexString {
    if (!hexString || hexString.length == 0) return [NSData data];
    NSMutableData *data = [NSMutableData data];
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    for (NSInteger i = 0; i < cleanString.length; i += 2) {
        NSString *byteString = [cleanString substringWithRange:NSMakeRange(i, 2)];
        unsigned int byteValue = 0;
        [[NSScanner scannerWithString:byteString] scanHexInt:&byteValue];
        UInt8 byte = (UInt8)byteValue;
        [data appendBytes:&byte length:1];
    }
    return [data copy];
}

+ (NSString *)invertedOrderWithStr:(NSString *)str {
    if (!str || str.length % 2 != 0) return @"";
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = str.length; i > 0; i -= 2) {
        NSString *byte = [str substringWithRange:NSMakeRange(i - 2, 2)];
        [result appendString:byte];
    }
    return [result copy];
}

+ (NSInteger)convertToDecimalFromHex:(NSString *)hexString {
    if (!hexString || hexString.length == 0) return 0;
    unsigned int result = 0;
    [[NSScanner scannerWithString:hexString] scanHexInt:&result];
    return result;
}

#pragma mark - 格式化输出辅助

+ (NSString *)describeBlankFormatWithString:(NSString *)dataString {
    if (!dataString || dataString.length == 0) return @"";
    NSMutableArray *components = [NSMutableArray array];
    for (NSInteger i = 0; i < dataString.length; i += 2) {
        if (i + 2 <= dataString.length) {
            NSString *byte = [dataString substringWithRange:NSMakeRange(i, 2)];
            [components addObject:byte];
        }
    }
    return [components componentsJoinedByString:@" "];
}

+ (NSString *)describeBytesFormatWithString:(NSString *)dataString {
    if (!dataString || dataString.length == 0) return @"";
    NSMutableArray *components = [NSMutableArray array];
    for (NSInteger i = 0; i < dataString.length; i += 2) {
        if (i + 2 <= dataString.length) {
            NSString *byte = [dataString substringWithRange:NSMakeRange(i, 2)];
            [components addObject:[NSString stringWithFormat:@"0x%@", byte]];
        }
    }
    return [components componentsJoinedByString:@", "];
}

#pragma mark - 大小端与字符串处理

+ (NSString *)transString2BigMode:(NSString *)string {
    // 默认假设为小端，按两位进行倒序
    return [self invertedOrderWithStr:string];
}

+ (NSData *)convertNSData:(NSData *)source {
    if (!source || source.length == 0) return [NSData data];
    NSMutableData *result = [NSMutableData dataWithCapacity:source.length];
    const Byte *srcBytes = source.bytes;
    for (NSInteger i = source.length - 1; i >= 0; i--) {
        [result appendBytes:&srcBytes[i] length:1];
    }
    return [result copy];
}

+ (UInt16)numswap:(int)len {
    UInt16 value = (UInt16)len;
    return (value >> 8) | (value << 8);
}

#pragma mark - 异或计算与校验

+ (NSString *)xorWithDataString:(NSString *)dataString {
    if (!dataString || dataString.length % 2 != 0) return @"00";
    UInt8 xorResult = 0x00;
    for (NSInteger i = 0; i < dataString.length; i += 2) {
        NSString *byteStr = [dataString substringWithRange:NSMakeRange(i, 2)];
        unsigned int byte = 0;
        [[NSScanner scannerWithString:byteStr] scanHexInt:&byte];
        xorResult ^= (UInt8)byte;
    }
    return [NSString stringWithFormat:@"%02x", xorResult];
}

+ (BOOL)compareImageData:(NSData *)imageData withXORValue:(NSInteger)xorValue {
    if (!imageData || imageData.length == 0) return NO;
    UInt8 result = 0x00;
    const Byte *bytes = imageData.bytes;
    for (NSInteger i = 0; i < imageData.length; i++) {
        result ^= bytes[i];
    }
    return result == xorValue;
}

#pragma mark - 安全的数据裁剪

+ (NSData *)subMyData:(NSData *)data range:(NSRange)range {
    if (!data || data.length == 0) return [NSData data];
    if (range.location + range.length > data.length) return [NSData data];
    return [data subdataWithRange:range];
}

@end
