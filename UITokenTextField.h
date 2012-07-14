//
//  UITokenTextfield.h
//
//  Created by Henri Normak on 29/06/2012.
//

#import <UIKit/UIKit.h>

@protocol UITokenTextFieldDelegate;
@interface UITokenTextField : UIControl <UITextFieldDelegate>

@property (nonatomic, readonly) BOOL editing;

// Characters in this set will be used to split input into tokens
// For example, if this set contains space, then space is the character that splits the current text into a token i.e "Test " turns into "Test" token
@property (nonatomic, retain) NSCharacterSet *tokenzingCharacterSet;

// Tokens, may be changed, will cause a reload of the view
// An array of NSString instances
@property (nonatomic, retain) NSArray *tokens;

// Delegate
@property (nonatomic, assign) id <UITokenTextFieldDelegate> delegate;

// Label, this is shown before the text entry position, it will remain there in both editing/non-editing state
// Readonly, but still allows changing text, color, font etc.
@property (nonatomic, readonly) UILabel *label;

// If set, will animate the changes to tokens (i.e fades in the token that is added, fades out the one deleted, animates frame changes to self)
@property (nonatomic) BOOL animated;

@end

@protocol UITokenTextFieldDelegate <NSObject>

@optional

// Returning NO from here will ignore the token even if tokenizing should occur according to the character set
// This method will always be called, does not necessarily mean a new token will be captured, for example a duplicate token will be ignored
// even if the delegate allows capturing it.
- (BOOL)shouldCaptureToken: (NSString *)token inTokenTextField: (UITokenTextField *)field;

// Notifications of tokens being added and tokens being removed
- (NSString *)willAddToken: (NSString *)token toTokenTextField: (UITokenTextField *)field;    // Return value can change the displayed text for the given token. Returning nil == returning token itself.
- (void)didAddToken: (NSString *)token toTokenTextField: (UITokenTextField *)field;

- (void)didDeleteToken: (NSString *)token fromTokenTextField: (UITokenTextField *)field;

@end