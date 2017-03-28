//
//  parseSSXXFKLViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/10.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "parseSSXXFKLViewController.h"

@interface parseSSXXFKLViewController ()

@end

@implementation parseSSXXFKLViewController



-(NSMutableArray *) parseRecvData :(NSString*) Translatecode :(NSString *) Parsedata//要传入的交易代码  和要解析的报文
{
    
    [self parseOutData :Translatecode:Parsedata];   //测试数据
    //[outpub showMsg];
    //如何获取对应的值
    
    
    
    NSMutableArray *adicgetdata=[[NSMutableArray alloc] init];//数组1  标题数组
    
    
    NSMutableArray *outputgetdata=[[NSMutableArray alloc] init];//数组 2解析出来的数组值
    
    
    NSMutableArray *lastgetdata=[[NSMutableArray alloc] init];//最终传出的数组
    
    
    //数组求和 求整除
    NSMutableArray *sumzjttjsArray=[[NSMutableArray alloc] init];  //总计妥投件数
    NSMutableArray *sumssfkjsArray=[[NSMutableArray alloc] init];  //实时反馈件数
     NSMutableArray *totalsum=[[NSMutableArray alloc] init];
    
    for(int getcount=0;getcount<[[outpub getValue:@"COLL":0]intValue];getcount++){
        
        
        
        NSMutableArray *connectgetdata=[[NSMutableArray alloc] init];//获取想要的值
        [outputgetdata addObject:connectgetdata];
        
        
        // [[outputgetdata objectAtIndex:getcount] addObject: [NSString stringWithFormat:@"%d",getcount+1 ]];  //序号不要传
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"V_JGMC" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_FKS" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[outpub getValue:@"N_YJSSUM" :getcount]];
        [[outputgetdata objectAtIndex:getcount] addObject:[[outpub getValue:@"RATE" :getcount]stringByAppendingString:@"%"]];
        
        
        //增加元素为了接下来数组求和
        [sumzjttjsArray addObject:[outpub getValue:@"N_FKS" :getcount]];
        [sumssfkjsArray addObject:[outpub getValue:@"N_YJSSUM" :getcount]];
       
        

        
        
    }
    
    
    
    //这里是添加一行数组显示合计
    float ssfklaverge =[[[sumzjttjsArray copy] valueForKeyPath:@"@sum.floatValue"]floatValue ];
    float ssfklaverge2=[[[sumssfkjsArray copy] valueForKeyPath:@"@sum.floatValue"]floatValue];
    float ssfklzhanbi=ssfklaverge2/ssfklaverge;
    NSLog(@"占比[%0.4f]",ssfklzhanbi);
    
    [totalsum addObject: @"合计"];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumzjttjsArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    [totalsum addObject: [NSString stringWithFormat:@"%@",[[sumssfkjsArray copy] valueForKeyPath:@"@sum.floatValue"]]];
    
    
    [totalsum addObject: [NSString stringWithFormat:@"%0.2f%@",ssfklzhanbi*100,@"%"]]; //占比
    
    
    [outputgetdata insertObject:totalsum atIndex:0];  //插入首个位置
    NSLog(@"sumArray[%@]",totalsum);
    //显示合计结束
    

    
    
    
    //数组首个元素插入标题
    //    NSMutableArray *childgetdata=[[NSMutableArray alloc] init];//子标题 数组
    //    [childgetdata addObject:@"合计"];
    //    [childgetdata addObject:@"当日到达"];
    //    [childgetdata addObject:@"次日到达"];
    //    [childgetdata addObject:@"两日以上到达"];
    //    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:childgetdata,[NSString stringWithFormat:@"%@",@"寄递全程时限预测到达投递部的量"], nil];
    // [[outputgetdata objectAtIndex:0] addObject:aDic];
    [adicgetdata addObject:@"机构名称"];
    [adicgetdata addObject:@"总计妥投件数"];
    [adicgetdata addObject:@"实时反馈件数"];
    [adicgetdata addObject:@"实时反馈率"];
    
    //    [adicgetdata addObject:aDic];
    
    
    
    
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




//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
