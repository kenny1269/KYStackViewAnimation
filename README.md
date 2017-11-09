# KYStackViewAnimation

# Overview

You can use this API extension to update the UIStackView with animation effect.

A parameter for enabling animation is added to the original UIStackView API.

Two new API for updating the stack view more easily:

- (void)replaceArrangedSubview:(UIView *)view withView:(UIView *)replacingView animated:(BOOL)animated completion:(void (^)(id replacedView))completion;

- (void)reloadArrangedSubview:(UIView *)view animated:(BOOL)animated withReloadConfiguration:(void (^)(id arrangedSubview))configuration;

# Attention

The extension has had the removed or replaced view hidden, and they are still in the stack view's subviews.
