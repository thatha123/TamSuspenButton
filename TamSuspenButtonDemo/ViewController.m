//
//  ViewController.m
//  TamSuspenButtonDemo
//
//  Created by xin chen on 2017/8/11.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import "ViewController.h"
#import "TamSuspenButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TamSuspenModel *suspenModel1 = [[TamSuspenModel alloc]initWithName:@"投注记录" imgName:@"icon-record" leftBgkName:@"record_bg"];
    TamSuspenModel *suspenModel2 = [[TamSuspenModel alloc]initWithName:@"玩法介绍" imgName:@"icon_introduction" leftBgkName:@"introduction_bg"];
    [TamSuspenButton addSuspenBtnInView:self.view rect:CGRectMake(self.view.frame.size.width-50-15, self.view.frame.size.height-50-44-50, 50, 50) dataArr:@[suspenModel1,suspenModel2] clickBtnAction:^(NSInteger index) {
        NSLog(@"选中了:%zd",index);
    }];

    
}


@end
