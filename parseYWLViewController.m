//
//  parseYWLViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/10.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "parseYWLViewController.h"
//#import "YWLTJViewController.h"
@interface parseYWLViewController ()

@end

@implementation parseYWLViewController



-(NSMutableArray *) parseRecvData :(NSString*) Translatecode :(NSString *) Parsedata//要传入的交易代码  和要解析的报文
{
    
    [self parseOutData :Translatecode:Parsedata];   //测试数据
    //[outpub showMsg];
    //如何获取对应的值
    
    
    
    NSMutableArray *adicgetdata=[[NSMutableArray alloc] init];//数组1  标题数组
    
    
    NSMutableArray *outputgetdata=[[NSMutableArray alloc] init];//数组 2解析出来的数组值
    
    
    NSMutableArray *lastgetdata=[[NSMutableArray alloc] init];//最终传出的数组
    
    
    NSLog(@"个数[%d]",[[outpub getValue:@"COLL":0]intValue]);
    
    
    
    //数组求和 求整除
    NSMutableArray *sumjkjsArray=[[NSMutableArray alloc] init];  //进口件数
    NSMutableArray *sumttjsArray=[[NSMutableArray alloc] init];  //妥投件数
    NSMutableArray *sumjkcsArray=[[NSMutableArray alloc] init];  //进口城市
    NSMutableArray *sumttcsArray=[[NSMutableArray alloc] init];  //妥投城市
    NSMutableArray *sumjkncArray=[[NSMutableArray alloc] init];  //进口农村
    NSMutableArray *sumttncArray=[[NSMutableArray alloc] init];  //妥投农村
    NSMutableArray *totalsum=[[NSMutableArray alloc] init];
    
    
    //获取机构编号和级别
    NSMutableArray *ywltjjgbhArray=[[NSMutableArray alloc] init];
    NSMutableArray *ywltjjbArray=[[NSMutableArray alloc] init];
    NSMutableArray *ywltjdickeyArray=[[NSMutableArray alloc] init];
    NSMutableArray *sendoutdic=[[NSMutableArray alloc] init];//最终传出来的数组  包含机构编号 和 级别
    
    
    for(int getcount=0;getcount<[[outpub getValue:@"COLL":0]intValue];getcount++){
        
        
        
        NSMutableArray *connectgetdata=[[NSMutableArray alloc] init];//获取想要的值
        [outputgetdata addObject:connectgetdata];
        
        
        // [[outputgetdata objectAtIndex:getcount] addObject: [NSString stringWithFormat:@"%d",getcount+1 ]];  //序号不要传
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"V_JGMC" :getcount]];
        
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_YJSSUM" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_LLTTSSUM" :getcount]];
        
        
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_CSYJSSUM" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_CSLLTTSSUM" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[[outpub getValue:@"CSZB" :getcount]stringByAppendingString:@"%"]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_NCYJSSUM" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_NCLLTTSSUM" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[[outpub getValue:@"NCZB" :getcount]stringByAppendingString:@"%"]];
        
        
        //增加元素为了接下来数组求和
        [sumjkjsArray addObject:[outpub getValue:@"N_YJSSUM" :getcount]];
        [sumttjsArray addObject:[outpub getValue:@"N_LLTTSSUM" :getcount]];
        
        [sumjkcsArray addObject:[outpub getValue:@"N_CSYJSSUM" :getcount]];
        [sumttcsArray addObject:[outpub getValue:@"N_CSLLTTSSUM" :getcount]];
        [sumjkncArray addObject:[outpub getValue:@"N_NCYJSSUM" :getcount]];
        [sumttncArray addObject:[outpub getValue:@"N_NCLLTTSSUM" :getcount]];
        
        
        //以下是为了获取级别
        [ywltjjgbhArray addObject:[outpub getValue:@"N_JB" :getcount]];
        [ywltjjbArray addObject:[outpub getValue:@"C_JGBH" :getcount]];
        [ywltjdickeyArray addObject:[NSString stringWithFormat:@"%d", getcount]];
        
        
    }
    
    
    
    
    
    
    //这里是添加一行数组显示合计
    float csaverge =[[[sumjkcsArray copy] valueForKeyPath:@"@sum.floatValue"]floatValue ];
    float csaverge2=[[[sumttcsArray copy] valueForKeyPath:@"@sum.floatValue"]floatValue];
    float cszhanbi=csaverge2/csaverge;
    NSLog(@"占比[%0.4f]",cszhanbi);
    
    float ncaverge =[[[sumjkncArray copy] valueForKeyPath:@"@sum.floatValue"]floatValue ];
    float ncaverge2=[[[sumttncArray copy] valueForKeyPath:@"@sum.floatValue"]floatValue];
    float nczhanbi=ncaverge2/ncaverge;
    NSLog(@"占比[%0.4f]",nczhanbi);
    
    [totalsum addObject: @"合计"];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumjkjsArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumttjsArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    
    
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumjkcsArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumttcsArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    
    [totalsum addObject: [NSString stringWithFormat:@"%0.2f%@",cszhanbi*100,@"%"]]; //占比
    
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumjkncArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumttncArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    
    [totalsum addObject: [NSString stringWithFormat:@"%0.2f%@",nczhanbi*100,@"%"]]; //占比 //占比
    
    [outputgetdata insertObject:totalsum atIndex:0];
    NSLog(@"sumArray[%@]",totalsum);
    //显示合计结束
    
    
    
    //数组首个元素插入标题
    NSMutableArray *childgetdata=[[NSMutableArray alloc] init];//子标题 数组
    [childgetdata addObject:@"进口"];
    [childgetdata addObject:@"妥投"];
    [childgetdata addObject:@"占比"];
    //[childgetdata addObject:@"两日以上到达"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:childgetdata,[NSString stringWithFormat:@"%@",@"其中城市"], nil];
    
    NSMutableArray *childgetdata1=[[NSMutableArray alloc] init];//子标题 数组
    [childgetdata1 addObject:@"进口"];
    [childgetdata1 addObject:@"妥投"];
    [childgetdata1 addObject:@"占比"];
    //[childgetdata addObject:@"两日以上到达"];
    NSDictionary *aDic1 = [NSDictionary dictionaryWithObjectsAndKeys:childgetdata,[NSString stringWithFormat:@"%@",@"其中农村"], nil];
    
    
    // [[outputgetdata objectAtIndex:0] addObject:aDic];
    [adicgetdata addObject:@"机构名称"];
    [adicgetdata addObject:@"进口件数"];
    [adicgetdata addObject:@"妥投件数"];
    
    [adicgetdata addObject:aDic];
    [adicgetdata addObject:aDic1];
    
    
    //获取机构编号 和 级别
    [sendoutdic addObject:ywltjjgbhArray];
    [sendoutdic addObject:ywltjjbArray];
    [sendoutdic addObject:ywltjdickeyArray];
    
//    NSLog(@"111V_JGMC[%@]",ywltjjgbhArray);
//    NSLog(@"222N_HJ[%@]",ywltjjbArray);
//    NSLog(@"333N_HJ[%@]",ywltjdickeyArray);
    

    
    
    
    //最终数组添加两个数组作为值
    [lastgetdata addObject:sendoutdic];
    [lastgetdata addObject:adicgetdata];  //添加标题数组
    [lastgetdata addObject:outputgetdata];//添加传出数组
    
    
    
    return lastgetdata;
    /*
     //如何获取对应的值
     NSMutableArray *getc_jgbh =[[NSMutableArray alloc] init];//获取想要的值
     for(int getcount=0;getcount<[[outpub getValue:@"COLL":0]intValue];getcount++){
     
     [getc_jgbh addObject:[outpub getValue:@"C_JGBH" :getcount]];
     
     }
     NSLog(@"机构编号是[%@]",getc_jgbh);
     
     //如何获取对应的值
     NSMutableArray *getv_jgmc =[[NSMutableArray alloc] init];//获取想要的值
     for(int getcount=0;getcount<[[outpub getValue:@"COLL":0]intValue];getcount++){
     
     [getv_jgmc addObject:[outpub getValue:@"V_JGMC" :getcount]];
     
     }
     NSLog(@"机构名称是[%@]",getv_jgmc);
     */
    
    
    
    /*
     NSLog(@"getrownum[%@]",[outpub getValue:@"COLL":0]);  //注意这个是我自己写的方法   根据 coll来进行查找 直接找对应值 这里获取到的是服务器返回的
     */
    
    /*
     //这个是朱哥的方法 是先去获取子节点去进行遍历和获取
     NSLog(@"2222222count[%d][%d]",[outpub count],[[outpub getChild:0]count]);
     for(int pubcount=0;pubcount<[outpub count];pubcount++ ){
     GTPubdata * hello = [outpub getChild:pubcount];
     for(int j=0;j<[hello count];j++){
     NSLog(@"11111111111[%@]",[hello getValue:@"N_FHM" :j]); //1
     }
     }*/
    
}




@end
