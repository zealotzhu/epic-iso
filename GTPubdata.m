//
//  GTPubdata.m
//  GTChinaPostPak
//
//  Created by zsm on 13-12-3.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import "GTPubdata.h"

@implementation GTPubdata
-(void)inits
{
    body=[[NSMutableArray alloc] init];
    head=[[NSMutableArray alloc] init];
    child=[[NSMutableArray alloc] init];
   // [child addObject:[[GTPubdata alloc]init]];
    row_num=0;
    col_num=0;
    
}
//-(void) dealloc
//{
//   // NSLog(@"pub dealoc");
//    [head removeAllObjects];
//    [head release];
//    for(int i=0;i<[body count];i++)
//        [[body objectAtIndex:i] removeAllObjects];
//    [body removeAllObjects];
//    [body release];
//    [child removeAllObjects];
//    [child release];
//    [super dealloc];
//}

-(void)setValue:(NSString *)name :(NSString *) val :(int) col
{
    
    //NSLog(@"11111setValuehead[%@]body[%@][%@][%d]",head,body,val,col);
    
    
    NSUInteger col_index=[head indexOfObject:name];
    
    if(NSNotFound==col_index){//纵向结构 没找到就加一行
     [head addObject:name];
        
        /*
         此时head 变成 coll body 是4
         COLL
         )]body[(
         (
         4
         )

         */
    }
    if(val!=nil)
        [[body objectAtIndex:col] addObject:val];
    else
         [[body objectAtIndex:col] addObject:@""];
    
    //NSLog(@"22222setValuehead[%@]body[%@][%@][%@]",head,body,head[0],body[0]);
    
}
-(void)setpValue:(NSString *)name :(GTPubdata *) val :(int) col
{
  /*  int col_index=[head indexOfObject:name];
    if(NSNotFound==col_index){//纵向结构 没找到就加一行
        [head addObject:name];
    }
   */
   // [child addObject:[[GTPubdata alloc]init] ];
    //[[child objectAtIndex:col] addObject:val];
    
    [child addObject:val];
  //  NSLog(@"==set==%@",child);
    
}
-(NSString *)getValue:(NSString *)name :(int) col   //先查找父节点 父节点没找到再去查找字节点
{
    NSString *val;
    NSUInteger col_index=[head indexOfObject:name];
    if(NSNotFound==col_index)
    {
        
        //NSLog(@"没找到===%@",val);
        for (int i=0; i<[child count]; i++) {
            //NSLog(@"子结点%d=========",i);
            GTPubdata *cld=[child objectAtIndex:i];
            if([cld getValue:name :col]!=nil)
                val=[NSString stringWithFormat:@"%@",[cld getValue:name :col]];
            else
                val=[NSString stringWithFormat:@""];
     
        }
    }
    else
    {
     if([[body objectAtIndex:col] objectAtIndex:col_index]!=nil)
        val=[NSString stringWithFormat:@"%@",[[body objectAtIndex:col] objectAtIndex:col_index]];
    else
        val=[NSString stringWithFormat:@""];
       // NSLog(@"zhaodao==%@",val);
    }
    return  val;
}

-(NSMutableArray *)getRow:(int) row
{
    NSMutableArray *val;//=[[NSMutableArray alloc]init];
    val=[body objectAtIndex:row];
    return val;
}

-(NSMutableArray *)getCollValue:(NSString *) name
{
    NSMutableArray *val=[[NSMutableArray alloc]init];
    NSUInteger col_index=[head indexOfObject:name];
    if(NSNotFound==col_index)
    {
        for (int i=0; i<[child count]; i++) {
            //NSLog(@"子结点%d=========",i);
            GTPubdata *cld=[child objectAtIndex:i];
            for (int j=0; j<[cld count]; j++) {
                 [val addObject:[cld getValue:name :j]];
            }
        }
    }
    else
    {
        for (int i=0; i<[body count]; i++) {
            
            [val addObject:[self getValue:name :i]];
        }
    }
  //  NSLog(@"get coll====%@",val);
    return val;
}
-(void)addata
{
   // NSLog(@"body[%@]",body);
    row_num++;
    NSMutableArray *arry=[[NSMutableArray alloc]init];
    [body addObject:arry ];  //这里的body 又增加了一个数组
  //  NSLog(@"这里的body 又增加了一个数组[%@]",body);
   // [arry release];
}
-(int) count
{
    return  [body count];
}
-(GTPubdata *) getChild:(int) i
{
    if (i<row_num) {
        return [child objectAtIndex:i];
    }
    else{
        return NULL;
    }
}
-(void)addhead:(NSString *)val
{
    [head addObject:val];
}
-(void)addata:(NSString *)val
{
    [self addata];
    NSArray *dy=[val componentsSeparatedByString:@"#|"];
    for (int i=0; i<[dy count]; i++) {
        [[body objectAtIndex:row_num-1] addObject:[dy objectAtIndex:i]];
    }
   }


-(void)getrownum{
    
 //   NSLog(@"bbbbodddy");
//    return [[body objectAtIndex:0] intValue];
//    //return [body objectAtIndex:1];
//    //return [body objectAtIndex:2];
}



-(void) showMsg
{
   // NSLog(@"/////////////////////////////////////////\n\nhead=%@",head);
    for(int i=0;i<row_num;i++)
       // NSLog(@"body ［%@］row_num [%d] val=%@ 结束\n",body,row_num,[body objectAtIndex:i]);
   
    for (int i=0; i<[child count]; i++) {
      //   NSLog(@"子结点%d=========[%d]",i,[child count]);
        [[child objectAtIndex:i] showMsg];
      //  NSLog(@"child %@",child);
    }
    
   // NSLog(@"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
}
@end
