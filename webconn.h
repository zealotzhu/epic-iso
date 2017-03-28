//
//  webconn.h
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/6/27.
//  Copyright © 2016年 gotop. All rights reserved.
//

#ifndef webconn_h
#define webconn_h



#endif /* webconn_h */

#import <Foundation/Foundation.h>


@interface Webconn : NSObject<NSXMLParserDelegate>   //
+ (NSString *)decodexml:(NSString *)srccodestring;

//NSMutableString * soapResults1;

//@property(nonatomic, retain) NSXMLParser *xmlParser1;
//@property(nonatomic,retain) NSMutableString * soapResults1;

+(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;


//对于返回值的解析函数
+(NSString *)jsondecoderemark:(NSString *)string;
+(NSString *)jsondecoderesult:(NSString *)string;
+(NSString *)jsondecodeyjlsh:(NSString *)string;


+ (NSString *)Xmlappend:(NSString *)dictionjsonvalue params:(NSString *)method params1:(NSString *)namespace params2:(NSString *)urlload;

@end
