//
//  GTcomm.m
//  GTChinaPostPak
//
//  Created by zsm on 13-12-6.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import "GTcomm.h"

@implementation GTcomm
-(void)inits
{
   
    pub=[[GTPubdata alloc]init];     //首先初始化一个pubdata 类
    //NSString *plist=[[NSBundle mainBundle]pathForResource:@"serparaini" ofType:@"plist"];
    
     NSString *plist=[[NSBundle mainBundle]pathForResource:@"separate" ofType:@"plist"];
    
     NSLog(@"\n\nplist name is [%@]",plist);  //获取文件名
    
    
    conf=[[NSMutableDictionary alloc]initWithContentsOfFile:plist];   //再初始化一个  conf 文件
 //      NSLog(@"\n\n conf name is [%@]",conf);
    
 //   NSLog(@"conf.allKeys[%@]\nconf.allValues[%@]",conf.allKeys,conf.allValues);
                                                                        /*  key     values
                                                                                610004,
                                                                                620004,
                                                                                600086,
                                                                                610212,
                                                                                620009,
                                                                                610003,
                                                                                620008,
                                                                                620002,
                                                                                610002,
                                                                                620007,
                                                                                620001,
                                                                                610209,
                                                                                610208

                                                                                
                                                                                610209 =     {
                                                                                "HEAD_IN" =         {
                                                                                0 = "V_SFMC";
                                                                                1 = "V_DSMC";
                                                                                2 = "V_XSMC";
                                                                                3 = "V_GJZ";
                                                                                4 = "V_DBXX";
                                                                                5 = "V_JPSJD";
                                                                                6 = "V_JPSWD";
                                                                                7 = "N_START";
                                                                                8 = "N_END";
                                                                                };
                                                                                "HEAD_OUT" =         {
                                                                                COLL =             {
                                                                                0 = "V_JGBH";
                                                                                1 = "V_ZQDMC";
                                                                                2 = "V_LXDZ";
                                                                                3 = "V_LXFS";
                                                                                4 = "C_WDLX";
                                                                                5 = "V_YYSJ";
                                                                                6 = "V_XZQH";
                                                                                7 = "V_TDJGBH";
                                                                                };
                                                                                };
                                                                                };
                                                                                一个交易号是一个 dictinory 对应两个  一个 head_in 一个head_out  作为key
                                                                                head_in 也是一个 dictinory 对应多个参数 分别是 0 1 2 3 4  作为key 
                                                                                head_out 也是一个 dictinory  但是对应的是 coll coll也是一个 dictinory 对应多个传出参数 
                                                                                这些都是提前设置好的
                                                                                
                                                                                
                                                                                
                                                                                

                                                                                */
    
    /*
    NSString *in;
    NSString *out;
    GTPubdata *pub;
    NSMutableDictionary *conf;
    NSString *resultc;
    NSString *errinfo;

    */
}
//-(void) dealloc
//{
//    [pub release];
//    [conf release];
//    //[resultc release];
//   // [errinfo release];
//    [super dealloc];
//}

-(GTPubdata *) parseOut:(NSString *)code :(NSString *)msg     //接下来查看的是解析类parseOut
{
    
  //  NSLog(@"\n接下来查看的是解析类parseOut \n code[%@]  msg[%@]",code,msg);
    
    
    
   NSMutableDictionary *headOut=[[conf objectForKey:code] objectForKey:@"HEAD_OUT"];   //再次定义一个字典类
   
  // NSLog(@"[conf objectForKey:code] \n[%@]\n[[conf objectForKey:code] objectForKey:@HEAD_OUT]\n[%@]",[conf objectForKey:code],[[conf objectForKey:code] objectForKey:@"HEAD_OUT"]);
    
    /*
     
     //最后得到的 需要传出的值 是head_out 是 一个字典对应关系  0 = "N_FHM";  [[conf objectForKey:code] objectForKey:@"HEAD_OUT"]使用这个获取
     [[conf objectForKey:code] objectForKey:@HEAD_OUT]
     [{
     0 = "N_FHM";
     }]
     */
    
    
  
    //字符串分割
    NSArray *lst=[msg componentsSeparatedByString:@"#|"];

    resultc=[NSString stringWithFormat:@"%@",[lst objectAtIndex:0] ];//第4个开始是参数  resultc  这个是结果判断成功值
    
    //NSLog(@"lst[%@]\n\nresultc[%@]",lst,resultc);
    
   // NSLog(@"parseIn_begin");
   // [pub release];//初始化一下
    if([resultc isEqualToString:@"0000"])
    {
        
        ///*
        if([lst count]>5){    //这个暂时不需要判断
       //     NSLog(@"===%@",[lst objectAtIndex:5]);
            if([[lst objectAtIndex:5] isEqualToString:@"00"])//第六个参数00表示没有数据
            {
                resultc=[NSString stringWithFormat:@"%@",@"0003" ];
                 pub=[self parseErr:lst];
                return pub;
            }
        }
         //*/
         
        pub=[self parseDetail: headOut : lst: 4: 1];
    }
    else{
        errinfo=[NSString stringWithFormat:@"%@",[lst objectAtIndex:2]];   //否则获取第三个参数 显示错误原因
        pub=[self parseErr:lst];
    }
  //  NSLog(@"parseIn_end");
  //  [pub showMsg];
    return pub;
}

-(GTPubdata *) parseErr :(NSArray *)data
{
    GTPubdata *parse_pub=[[GTPubdata alloc]init];
    [parse_pub inits]; 
    return parse_pub;
}

-(GTPubdata *) parseDetail:(NSMutableDictionary *)head :(NSArray *)data :(int) index :(int) num
//传入的是要得到的传出值0 = "N_FHM";  以及整个解析完的数组
/*
 head 
 =     {
 0 = "N_FHM";
 };

 
 lst[(
 0000,
 1100000011,
 "",
 000029,
 1
 )]
 */

{
    GTPubdata *parse_pub=[[GTPubdata alloc]init];
    NSArray *keys=[head allKeys];  //这个就是获取要解析到的 所有字段的 key  0 1 2 ｀｀｀
   // NSLog(@"数据条数==[%d],keys=[%@]",num,keys);   //数据条数默认写死的是 1
    
    [parse_pub inits];   //注册初始化  初始化 体  头 和子节点
    
    for (int k=0; k<num; k++) {   //如果k 小于 num(1) 就累加 因为默认写死是1 所以 row_num++＝＝1;
     [parse_pub addata];
        

        
//以下是对于整个head_out 的｛NSArray *keys=[head allKeys];
      for (int i=0; i<[keys count]; i++) {             //如果i 小于 要得到的传出值的话  i 就累加 所以i 等于传出值的个数
       
//          NSString *key_name=[keys objectAtIndex:i];
//          NSLog(@"key_name=%@", key_name);  //key_name=0  1  2  3  等等
        
          
          if ([head objectForKey:@"COLL"]!=nil) {     //这里的 head 是一个字典 {0 = "N_FHM";}  也就是所有要得到的传出字段的集合
            //不是集合的话直接截取 然后副值
            NSMutableDictionary *child=[head objectForKey:@"COLL"];
              //如果包含 coll 的话 就获取对应的字段  例如
              /*
               child =     {
               0 = "N_FHMjj";
               1 = "N_FHsj";
               };
               */
              
            NSString *count_num=[[data objectAtIndex:index] stringByReplacingOccurrencesOfString:@"#*" withString:@""];  //为什么从第四个开始？
            //在报文头和报文体中各数据域之间以“#|”分隔。如果报文体中有集合嵌套数据，以“#*”标识  这个要替换掉 所以coll是由于有循环数据才会出现
              
           // NSLog(@"coll=%@",child);
           [parse_pub setValue: @"COLL" : count_num : k ];   //这个 count_num  就是返回报文上面的值 也是接口返回的 4  
              
           /*
            -(void)setValue:(NSString *)name :(NSString *) val :(int) col
            {
            NSUInteger col_index=[head indexOfObject:name];  //根据所属名字找到coll的对应位置 
            
            if(NSNotFound==col_index){//纵向结构 没找到就加一行
            [head addObject:name];  head 添加一行 COLL
            }
            if(val!=nil)
            [[body objectAtIndex:col] addObject:val]; 如果不为空报文体在第一行增加 count_num
            else
            [[body objectAtIndex:col] addObject:@""];
            }

            */
            GTPubdata *childpub=[self parseDetail:child:data:index+1:[count_num intValue]];
           // [childpub showMsg];
            [parse_pub setpValue:@"COLL" :childpub :k];
              
              /*
              -(void)setpValue:(NSString *)name :(GTPubdata *) val :(int) col
              {
                [child addObject:val];
                  
              }*/

              
          //  parse_pub=childpub;
           // [childpub release];
        
          
          }else
        {//直接开始截取GT_IMP_NAME
            NSString *ints=[NSString stringWithFormat:@"%d",i];    //传出值的个数  0   head : 0 = "N_FHM";
             NSString *key_name=[head objectForKey:ints];     // i 在这里变成了 key值 可以用来获得value就是字段名  i 从0 开始
        //    NSLog(@"\n\nname=%@  val=%@ i=%d", key_name,[data objectAtIndex:index],i);   //index =4  name=N_FHM  val=1 i=0
           
            NSString *value=[[data objectAtIndex:index]stringByReplacingOccurrencesOfString:@"#*" withString:@""];  //将#* 全部替换
        //    NSLog(@"[%d-%d]%@=%@",i,k,key_name,value);  //[0-0]N_FHM=1
            
            [parse_pub setValue:key_name :value : k ];    //index  是个数 从4 开始遍历每一个值
            /*
             -(void)setValue:(NSString *)name :(NSString *) val :(int) col
             {
             NSUInteger col_index=[head indexOfObject:name];  //根据所属名字找到coll的对应位置
             
             if(NSNotFound==col_index){//纵向结构 没找到就加一行
             [head addObject:name];  head 添加一行 COLL
             }
             if(val!=nil)
             [[body objectAtIndex:col] addObject:val]; 如果不为空报文体在第一行增加 count_num
             else
             [[body objectAtIndex:col] addObject:@""];
             }
             
             */
            // 将字段名 和 值对应起来
            
            
           index++;
        }
      }
    }
   // [parse_pub showMsg];
    return parse_pub;
}
-(NSString *)parseIn:(NSString *)code :(GTPubdata *)pubin
{
      NSString *sfdm=[[NSUserDefaults standardUserDefaults]objectForKey:@"GT_PostSfdm"];
    if(sfdm==nil) sfdm=@"1100000011";
    NSString *msgHead=[[NSString alloc] initWithFormat:@"%@#|0022#|12345#|20121212120000#|%@#|",code,sfdm];
    NSMutableString *msgBody=[[NSMutableString alloc]init];
    NSMutableDictionary *headInt=[[conf objectForKey:code] objectForKey:@"HEAD_IN"];
     NSArray *keys=[headInt allKeys];
   // NSLog(@"parsein====%@",keys);
    for (int i=0; i<[pubin count]; i++) {
        for (int j=0; j<[keys count]; j++) {
            if ([headInt objectForKey:@"COLL"]!=nil) {
                
            }
            else{
                NSString *ints=[NSString stringWithFormat:@"%d",j];
                NSString *key_name=[headInt objectForKey:ints];
                NSString *val=[pubin getValue:key_name :i];
           //     NSLog(@"----%@=%@",key_name,val);
                [msgBody appendFormat:@"%@#|",val];
            }
        }
    }
    if([msgBody length]>2){
   // NSLog(@"%@=====长度＝%06d",[msgBody substringToIndex:[msgBody length]-2],[msgBody length]+[msgHead length]-2);
        int len=[msgBody length]+[msgHead length]+6;
        NSString *str=[NSString stringWithFormat:@"%@%06d#|%@",msgHead,len,[msgBody substringToIndex:[msgBody length]-2]];
         return str;
    }
    else
    {
        int len=[msgBody length]+[msgHead length]+6;
        NSString *str=[NSString stringWithFormat:@"%@%06d#|",msgHead,len];
         return str;
    }
   
}

-(NSString *)resultCode
{
    NSString *res=[NSString stringWithFormat:@"%@",resultc];
    return res;
}
-(NSString *)getErrorInfo
{
    NSString *res=[NSString stringWithFormat:@"%@",errinfo];
    return res;
}

@end
