//
//  Utility.m
//  webUrlTest
//
//  Created by user on 15-11-11.
//  Copyright (c) 2015年 gotop. All rights reserved.
//

#import "Utility.h"
#import <openssl/evp.h>
#import <openssl/md5.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation Utility

#pragma mark - 进制转换
+ (void)hex2dec:(Byte *)hex andLen:(int)len andDec:(Byte *)dec {
    Byte t[3] = {0};
    for (int i = 0; i < len; i++) {
        strncpy((char *)t, (char *)(hex+2*i), 2);
        dec[i] = strtol((char *)t, nil, 16);
    }
}

+ (Byte *)hex2dec:(NSString *)hexStr {
    Byte *dec = (Byte *)malloc(hexStr.length / 2);
    memset(dec, 0, (hexStr.length / 2));
    [self hex2dec:(Byte*)hexStr.UTF8String andLen:(int)hexStr.length/2 andDec:dec];
    return  dec;
}

+ (NSString *)ascii2Hex:(NSString *)asciiStr {
    NSMutableString *hexStr = [NSMutableString string];
    Byte hex[3];
    bzero(hex, 3);
    Byte *ascii = (Byte *)asciiStr.UTF8String;
    Byte item = 0;
    for (int i = 0; i < asciiStr.length / 2; i++) {
        strncpy((char*)hex, (char *)(ascii+2*i), 2);
        item = strtol((char *)hex, nil, 10);
        if(item>=0x30&&item<=0x39)
            item=item-0x30;
        else if (item>=0x41&&item<=0x46)
            item=item-0x41+10;
        else if (item>=0x61&&item<=0x66)
            item=item-0x61+10;
        
        [hexStr appendString:[NSString stringWithFormat:@"%c",item]];
    }
    
    return [hexStr copy];
}


+ (NSString *)dec2hex:(Byte *)dec andLen:(int)len {
    NSMutableString *hex = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        [hex appendFormat:@"%02X", dec[i]];
    }
    
    return [hex copy];
}




// 16进制颜色#e26562与UIColor互转,设置View背景颜色
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)encrypt:(NSString *)inStr andKey:(NSString *)key {
    Byte msg_out[512] = {0};
    int len1 = 0;
    int len2 = 0;
    Byte *bKey = (Byte *)key.UTF8String;
    Byte *msg_in = (Byte *)inStr.UTF8String;
    
    int msgLen = (int)strlen((char *)msg_in);
    
    EVP_CIPHER_CTX ctx;
    EVP_CIPHER_CTX_init(&ctx);
    EVP_EncryptInit_ex(&ctx, EVP_aes_128_ecb(), NULL, bKey, NULL);
    
    EVP_EncryptUpdate(&ctx, msg_out, &len1, msg_in, msgLen);
    
    Byte *bb = msg_out+len1;
    
    EVP_EncryptFinal_ex(&ctx, bb, &len2);
    EVP_CIPHER_CTX_cleanup(&ctx);
    
    NSString *result = [Utility dec2hex:msg_out andLen:len1 + len2];
    
    if (!result) {
        result = @"";
        
    }
    return [result copy];
}



+ (NSString *)decrypt:(NSString *)inStr andKey:(NSString *)key {
    int len1 = 0;
    int len2 = 0;
    
    Byte *inByte = [Utility hex2dec:inStr];
    
    int len = (int)inStr.length / 16;
    if(16 * len <= inStr.length)
        len++;
    Byte *ms_out1 = (Byte *)malloc(16 * len);
    memset(ms_out1, 0, (16 * len));
    
    EVP_CIPHER_CTX ctx;
    EVP_CIPHER_CTX_init(&ctx);
    EVP_DecryptInit_ex(&ctx, EVP_aes_128_ecb(), NULL, (Byte *)key.UTF8String, NULL);
    EVP_DecryptUpdate(&ctx, ms_out1, &len1, inByte, (int)inStr.length/2);
    EVP_DecryptFinal_ex(&ctx, ms_out1+len1, &len2);
    
    EVP_CIPHER_CTX_cleanup(&ctx);
    NSString *result = [NSString stringWithUTF8String:(char *)ms_out1];
    
    
    NSRange r0 = [result rangeOfString:@"[{\"" options:NSCaseInsensitiveSearch];
    NSRange r1 = [result rangeOfString:@"}]" options:NSBackwardsSearch];
    if (r0.location < r1.location && r1.location <= result.length) {
        result = [result substringWithRange:NSMakeRange(r0.location, r1.location + 2)];
    }
    free(ms_out1);
    free(inByte);
    return  result;
}




+ (NSString *)md5DoubleByteEncrypt:(NSString *)msb {
    char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
    Byte md5[17]={0};
    
    if (!msb || [msb isEqualToString:@""]) {
        return nil;
    }
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, msb.UTF8String, msb.length);
    MD5_Final(md5, &ctx);
    
    //    CC_MD5(msb.UTF8String, (CC_LONG)msb.length, md5);
    char str[16 * 2 + 1] = {0};
    int k = 0;
    for (int i = 0; i < 16; i++) {	//双字节加密
        Byte byte0 = md5[i];
        str[k++] = hexDigits[byte0 >> 4 & 0xf];
        str[k++] = hexDigits[byte0 & 0xf];
    }
    
    NSString *de = [NSString stringWithUTF8String:str];
    NSString *msh = [NSString stringWithFormat:@"%@%@", gKey, de];
    return [msh copy];
}



#pragma mark - http
// // ///////////////////////////////////到这里为止  以上都是 进制转换 不用管  以下是网络调用的函数//////////////////////////////////////



+ (BOOL)netState {
    
    if (gNetState > 0) {
        return YES;
    } else {
        return NO;
    }
}        //网络状态标志位  大于0 表示成功

+(NSString *)getdatetime{


    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //NSLog(@"[%@]",locationString);
    return [locationString stringByAppendingString:@"#|99#|"];

}


//计算字符串长度 中文两个字节  英文一个字节
+  (int)convertToInt:(NSString*)strtemp {
    
    int strlength1 = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength1++;
        }
        else {
            p++;
        }
    }
    return strlength1+6;
    
}



+ (void)netWarm {   //网络温暖 存在 函数
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <= 0) {
            gNetState = 0;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"无网络连接，请先设置好网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        } else {
            gNetState = 1;
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}





// // ////////////////////////////以下 是 关于 获取ip 的函数 有必要进行了解  //////////////////////////////////////////////////////
#pragma mark - ip 端口获取

+ (NSMutableArray *)arrayOfSetting {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths    objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:[[NSString alloc]initWithCString:_PLISTFILE_ encoding:NSUTF8StringEncoding]];
    NSMutableArray *array =[[NSMutableArray alloc] initWithContentsOfFile:filename];
    return array;
}

+ (NSString *)ip {
    NSString *_ip = gIP;
    if (!_ip) {
        //    return @"211.156.198.57";   //这里表示如果出错了  使用的是哪一个地址 因此需要填的是 真实服务的地址
        
        
        //return @"211.156.198.83";
        return @"211.156.200.95";
        
    }
    return [_ip copy];
}

+ (NSString *)port {
    NSString *_port = gPort;
    if (!_port) {
        //  return @"8081";             //这里表示如果出错了  使用的是哪一个地址 因此需要填的是 真实服务的地址
        
        //return @"8019";
        return @"8082";
    }
    return [_port copy];
}

+ (NSString *)urlWithMethod:(NSString *)method params:(NSString *)params {
    NSString *msb = [Utility encrypt:params andKey:gKey];
    NSString *msh = [Utility md5DoubleByteEncrypt:msb];
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/postreceive.do?method=%@&msh=%@&msb=%@", [Utility ip], [Utility port], method, msh, msb];
    
    //NSLog(@"传进来的是：[%@]\n\n",urlStr);
    return [urlStr copy];
}


//自己定义的要被调用的获取ip的函数
//http://192.168.201.110:7602/gnzqService/service/PostService

+ (NSString *)urlappendwithmethod:(NSString *)method {  //只要传方法名进来
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/gnzqService/service/%@", [Utility ip], [Utility port], method];
    
    return [urlStr copy];
}




// // /////////////////////////////////////以下是报文解析函数 解析报文头以及报文体 还有去除服务器返回的 某个字符  这个也暂时不用管

+ (int)resolveHeadNoData:(NSString *)src {
    if (!src || [src isEqualToString:@""]) {
        return -1;
    }
    
    NSString *successFlag = [src substringWithRange:NSMakeRange(52, 1)];//交易结果 0.失败 1.成功
    NSString *bFailureMsg = [src substringWithRange:NSMakeRange(53, src.length-53)];
    
    NSString *result = [Utility decrypt:bFailureMsg andKey:gKey];
    
    sfdm = [NSString stringWithFormat:@"%d", result.intValue];
    
    return successFlag.intValue;
}

// 去除服务器返回的/r/r/r/r/r/r
+ (NSString *)modifyFailureMsg:(NSString *)bMsg {
    NSInteger loc = bMsg.length;
    while ([bMsg characterAtIndex:loc-1] == '\r') {
        loc--;
    }
    NSRange range = NSMakeRange(0, loc);
    bMsg = [bMsg substringWithRange:range];
    return [bMsg copy];
}




+ (NSArray *)resolveHead:(NSString *)src {
    if (!src || [src isEqualToString:@""]) {
        return nil;
    }
    
   
    
    NSString *key = [src substringWithRange:NSMakeRange(0, 16)];	//密钥
    NSString *bMd5 = [src substringWithRange:NSMakeRange(16, 32)];	//MD5校验码
    NSString *len = [src substringWithRange:NSMakeRange(48, 4)];	//消息体长度(加密后)
    NSString *successFlag = [src substringWithRange:NSMakeRange(52, 1)];//交易结果 0.失败 1.成功
    NSString *bFailureMsg = [src substringWithRange:NSMakeRange(53, src.length - 53 - len.intValue)];
    //    bFailureMsg = [Utility AES256ParmDecryptWithKey:gKey andMsg:bFailureMsg];
    
   
    
    bFailureMsg = [Utility decrypt:bFailureMsg andKey:gKey];
    
    
    if (!bFailureMsg) {
        bFailureMsg = @"";
    }
    bFailureMsg = [Utility modifyFailureMsg:bFailureMsg];//去除服务器返回过来的字符串里面的/r字符
    
    
    
    NSArray *array = [[NSArray alloc] initWithObjects:successFlag, key, bMd5, len, src, bFailureMsg, nil];
    
   
    
    return array;
    
    
}

//              0       1      2    3    4      5
//         successFlag, key, bMd5, len, src, bFailureMsg



+ (NSArray *)resolveBody:(NSArray *)array {   //传入数组   传出  什么
    
  
    
    NSString *key = (NSString *)array[1];
    NSString *bMd5 = (NSString *)array[2];
    int len = ((NSString *)array[3]).intValue;
    NSString *src = (NSString *)array[4];
    
    
    
    
    if (len > src.length) {
        return nil;
    }
    NSString *rmsb = [src substringWithRange:NSMakeRange(src.length - len, len)];   //这里是截取返回的报文   因为总长度减去报文长度  开始就是正文的开始位置
    
   
    
    char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
    Byte md5[17]={0};
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, rmsb.UTF8String, rmsb.length);
    MD5_Final(md5, &ctx);
    //    CC_MD5(rmsb.UTF8String, (CC_LONG)rmsb.length, md5);
    char str[16 * 2 + 1] = {0};
    int k = 0;
    for (int i = 0; i < 16; i++) {	//双字节加密
        Byte byte0 = md5[i];
        str[k++] = hexDigits[byte0 >> 4 & 0xf];
        str[k++] = hexDigits[byte0 & 0xf];
    }
   
    
    
    
    if (strcmp(str, bMd5.UTF8String)) {
        
        return nil;
    }
    
    
    else {
        NSString *result = [Utility decrypt:rmsb andKey:key];
        /*
         NSString *result = @"{\"V_SJRDZ\":\"\",\"V_SJRDH\":\"13732290331\",\"V_YJHM\":\"590336494225\",\"N_YJLY\":\"01\",\"V_YJLSH\":\"1090\",\"C_JSBZ\":\"1\",\"V_JGBH\":\"210005614\",\"V_SJRXM\":\"刘先生\",\"V_WLGS\":\"圆通速递\",\"C_QSBZ\":\"0\"}";
         
         NSLog(@"nnnn7[%@]\n",(NSString *)result);
         NSLog(@"nnnn8[%@]\n",result.JSONValue);*/
        
        /*
         传入
         nnnn7[{"V_SJRDZ":"","V_SJRDH":"13732290331","V_YJHM":"590336494225","N_YJLY":"01","V_YJLSH":"1090","C_JSBZ":"1","V_JGBH":"210005614","V_SJRXM":"刘先生","V_WLGS":"圆通速递","C_QSBZ":"0"}]*/
        
        
        
        return result.JSONValue;  //关键是不知道这个 返回值是什么   这里的返回值  是将  json 格式 转变成为 数组一样的元素
        
        
        
        /*经过了  JSONValue  以后传出报文
         
         2016-06-29 17:10:15.703 EPostPickUpByCustomer[2075:107658] nnnn8[{
         "C_JSBZ" = 1;
         "C_QSBZ" = 0;
         "N_YJLY" = 01;
         "V_JGBH" = 210005614;
         "V_SJRDH" = 13732290331;
         "V_SJRDZ" = "";
         "V_SJRXM" = "\U5218\U5148\U751f";
         "V_WLGS" = "\U5706\U901a\U901f\U9012";
         "V_YJHM" = 590336494225;
         "V_YJLSH" = 1090;
         }]*/
        
        
    }
}
@end
