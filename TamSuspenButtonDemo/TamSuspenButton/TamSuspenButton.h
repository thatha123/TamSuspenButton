//
//  TamSuspenButton.h
//  TamSuspenButtonDemo
//
//  Created by xin chen on 2017/8/11.
//  Copyright © 2017年 涂怀安. All rights reserved.
//  悬浮按钮

#import <UIKit/UIKit.h>

@interface TamSuspenModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *imgName;
@property(nonatomic,copy)NSString *leftBgkName;

-(instancetype)initWithName:(NSString *)name imgName:(NSString *)imgName leftBgkName:(NSString *)leftBgkName;

@end

typedef void(^ClickBtnBlock)(NSInteger index);

@interface TamSuspenButton : UIView

+(TamSuspenButton *)addSuspenBtnInView:(UIView *)sender rect:(CGRect)rect dataArr:(NSArray <TamSuspenButton *>*)dataArr clickBtnAction:(ClickBtnBlock)clickBtnAction;

@property(nonatomic,assign)BOOL isCanHitView;//YES就是正常情况，NO的话可以触摸对象是父类 【默认为YES】

@end
