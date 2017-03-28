//
//  GTdelegeRecv.m
//  GTpostpackage
//
//  Created by zsm on 13-12-19.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import "GTdelegeRecv.h"

@implementation GTdelegeRecv
@synthesize outData;
-(void) initEnv
{
    commData=[[GTcomm alloc]init];
    [commData inits];
    
//    send=[[GTsocketViewController alloc]init];
//    send.delegate=self;

}
- (void)LoadData:(UIView *)view
{
    [self initEnv];
}

//在这增加
//-(void) parseRecvData
//{
//    //NSLog(@"recvData====");
//}
//
//-(void) parseRecvData :(NSString*) Translatecode
//{
//}
//-(NSMutableArray *) parseRecvData :(NSString*) Translatecode :(NSString *) Parsedata
//{
//}

-(void) parseRecvErr
{

}
-(void) pubrecverr
{
    // NSLog(@"recvERR====");
}
-(void) dealloc
{
   // NSLog(@"delegerecv dealoc");
    //[super dealloc];
    
    //[outpub release];
    //[commData release];
}
-(void)parseOutData:(NSString *)scode :(NSString *)msg
{
    
    outpub=[commData parseOut:scode :msg ];
    
    //NSLog(@"123[%@][%@]",scode,msg);
}

-(NSString *)parseInData:(NSString *)scode :(GTPubdata *)data{
    return [commData parseIn:scode :data];
}

//-(void) onrecvdone
//{
//   // NSLog(@"\n\n哈哈哈哈\n");
//    [self parseRecvData];
//    self.outData=outpub;//||[[commData resultCode] isEqualToString:@"0003"]
//    if([[commData resultCode] isEqualToString:@"0000"]){
//        [_delegate pubrecvdone];
//    }else{
//        [self parseRecvErr ];
//         [_delegate pubrecverr];
//    }
//}

@end
