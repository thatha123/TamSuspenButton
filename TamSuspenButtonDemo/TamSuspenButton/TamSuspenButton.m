//
//  TamSuspenButton.m
//  TamSuspenButtonDemo
//
//  Created by xin chen on 2017/8/11.
//  Copyright © 2017年 涂怀安. All rights reserved.
//

#import "TamSuspenButton.h"

@implementation TamSuspenModel

-(instancetype)initWithName:(NSString *)name imgName:(NSString *)imgName leftBgkName:(NSString *)leftBgkName
{
    if (self == [super init]) {
        self.name = name;
        self.imgName = imgName;
        self.leftBgkName = leftBgkName;
    }
    return self;
}

@end

#define TamLabelFont [UIFont systemFontOfSize:16]

@interface TamSuspenButton()

@property(nonatomic,strong)NSArray *dataArr;//模型数组
@property(nonatomic,strong)UIView *parentView;//父视图
//@property(nonatomic,strong)UIView *bgkView;//背景
@property(nonatomic,assign)CGRect btnRect;
@property(nonatomic,strong)UIButton *openAndCloseBtn;

@property(nonatomic,copy)ClickBtnBlock clickBtnBlock;

@end

@implementation TamSuspenButton

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return self.isCanHitView ? hitView : nil;
    }
    return hitView;
}

+(TamSuspenButton *)addSuspenBtnInView:(UIView *)sender rect:(CGRect)rect dataArr:(NSArray <TamSuspenButton *>*)dataArr clickBtnAction:(ClickBtnBlock)clickBtnAction
{
    
    TamSuspenButton *suspenBtn = [[TamSuspenButton alloc]init];
    suspenBtn.isCanHitView = YES;
    suspenBtn.clickBtnBlock = clickBtnAction;
    suspenBtn.btnRect = rect;
    suspenBtn.dataArr = dataArr;
    suspenBtn.parentView = sender;
    suspenBtn.hidden = YES;
    suspenBtn.frame = sender.bounds;
    suspenBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [sender addSubview:suspenBtn];
    
    [suspenBtn setupUI];
    
    return suspenBtn;
}

/**
 *  初始化UI
 */
-(void)setupUI
{
    UIButton *openAndCloseBtn = [[UIButton alloc]init];
    self.openAndCloseBtn = openAndCloseBtn;
    [openAndCloseBtn setImage:[UIImage imageNamed:@"see"] forState:UIControlStateNormal];
    [openAndCloseBtn setImage:[UIImage imageNamed:@"sign_out"] forState:UIControlStateSelected];
    [openAndCloseBtn addTarget:self action:@selector(clickOpenAndCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    openAndCloseBtn.frame = self.btnRect;
    [self.parentView addSubview:openAndCloseBtn];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        TamSuspenModel *suspenModel = self.dataArr[i];
        
        NSDictionary *attrs = @{NSFontAttributeName : TamLabelFont};
        CGSize size = [suspenModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
       
        UIView *contentView = [self commLabel:^(UIButton *label) {
            [label setTitle:suspenModel.name forState:UIControlStateNormal];
            label.tag = i;
            [label addTarget:self action:@selector(clickBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
            [label setBackgroundImage:[UIImage imageNamed:suspenModel.leftBgkName] forState:UIControlStateNormal];
        } button:^(UIButton *button) {
            button.tag = i;
            [button setImage:[UIImage imageNamed:suspenModel.imgName] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
        }];
        contentView.tag = 5000+i;
        contentView.hidden = YES;
        contentView.frame = CGRectMake(openAndCloseBtn.frame.origin.x-10-size.width-5, openAndCloseBtn.frame.origin.y, openAndCloseBtn.frame.size.width+size.width+10+5, openAndCloseBtn.frame.size.width);
        [self.parentView addSubview:contentView];
    }
    [self.parentView bringSubviewToFront:openAndCloseBtn];
}

-(void)clickOpenAndCloseBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    sender.selected ? [self showAnim] : [self hiddenAnim];
}

-(void)clickBtnAcion:(UIButton *)sender
{
    [self clickOpenAndCloseBtn:self.openAndCloseBtn];
    if (self.clickBtnBlock) {
        self.clickBtnBlock(sender.tag);
    }
}

/**
 *  显示动画
 */
-(void)showAnim
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        for (int i = 0; i < self.dataArr.count; i ++) {
            UIView *contentView = [self.parentView viewWithTag:i+5000];
            contentView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut  animations:^{
                    CGRect rect = contentView.frame;
                    rect.origin.y = rect.origin.y-(10+self.openAndCloseBtn.frame.size.width)*(i+1);
                    contentView.frame = rect;
                } completion:^(BOOL finished) {
                    
                }];
                
            });
        }
        
    }completion:^(BOOL finished) {
        
    }];
    
}
/**
 *  隐藏动画
 */
-(void)hiddenAnim
{
    for (int i = (int)self.dataArr.count-1; i >= 0; i --) {
        UIView *contentView = [self.parentView viewWithTag:i+5000];
        contentView.hidden = YES;
        CGRect rect = contentView.frame;
        rect.origin.y = self.openAndCloseBtn.frame.origin.y;
        contentView.frame = rect;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        //        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        //        for (int i = (int)self.dataArr.count-1; i >= 0; i --) {
        //            UIView *contentView = [self.parentView viewWithTag:i+5000];
        
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        //            contentView.y = self.openAndCloseBtn.y;
        //                } completion:^(BOOL finished) {
        //                    contentView.hidden = YES;
        //                    self.bgkView.hidden = YES;
        //                }];
        //
        //            });
        //        }
        
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

/**
 *  通用的视图
 */
-(UIView *)commLabel:(void(^)(UIButton *label))label button:(void(^)(UIButton *button))button
{
    UIView *contentView = [[UIView alloc]init];
    //左边文字
    UIButton *subLabel = [[UIButton alloc]init];
    [subLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subLabel.titleLabel.font = TamLabelFont;
    label(subLabel);
    //设置layer属性
    subLabel.layer.masksToBounds = YES;
    subLabel.layer.borderWidth = 1;
    subLabel.layer.borderColor = [UIColor clearColor].CGColor;
    subLabel.layer.cornerRadius = 3;
    
    subLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [contentView addSubview:subLabel];
    
    NSDictionary *attrs = @{NSFontAttributeName : TamLabelFont};
    CGSize size = [subLabel.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    //VFL约束
    NSDictionary *mertrics = @{@"Width":@(size.width+10)}; // 参数\数值
    NSDictionary *views = NSDictionaryOfVariableBindings(subLabel);
    
    NSArray *constr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subLabel(Width)]" options:0 metrics:mertrics views:views];
    NSArray *constr1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[subLabel(30)]" options:0 metrics:nil views:views];

    [contentView addConstraints:constr];
    [contentView addConstraints:constr1];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:subLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    //右边按钮
    UIButton *subBtn = [[UIButton alloc]init];
    button(subBtn);
    subBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:subBtn];
    
    NSDictionary *views1 = NSDictionaryOfVariableBindings(subBtn);
    
    NSArray *constr3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[subBtn]-0-|" options:NSLayoutFormatAlignAllRight metrics:nil views:views1];
    NSArray *constr4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subBtn]-0-|" options:0 metrics:nil views:views1];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:subBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:subBtn attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    [contentView addConstraint:constraint1];
    [contentView addConstraints:constr3];
    [contentView addConstraints:constr4];
    
    return contentView;
}

@end
