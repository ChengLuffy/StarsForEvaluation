# StarsForEvaluation
先上效果图

![gif.gif](http://upload-images.jianshu.io/upload_images/1251095-12c1c4ce0f141f15.gif?imageMogr2/auto-orient/strip)

1.评星按钮的回调事件
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

2.点触评星的实现
```
// 点触评分的关键
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
```
