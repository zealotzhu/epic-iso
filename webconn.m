//
//  webconn.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/6/27.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "webconn.h"
#import "header.h"
#import "SBJson.h"
#import "CommonFunc.h"
#import "md5.h"
#import "Utility.h"

@implementation Webconn

//@synthesize xmlParser1;               //存储解析后的数据
//@synthesize soapResults1;             //返回结果


+ (NSString *)decodexml:(NSString *)srccodestring{
    
    
    
    //  NSString * returnSoapXML1 = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSData* xmlData = [srccodestring dataUsingEncoding:NSUTF8StringEncoding];
    xmlParser1 = [[NSXMLParser alloc] initWithData: xmlData];
    [xmlParser1 setDelegate:self];
    [xmlParser1 setShouldResolveExternalEntities: YES];
    
    [xmlParser1 parse];//这里就是进行解析的函数调用
    
    //NSLog(@"ddddddddd\n\n");
    return soapResults1;
    
}

+(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
   // NSLog(@"返回的soap内容中，return值是： [%@]\n\n",string);
    
    soapResults1 = string;
}

+(NSString *)jsondecoderesult:(NSString *)string{     //返回解析完成的 V_RESULT 值
    //以下是使用库文件进行json串的解析
    SBJsonParser *parser3 = [[SBJsonParser alloc] init];
    NSError *error1 = nil;
    
    
    NSMutableDictionary *jsonDic4 = [parser3 objectWithString:string error:&error1];//获取根节点 只需要获取一次
    
    // NSMutableDictionary *dicUserInfo4 = [jsonDic objectForKey:@"V_RESULT"];//获取到他的对应节点 倘若没有子节点 只需要 直接进行获取对应值即可
    
    NSDictionary *mm =[jsonDic4 objectForKey:@"V_RESULT" ];
    //NSDictionary *mm1 =[jsonDic4 objectForKey:@"V_REMARK" ];
    //NSDictionary *mm2 =[jsonDic4 objectForKey:@"V_JYLSH" ];
    // NSDictionary *mm3 =[jsonDic4 objectForKey:@"N_JGSJ" ];
    
    NSString *nn = [NSString stringWithFormat:@"%@",mm];
    //NSString *nn1 = [NSString stringWithFormat:@"%@",mm1];
    //NSString *nn2 = [NSString stringWithFormat:@"%@",mm2];
    
    return nn;
}


+(NSString *)jsondecoderemark:(NSString *)string{     //返回解析完成的 V_REMARK 值
    //以下是使用库文件进行json串的解析
    SBJsonParser *parser3 = [[SBJsonParser alloc] init];
    NSError *error1 = nil;
    
    
    NSMutableDictionary *jsonDic4 = [parser3 objectWithString:string error:&error1];//获取根节点 只需要获取一次
    
    // NSMutableDictionary *dicUserInfo4 = [jsonDic objectForKey:@"V_RESULT"];//获取到他的对应节点 倘若没有子节点 只需要 直接进行获取对应值即可
    
    // NSDictionary *mm =[jsonDic4 objectForKey:@"V_RESULT" ];
    NSDictionary *mm1 =[jsonDic4 objectForKey:@"V_REMARK" ];
    // NSDictionary *mm2 =[jsonDic4 objectForKey:@"V_JYLSH" ];
    // NSDictionary *mm3 =[jsonDic4 objectForKey:@"N_JGSJ" ];
    
    // NSString *nn = [NSString stringWithFormat:@"%@",mm];
    NSString *nn1 = [NSString stringWithFormat:@"%@",mm1];
    // NSString *nn2 = [NSString stringWithFormat:@"%@",mm2];
    
    NSString *codejiexi =[CommonFunc textFromBase64String:nn1];
   // NSLog(@"最终解析出来的密文是:[%@]\n",codejiexi);
    
    return codejiexi;
}


+(NSString *)jsondecodeyjlsh:(NSString *)string{     //返回解析完成的 V_JYLSH 值
    //以下是使用库文件进行json串的解析
    SBJsonParser *parser3 = [[SBJsonParser alloc] init];
    NSError *error1 = nil;
    
    
    NSMutableDictionary *jsonDic4 = [parser3 objectWithString:string error:&error1];//获取根节点 只需要获取一次
    
    // NSMutableDictionary *dicUserInfo4 = [jsonDic objectForKey:@"V_RESULT"];//获取到他的对应节点 倘若没有子节点 只需要 直接进行获取对应值即可
    
    // NSDictionary *mm =[jsonDic4 objectForKey:@"V_RESULT" ];
    // NSDictionary *mm1 =[jsonDic4 objectForKey:@"V_REMARK" ];
    NSDictionary *mm2 =[jsonDic4 objectForKey:@"V_JYLSH" ];
    // NSDictionary *mm3 =[jsonDic4 objectForKey:@"N_JGSJ" ];
    
    //NSString *nn = [NSString stringWithFormat:@"%@",mm];
    //NSString *nn1 = [NSString stringWithFormat:@"%@",mm1];
    NSString *nn2 = [NSString stringWithFormat:@"%@",mm2];
    
    return nn2;
}




//自定义一个 xml封装类
+ (NSString *)Xmlappend:(NSString *)dictionjsonvalue params:(NSString *)method params1:(NSString *)namespace params2:(NSString *)urlload{
    
    NSString *decodering3 =[CommonFunc base64StringFromText:dictionjsonvalue];
    //    NSString *decodering2 =@"hahahah";
    
 //   NSLog(@"1111111最终出来的密文是:[%@]\n",decodering3);
    // NSLog(@"1111111最终出来的密文是:[%@]\n",decodestring);
    
    NSString *hello7 =[Md5 getMd5_32Bit:decodering3];     //对拼接以后的字符串进行加密  //在这里就可以使用自己定义的类了
    
    NSString *hello8 =[hello7 stringByAppendingString:@"A801C860DD05418F"];//在后面拼接上字符串秘钥
    
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"%@\">\n"  //这里需要填入命名空间 和方法名
                             "<arg0>%@</arg0>"
                             "<arg1>%@</arg1>"
                             "</%@>"
                             "</soap:Body>\n"
                             "</soap:Envelope>",
                             //@"checkLink",
                             method,
                             
                             //    @"http://tdzt.webservice.com/",
                             //注意 所有的 内容都是封装在 body 里面 的  所以需要自定义 而且传输是使用 xml 传输 的 替代了报文头和报文体简单的传输方式  校验更加严格 需要你提供命名空间 按照标签的形式传
                             // @"http://service.search.gnzq.com",
                             namespace,
                             decodering3,      //传入的  data
                             hello8,
                             method];   //这里的方法名并不是 文档当中的方法名 而是要严格按照接口文档当中的来定义
    //@"checkLink"];  //传入的 sign
    
  //  NSLog(@"调用webserivce的字符串是:\n[%@]\n\n",soapMessage);     //这里是发送过去的所有的报文
    //日志打印
    
    //请求发送到的路径
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //NSURL *url = [NSURL URLWithString:@"http://192.168.201.110:7602/gnzqService/service/PostService"]; //发送的url
    //  NSURL *url = [NSURL URLWithString:@"http://192.168.201.110:7105/ZtServicePort?wsdl"]; //发送的url
    
    NSString *thefinalurl=[Utility urlappendwithmethod:urlload];
    NSURL *url = [NSURL URLWithString:thefinalurl];
    // NSLog(@"[%@]",url);
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //NSLog(@"调用webserivce的url是:[%@]\n,消息长度是[%@]\n",url,msgLength);
    
    
    //以下对请求信息添加属性前四句是必有的，
    [urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: @"http://service.search.gnzq.com" forHTTPHeaderField:@"SOAPAction"];  //此处再次设置命名空间
    //   [urlRequest addValue: @"http://tdzt.webservice.com/" forHTTPHeaderField:@"SOAPAction"];  //此处再次设置命名空间
    
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];  //属性设置
    
   // NSLog(@"全部报文是:[%@]\n\n",urlRequest);
    return urlRequest;
    
}


@end
