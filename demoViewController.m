//
//  demoViewController.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 17/1/9.
//  Copyright © 2017年 gotop. All rights reserved.
//

#import "demoViewController.h"

@interface demoViewController ()

@end

@implementation demoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *recvcode=@"620002";
    NSString *recvdata=@"0000#|1100000011#|#|000029#|#*4#|100#|2#|10000100#|北京市#|101#|2#|31000100#|浙江省#|102#|2#|35000100#|福建省#|103#|2#|45000100#|河南省#*";
    
    GTPubdata *outpub;
    GTcomm *commData;
    
    outpub=[commData parseOut:recvcode :recvdata ];
    
    //如何获取对应的值
    NSMutableArray *getN_FHM =[[NSMutableArray alloc] init];//获取想要的值
    for(int getcount=0;getcount<[[outpub getValue:@"COLL":0]intValue];getcount++){
        
        //NSLog(@"11111111111[%@]",[outpub getValue:@"N_FHM" :getcount]);
        [getN_FHM addObject:[outpub getValue:@"N_FHM" :getcount]];
        
    }
    NSLog(@"getN_FHM[%@]",getN_FHM);

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
