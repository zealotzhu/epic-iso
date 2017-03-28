//
//  customsixlinecell.m
//  EPostPickUpByCustomer
//
//  Created by lzb on 16/7/20.
//  Copyright © 2016年 gotop. All rights reserved.
//

#import "Customsixlinecell.h"

@implementation Customsixlinecell


+(instancetype)Customsixlinecell {
    Customsixlinecell *cell = [[[NSBundle mainBundle]loadNibNamed:@"Customsixlinecell" owner:nil options:nil]lastObject];
    
    return cell;
}
@end