//
//  parseYWLYJYGViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/10.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "parseYWLYJYGViewController.h"



@interface parseYWLYJYGViewController ()


@end

@implementation parseYWLYJYGViewController



-(NSMutableArray *) parseRecvData :(NSString*) Translatecode :(NSString *) Parsedata//要传入的交易代码  和要解析的报文
{
    
    [self parseOutData :Translatecode:Parsedata];   //测试数据
    //[outpub showMsg];
    //如何获取对应的值
    
    
    
    NSMutableArray *adicgetdata=[[NSMutableArray alloc] init];//数组1  标题数组
    
    
    NSMutableArray *outputgetdata=[[NSMutableArray alloc] init];//数组 2解析出来的数组值
    
    
    NSMutableArray *lastgetdata=[[NSMutableArray alloc] init];//最终传出的数组
    
    //数组求和 求整除
    NSMutableArray *sumhjArray=[[NSMutableArray alloc] init];  //合计
    NSMutableArray *sumdrddArray=[[NSMutableArray alloc] init];  //当日到达
    NSMutableArray *sumcrddArray=[[NSMutableArray alloc] init];  //次日到达
    NSMutableArray *sumlrysddArray=[[NSMutableArray alloc] init];  //两日以上到达
    
    NSMutableArray *totalsum=[[NSMutableArray alloc] init];

    
    
    for(int getcount=0;getcount<[[outpub getValue:@"COLL":0]intValue];getcount++){
        
        
      
        NSMutableArray *connectgetdata=[[NSMutableArray alloc] init];//获取想要的值
        [outputgetdata addObject:connectgetdata];
        
        
       // [[outputgetdata objectAtIndex:getcount] addObject: [NSString stringWithFormat:@"%d",getcount+1 ]];  //序号不要传
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"V_JGMC" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_HJ" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_DRYGL" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_CRYGL" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_CGLR" :getcount]];
        
        
        //增肌元素为了接下来数组求和
        [sumhjArray addObject:[outpub getValue:@"N_HJ" :getcount]];
        [sumdrddArray addObject:[outpub getValue:@"N_DRYGL" :getcount]];
        
        [sumcrddArray addObject:[outpub getValue:@"N_CRYGL" :getcount]];
        [sumlrysddArray addObject:[outpub getValue:@"N_CGLR" :getcount]];
        

        
    }
    
    
    
   
    
    [totalsum addObject: @"合计"];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumhjArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumdrddArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumcrddArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumlrysddArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    
    [outputgetdata insertObject:totalsum atIndex:0];
    NSLog(@"sumArray[%@]",totalsum);
    //显示合计结束
    

    
    
    //数组首个元素插入标题
    NSMutableArray *childgetdata=[[NSMutableArray alloc] init];//子标题 数组
    [childgetdata addObject:@"合计"];
    [childgetdata addObject:@"当日到达"];
    [childgetdata addObject:@"次日到达"];
    [childgetdata addObject:@"两日以上到达"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:childgetdata,[NSString stringWithFormat:@"%@",@"寄递全程时限预测到达投递部的量"], nil];
   // [[outputgetdata objectAtIndex:0] addObject:aDic];
    [adicgetdata addObject:@"机构名称"];
    [adicgetdata addObject:aDic];
    
    
    
    
    //最终数组添加两个数组作为值
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
