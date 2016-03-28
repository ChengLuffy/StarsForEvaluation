//
//  ViewController.m
//  StarDemo
//
//  Created by 成璐飞 on 16/3/24.
//  Copyright © 2016年 成璐飞. All rights reserved.
//

#import "ViewController.h"

#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)

@interface ViewController ()

@property (nonatomic, strong) UIImageView *colorStars;
@property (nonatomic, strong) UIImageView *blankStars;
@property (nonatomic, strong) UITextField *tf;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    label.text = @"点击星星可以自动获取评分哦～";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.center = CGPointMake(kScreenWidth / 2, 60);
    
    self.colorStars = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsForeground"]];
    self.blankStars = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsBackground"]];
    // 宽高根据Image实际大小，如果放到了2倍图记得➗2
    self.colorStars.frame = CGRectMake((kScreenWidth - 65) / 2, 100, 65, 23);
    self.blankStars.frame = CGRectMake((kScreenWidth - 65) / 2, 100, 65, 23);
    // 顺序不能错
    [self.view addSubview:self.blankStars];
    [self.view addSubview:self.colorStars];
    // 关键
    self.colorStars.clipsToBounds = YES;
    self.colorStars.contentMode = UIViewContentModeLeft | UIViewContentModeTop;
    
    self.tf = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2, 250, 300, 30)];
    self.tf.borderStyle = UITextBorderStyleRoundedRect;
    self.tf.backgroundColor = [UIColor lightGrayColor];
    self.tf.textColor = [UIColor blueColor];
    self.tf.backgroundColor = [UIColor whiteColor];
    self.tf.placeholder = @"请输入1.0-5.0的评分等级";
    self.tf.keyboardType = UIKeyboardTypeDecimalPad;
    self.tf.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tf];
    
    UIButton *Stars = [UIButton buttonWithType:UIButtonTypeCustom];
    [Stars setTitle:@"评星" forState:UIControlStateNormal];
    [Stars setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    Stars.frame = CGRectMake((kScreenWidth - 50) / 2, 350, 50, 30);
    [Stars addTarget:self action:@selector(starsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Stars];
    
    // 如果需要触屏取评分……最好星星的图片大一点，现在这个尺寸的图片我点不到五星……
}

- (void)starsBtnClick {
    // 规则的话可以进一步对键盘定制，关键的地方我想不起来了
    if ([self.tf.text floatValue] <= 0) {
        NSLog(@"请输入评分");
        [self alertMSG:@"请输入评分"];
    } else if ([self.tf.text floatValue] > 5) {
        NSLog(@"请按规则输入评分");
        [self alertMSG:@"请按规则输入评分"];
    } else {
        CGFloat value = self.tf.text.floatValue;
        CGFloat width = value/5.0*65;
        CGPoint orgin = self.colorStars.frame.origin;
        CGFloat height = self.colorStars.frame.size.height;
        [UIView animateWithDuration:0.23 animations:^{
            self.colorStars.frame = CGRectMake(orgin.x, orgin.y, width, height);
        }];
    }
}

- (void)alertMSG:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

// 点触
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self updateWithTouches:touches];
    [self.view endEditing:YES];
}

// 移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self updateWithTouches:touches];
    [self.view endEditing:YES];
}

- (void)updateWithTouches:(NSSet<UITouch *> *)touches {
    UITouch *touche = [touches anyObject];
    CGPoint touchPoint = [touche locationInView:self.blankStars];
    NSLog(@"%@", NSStringFromCGPoint(touchPoint));
    // 如果点触在图片外，就不进行操作
    if (touchPoint.x >= 0 && touchPoint.y >= 0 && touchPoint.x < self.blankStars.frame.size.width + 10 && touchPoint.y <= self.blankStars.frame.size.height) {
        CGPoint orgin = self.colorStars.frame.origin;
        CGFloat height = self.colorStars.frame.size.height;
        CGFloat touchX = touchPoint.x;
        if (touchPoint.x > self.blankStars.frame.size.width) {
            touchX = self.blankStars.frame.size.width;
        }
        [UIView animateWithDuration:0.23 animations:^{
            self.colorStars.frame = CGRectMake(orgin.x, orgin.y, touchX, height);
        } completion:^(BOOL finished) {
            self.tf.text = [NSString stringWithFormat:@"%.2lf", touchX / self.blankStars.frame.size.width * 5];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
