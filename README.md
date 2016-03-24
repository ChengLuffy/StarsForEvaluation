# StarsForEvaluation
先上效果图

![gif.gif](http://upload-images.jianshu.io/upload_images/1251095-12c1c4ce0f141f15.gif?imageMogr2/auto-orient/strip)

1.码UI。。。
```
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
```
2.评星按钮的回调事件
```
- (void)starsBtnClick {
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
```

3.点触评星的实现
```
// 点触评分的关键
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
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
    
    [self.view endEditing:YES];
}
```
