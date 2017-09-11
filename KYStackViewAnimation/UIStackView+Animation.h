//
//  UIStackView+Animation.h
//
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 ky1269. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStackView (Animation)

- (void)addArrangedSubview:(UIView *)view animated:(BOOL)animated;

- (void)removeArrangedSubview:(UIView *)view animated:(BOOL)animated;

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex animated:(BOOL)animated;

- (void)replaceArrangedSubview:(UIView *)view withView:(UIView *)replacingView animated:(BOOL)animated completion:(void (^)(id replacedView))completion;

- (void)reloadArrangedSubview:(UIView *)view animated:(BOOL)animated withReloadConfiguration:(void (^)(id arrangedSubview))configuration;


@end
