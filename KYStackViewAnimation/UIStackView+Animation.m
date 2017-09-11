//
//  UIStackView+Animation.m
//  
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 ky1269. All rights reserved.
//

#import "UIStackView+Animation.h"

#define UIStackViewAnimationDuratioin 0.45
#define UIStackViewAnimationAlpha 0.25

@implementation UIStackView (Animation)

- (void)addArrangedSubview:(UIView *)view animated:(BOOL)animated {
    [self addArrangedSubview:view];
    if (animated) {
        view.hidden = YES;
        CGFloat alpha = view.alpha;
        view.alpha = UIStackViewAnimationAlpha;
        [UIView animateWithDuration:UIStackViewAnimationDuratioin animations:^{
            view.hidden = NO;
            view.alpha = alpha;
        }];
    }
}

- (void)removeArrangedSubview:(UIView *)view animated:(BOOL)animated {
    if (animated) {
        CGFloat alpha = view.alpha;
        [UIView animateWithDuration:UIStackViewAnimationDuratioin animations:^{
            view.hidden = YES;
            view.alpha = UIStackViewAnimationAlpha;
        } completion:^(BOOL finished) {
            view.alpha = alpha;
            [self removeArrangedSubview:view];
        }];
    } else {
        [self removeArrangedSubview:view];
    }
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex animated:(BOOL)animated {
    [self insertArrangedSubview:view atIndex:stackIndex];
    if (animated) {
        view.hidden = YES;
        CGFloat alpha = view.alpha;
        view.alpha = UIStackViewAnimationAlpha;
        [UIView animateWithDuration:UIStackViewAnimationDuratioin animations:^{
            view.hidden = NO;
            view.alpha = alpha;
        }];
    }
}

- (void)replaceArrangedSubview:(UIView *)replacedView withView:(UIView *)replacingView animated:(BOOL)animated completion:(void (^)(id replacedView))completion {
    if (replacingView == nil) {
        return;
    } else if (![self.arrangedSubviews containsObject:replacedView]) {
        NSAssert(NO, @"view is not arranged");
        return;
    } else if (replacedView == replacingView) {
        return;
    } else if ([self.arrangedSubviews containsObject:replacingView]) {
        NSLog(@"the replacing view is already arranged in the stackview");
        return;
    }
    
    NSUInteger stackIndex = [self.arrangedSubviews indexOfObject:replacedView];
    
    if (animated) {
        
        UIView *superview = replacedView;
        UIView *animationContainer = [[UIView alloc] initWithFrame:replacedView.frame];
        while (CGColorGetAlpha(superview.backgroundColor.CGColor) == 0) {
            if (superview.superview) {
                superview = superview.superview;
            } else {
                break;
            }
        }
        if (superview) {
            animationContainer.backgroundColor = superview.backgroundColor;
        } else {
            animationContainer.backgroundColor = [UIColor whiteColor];
        }
        
        replacingView.hidden = NO;
        
        [self removeArrangedSubview:replacedView];
        [self insertArrangedSubview:replacingView atIndex:stackIndex];
        UIView *snapshot = [replacedView snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = replacedView.bounds;
        [animationContainer addSubview:snapshot];
        animationContainer.clipsToBounds = YES;
        [self addSubview:animationContainer];
        
        CGFloat replaceViewAlpha = replacingView.alpha;
        CGFloat replacedViewAlpha = replacedView.alpha;
        replacedView.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            snapshot.alpha = 0;
            
            [self.superview layoutIfNeeded];
            animationContainer.frame = replacingView.frame;
            
            UIGraphicsBeginImageContextWithOptions(replacingView.frame.size, NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [replacingView.layer renderInContext:context];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageView *viewAfterReplace = [[UIImageView alloc] initWithFrame:replacingView.bounds];
            viewAfterReplace.image = image;
            viewAfterReplace.alpha = 0;
            [animationContainer addSubview:viewAfterReplace];
            
            [UIView performWithoutAnimation:^{
                replacingView.alpha = 0;
            }];
            
            [UIView animateWithDuration:0.25 animations:^{
                viewAfterReplace.alpha = 1;
            }];
        } completion:^(BOOL finished) {
            replacingView.alpha = replaceViewAlpha;
            replacedView.alpha = replacedViewAlpha;
            replacedView.hidden = YES;
            [animationContainer removeFromSuperview];
        }];
    } else {
        UIView *removingView = [self.arrangedSubviews objectAtIndex:stackIndex];
        [self removeArrangedSubview:removingView];
        removingView.hidden = YES;
        replacingView.hidden = NO;
        [self insertArrangedSubview:replacingView atIndex:stackIndex];
    }
}

- (void)reloadArrangedSubview:(UIView *)viewToReload animated:(BOOL)animated withReloadConfiguration:(void (^)(id arrangedSubview))configuration {
    if (viewToReload == nil) {
        return;
    } else if (![self.arrangedSubviews containsObject:viewToReload]) {
        NSAssert(NO, @"view is not arranged in stackView");
        return;
    } else if (!configuration) {
        return;
    }
    
    if (animated) {
        UIView *superview = viewToReload;
        UIView *animationContainer = [[UIView alloc] initWithFrame:viewToReload.frame];
        while (CGColorGetAlpha(superview.backgroundColor.CGColor) == 0) {
            if (superview.superview) {
                superview = superview.superview;
            } else {
                break;
            }
        }
        if (superview) {
            animationContainer.backgroundColor = superview.backgroundColor;
        } else {
            animationContainer.backgroundColor = [UIColor whiteColor];
        }
        
        UIView *snapshot = [viewToReload snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = viewToReload.bounds;
        [animationContainer addSubview:snapshot];
        animationContainer.clipsToBounds = YES;
        [self addSubview:animationContainer];
        
        configuration(viewToReload);
        
        [UIView animateWithDuration:0.25 animations:^{
            snapshot.alpha = 0;
            
            [self.superview layoutIfNeeded];
            animationContainer.frame = viewToReload.frame;
            
            UIGraphicsBeginImageContextWithOptions(viewToReload.frame.size, NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [viewToReload.layer renderInContext:context];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageView *viewAfterReload = [[UIImageView alloc] initWithFrame:viewToReload.bounds];
            viewAfterReload.image = image;
            viewAfterReload.alpha = 0;
            [animationContainer addSubview:viewAfterReload];
            
            [UIView animateWithDuration:0.25 animations:^{
                viewAfterReload.alpha = 1;
                //            viewAfterReload.frame = viewToReload.bounds;
            }];
        } completion:^(BOOL finished) {
            [animationContainer removeFromSuperview];
        }];
    } else {
        configuration(viewToReload);
    }
}

@end
