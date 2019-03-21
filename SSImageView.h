//
//  SSImageView.h
//  SunnyCalendar
//
//  Created by sun on 2019/3/19.
//  Copyright © 2019年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSImageView : UIImageView

@property (nonatomic, strong)UIImage *originalImg;

// 初始 模糊级别 默认 0.8
@property (nonatomic, assign)CGFloat initalBlurLevel;

@property (nonatomic, strong)UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
