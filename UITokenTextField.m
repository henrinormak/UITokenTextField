//
//  UITokenTextfield.m
//
//  Created by Henri Normak on 29/06/2012.
//

#import "UITokenTextField.h"

#pragma mark - Additional auxilliary class, that adds drawing to a standard UILabel

@interface UITokenLabel : UILabel

@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *highlightedFillColor;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *highlightedStrokeColor;

@end

@implementation UITokenLabel
@synthesize fillColor;
@synthesize highlightedFillColor;
@synthesize strokeColor;
@synthesize highlightedStrokeColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.strokeColor = [UIColor colorWithRed: 156.0 / 255.0 green: 156.0 / 255.0 blue: 156.0 / 255.0 alpha: 1.0];
        self.fillColor = [UIColor colorWithRed: 222.0 / 255.0 green: 222.0 / 255.0 blue: 222.0 / 255.0 alpha: 1.0];
        self.highlightedFillColor = [UIColor colorWithRed: 152 / 255.0 green: 152 / 255.0 blue: 152 / 255.0 alpha: 1.0];
        self.highlightedStrokeColor = [UIColor colorWithRed: 108.0 / 255.0 green: 108.0 / 255.0 blue: 108.0 / 255.0 alpha: 1.0];
        
        // Adjust font
        self.font = [UIFont systemFontOfSize: 15.0];
        self.textColor = [UIColor colorWithRed: 96.0 / 255.0 green: 96.0 / 255.0 blue: 96.0 / 255.0 alpha: 1.0];
        self.highlightedTextColor = [UIColor whiteColor];
        self.shadowColor = [UIColor colorWithRed: 235.0 / 255.0 green: 235.0 / 255.0 blue: 235.0 / 255.0 alpha: 1.0];
        self.shadowOffset = CGSizeMake(0.0, 1.0);
    }
    
    return self;
}

- (void)dealloc {
    [strokeColor release];
    [fillColor release];
    
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted: highlighted];
    
    // Adjust shadow color accordingly
    if (highlighted)
        self.shadowColor = nil;
    else
        self.shadowColor = [UIColor colorWithRed: 235.0 / 255.0 green: 235.0 / 255.0 blue: 235.0 / 255.0 alpha: 1.0];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {        
    // Add the background ellipse
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Add the rounded square to the background
    CGContextSaveGState(ctx);
    
    // Stroke width, outside stroke, meaning we have to take this into account with the path
    CGFloat strokeWidth = 1.0;
    
    // Get the rounded path for the rect
    CGFloat radius = roundf((CGRectGetHeight(rect) - strokeWidth * 2) / 2.0);
    CGFloat radii[4] = {radius, radius, radius, radius};
    
    // Make sure the radius fits nicely inside the given rect
    CGFloat halfWidth = roundf(rect.size.width / 2.0);
    CGFloat halfHeight = roundf(rect.size.height / 2.0);
    
    // Top right
    radii[0] = radii[0] > halfWidth ? halfWidth : radii[0];
    radii[0] = radii[0] > halfHeight ? halfHeight : radii[0];
    
    // Bottom right
    radii[1] = radii[1] > halfWidth ? halfWidth : radii[1];
    radii[1] = radii[1] > halfHeight ? halfHeight : radii[1];
    
    // Bottom left
    radii[2] = radii[2] > halfWidth ? halfWidth : radii[2];
    radii[2] = radii[2] > halfHeight ? halfHeight : radii[2];
    
    // Top left
    radii[3] = radii[3] > halfWidth ? halfWidth : radii[3];
    radii[3] = radii[3] > halfHeight ? halfHeight : radii[3];
    
    // Create the rounded path used for drawing
    CGRect insetRect = CGRectInset(rect, strokeWidth + 0.5, strokeWidth + 0.5);
    CGMutablePathRef roundedPath = CGPathCreateMutable();
    CGPathMoveToPoint(roundedPath, NULL, insetRect.origin.x + radii[3], insetRect.origin.y);
    CGPathAddArc(roundedPath, NULL, insetRect.origin.x + radii[3], insetRect.origin.y + radii[3], 
                 radii[3], -M_PI / 2.0, M_PI, 1);
    
    CGPathAddLineToPoint(roundedPath, NULL, insetRect.origin.x, insetRect.origin.y + insetRect.size.height - radii[2]);
    CGPathAddArc(roundedPath, NULL, insetRect.origin.x + radii[2], insetRect.origin.y + insetRect.size.height - radii[2], 
                 radii[2], M_PI, M_PI / 2.0, 1);
    
    CGPathAddLineToPoint(roundedPath, NULL, insetRect.origin.x + insetRect.size.width - radii[1], insetRect.origin.y + insetRect.size.height);
    CGPathAddArc(roundedPath, NULL, insetRect.origin.x + insetRect.size.width - radii[1], insetRect.origin.y + insetRect.size.height - radii[1], 
                 radii[1], M_PI / 2.0, 0.0f, 1);
    
    CGPathAddLineToPoint(roundedPath, NULL, insetRect.origin.x + insetRect.size.width, insetRect.origin.y + radii[0]);
    CGPathAddArc(roundedPath, NULL, insetRect.origin.x + insetRect.size.width - radii[0], insetRect.origin.y + radii[0],
                 radii[0], 0.0f, -M_PI / 2.0, 1);
    
    CGPathAddLineToPoint(roundedPath, NULL, insetRect.origin.x + radii[3], insetRect.origin.y);
    CGContextAddPath(ctx, roundedPath);
    CGPathRelease(roundedPath);
    
    // Paint it
    if (self.highlighted) {
        CGContextSetFillColorWithColor(ctx, self.highlightedFillColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, self.highlightedStrokeColor.CGColor);
    } else {
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
    }
    
    CGContextSetLineWidth(ctx, strokeWidth);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
    
    // Draw the text
    [super drawTextInRect: CGRectMake(0.0, -1.0, CGRectGetWidth(rect), CGRectGetHeight(rect))];
}

@end

#pragma mark - Main class

#define kPadding 9.0
#define kTextFieldAdjust 1.0

// Point at which the cursor is moved on to the next line 1/x of the width of self
#define kWrapPoint 2

#define kInvisibleSpaceString @"\u200B"

@interface UITokenTextField ()
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic) CGPoint textFieldOrigin;
@property (nonatomic) CGSize collapsedSize;
@property (nonatomic) CGFloat lineHeight;

@property (nonatomic, retain) NSArray *tokenViews;
@property (nonatomic, assign) NSString *selectedToken;

@property (nonatomic, retain) UITapGestureRecognizer *editingTap;
@property (nonatomic, retain) UITapGestureRecognizer *deselectingTap;

- (void)addToken: (NSString *)token;
- (void)removeTokenAtIndex: (NSUInteger)index;
- (void)removeToken: (NSString *)token;

- (void)selectTokenView: (UITapGestureRecognizer *)tap;
- (void)deselectTokens: (UITapGestureRecognizer *)tap;

- (CGSize)sizeForToken: (NSString *)token;

- (NSString *)tokenStringThatFits;

@end

@implementation UITokenTextField
@synthesize editing;
@synthesize tokenzingCharacterSet;
@synthesize tokens;
@synthesize label;
@synthesize delegate;
@synthesize animated;

@synthesize textField;
@synthesize textFieldOrigin;
@synthesize collapsedSize;
@synthesize lineHeight;

@synthesize tokenViews;
@synthesize selectedToken;

@synthesize editingTap;
@synthesize deselectingTap;

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed: 239.0 / 255.0 green: 239.0 / 255.0 blue: 239.0 / 255.0 alpha: 1.0];
        self.userInteractionEnabled = YES;
        self.animated = YES;
        
        // Add tap to self (to start adding or removing tokens)
        self.editingTap = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(startEditing)] autorelease];
        [self addGestureRecognizer: self.editingTap];
        
        // And another for deselecting selected tokens
        self.deselectingTap = [[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(deselectTokens:)] autorelease];
        [self.deselectingTap requireGestureRecognizerToFail: self.editingTap];
        self.deselectingTap.enabled = NO;
        [self addGestureRecognizer: self.deselectingTap];
        
        // Figure out the line-height, this is the heigh of all the items in every line
        self.lineHeight = CGRectGetHeight(self.frame) - 2 * kPadding;
        
        // Add the text field to self
        self.textField = [[[UITextField alloc] initWithFrame: CGRectMake(kPadding, kPadding + kTextFieldAdjust, CGRectGetWidth(self.frame), self.lineHeight - kTextFieldAdjust)] autorelease];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.textColor = [UIColor colorWithRed: 104.0 / 255.0 green: 104.0 / 255.0 blue: 104.0 / 255.0 alpha: 1.0];
        self.textFieldOrigin = CGPointZero;
        self.textField.text = kInvisibleSpaceString;
        self.textField.delegate = self;
        self.textField.font = [UIFont systemFontOfSize: 15.0];
        self.textField.userInteractionEnabled = NO;
        [self addSubview: self.textField];
        
        // By default the tokenizer includes whitespace and newline characters
        self.tokenzingCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        // Add a label before the tokens
        label = [[UILabel alloc] initWithFrame: CGRectMake(kPadding * 2, kPadding, 0.0, self.lineHeight)];
        self.label.textColor = [UIColor colorWithRed: 172.0 / 255.0 green: 172.0 / 255.0 blue: 172.0 / 255.0 alpha: 1.0];
        self.label.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.5];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont systemFontOfSize: 14.0];
        [self.label addObserver: self forKeyPath: @"text" options: NSKeyValueObservingOptionNew context: NULL]; // Start observing for changes in text, we'll resize the label along with that
        self.label.text = @"To";
        [self addSubview: self.label];
        
        // By default no tokens are present
        self.tokens = [NSArray array];
        self.tokenViews = [NSArray array];
        
        // Store the default size
        self.collapsedSize = frame.size;
    }
    
    return self;
}

- (void)dealloc {
    [label removeObserver: self forKeyPath: @"text"];
    [label release];
    [textField release];
    [editingTap release];
    [tokenzingCharacterSet release];
    [tokens release];
    [tokenViews release];
    
    [super dealloc];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.label && [keyPath isEqualToString: @"text"]) {
        // Adjust the frame of the label
        [self.label sizeToFit];
        
        // Make sure the height never changes
        CGRect frame = self.label.frame;
        frame.size.width += kPadding;   // Add some padding to the width as well
        frame.size.height = self.lineHeight;
        self.label.frame = frame;
        
        // Layout self
        [self setNeedsLayout];
    }
}

#pragma mark - Token handling

- (void)addToken: (NSString *)token {
    // Check if we have this token already, if we do, ignore the new one
    if ([self.tokens containsObject: token])
        return;
    
    // Check if delegate returns anything useful for this token to display
    if ([self.delegate respondsToSelector: @selector(willAddToken:toTokenTextField:)]) {
        NSString *displayText = [self.delegate willAddToken: token toTokenTextField: self];
        token = displayText ? displayText : token;
    }
    
    // Add a view that corresponds to the size of the token
    CGSize size = [self sizeForToken: token];
    UITokenLabel *view = [[UITokenLabel alloc] initWithFrame: CGRectMake(0.0, round((self.lineHeight - size.height) / 2.0), 
                                                                         MIN(size.width, CGRectGetWidth(self.frame) - 2 * kPadding), size.height)];
    view.textAlignment = UITextAlignmentCenter;
    view.text = token;
    view.userInteractionEnabled = YES;
    view.alpha = self.animated ? 0.0 : 1.0;
    self.tokenViews = [self.tokenViews arrayByAddingObject: view];
    
    [self addSubview: view];
    
    // If animated, animate the alpha change of the view
    if (self.animated) {
        [UIView animateWithDuration: 0.2 animations:^{
            view.alpha = 1.0;
        }];
    }
    
    // Add tap gesture to the token
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(selectTokenView:)];
    [tap requireGestureRecognizerToFail: self.editingTap];
    [view addGestureRecognizer: tap];
    [tap release];
    
    [view release];
    
    // Add the token
    self.tokens = [self.tokens arrayByAddingObject: token];
    
    // Let the delegate know that the token was added
    if ([self.delegate respondsToSelector: @selector(didAddToken:toTokenTextField:)])
        [self.delegate didAddToken: token toTokenTextField: self];
}

- (void)removeTokenAtIndex: (NSUInteger)index {
    if (index >= self.tokens.count)
        return;
    
    // Remove that token and its' view
    NSString *token = [self.tokens objectAtIndex: index];
    NSMutableArray *viewEdit = [NSMutableArray arrayWithArray: self.tokenViews];
    
    UIView *view = [viewEdit objectAtIndex: index];
    
    // If animated, fade out
    if (self.animated) {
        [UIView animateWithDuration: 0.15 animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [[viewEdit objectAtIndex: index] removeFromSuperview];
            [viewEdit removeObjectAtIndex: index];
            
            self.tokenViews = [NSArray arrayWithArray: viewEdit];
        }];
    } else {
        [[viewEdit objectAtIndex: index] removeFromSuperview];
        [viewEdit removeObjectAtIndex: index];
        
        self.tokenViews = [NSArray arrayWithArray: viewEdit];   
    }
    
    NSMutableArray *tokenEdit = [NSMutableArray arrayWithArray: self.tokens];
    [tokenEdit removeObjectAtIndex: index];
    
    self.tokens = [NSArray arrayWithArray: tokenEdit];
    
    [self setNeedsLayout];
    
    // Let the delegate know
    if ([self.delegate respondsToSelector: @selector(didDeleteToken:fromTokenTextField:)])
        [self.delegate didDeleteToken: token fromTokenTextField: self];
}

- (void)removeToken: (NSString *)token {
    // Grab it's index
    NSUInteger index = [self.tokens indexOfObject: token];
    
    [self removeTokenAtIndex: index];
}

- (CGSize)sizeForToken: (NSString *)token {
    // Calculate the text size for start
    CGSize textSize = [token sizeWithFont: self.textField.font constrainedToSize: CGSizeMake(self.collapsedSize.width - 2 * kPadding, self.collapsedSize.height - 2 * kPadding) lineBreakMode: UILineBreakModeTailTruncation];
    
    return CGSizeMake(textSize.width + kPadding * 2, self.lineHeight);
}

- (void)setTokens: (NSArray *)newTokens {
    [tokens autorelease];
    tokens = [newTokens retain];
    
    [self setNeedsLayout];
}

- (void)selectTokenView: (UITapGestureRecognizer *)tap {
    // Grab the view
    UIView *view = [tap view];
    
    // Clear the textfield and hide it
    self.textField.text = kInvisibleSpaceString;
    self.textField.alpha = 0.0;
    
    // Grab the appropriate token
    if ([self.tokenViews containsObject: view]) {
        NSUInteger index = [self.tokenViews indexOfObject: view];
        self.selectedToken = [self.tokens objectAtIndex: index];
    }
    
    // Enable the deselecting tap
    if (self.selectedToken) {
        self.deselectingTap.enabled = YES;
    }
}

- (void)deselectTokens: (UITapGestureRecognizer *)tap {
    self.selectedToken = nil;
    self.textField.alpha = 1.0;
}

- (void)setSelectedToken: (NSString *)newSelectedToken {    
    // Reset previous, if we had one
    if ([self.tokens containsObject: selectedToken]) {
        NSUInteger index = [self.tokens indexOfObject: selectedToken];
        UITokenLabel *view = [self.tokenViews objectAtIndex: index];
        view.highlighted = NO;
    }
    
    [selectedToken autorelease];
    selectedToken = [newSelectedToken retain];
    
    // Adjust the new view
    if ([self.tokens containsObject: newSelectedToken]) {
        NSUInteger index = [self.tokens indexOfObject: newSelectedToken];
        UITokenLabel *view = [self.tokenViews objectAtIndex: index];
        view.highlighted = YES;
    }
}

- (NSString *)tokenStringThatFits {
    // Start going over the tokens until we reach the size limitations set by our collapsed frame
    
    if ([self.tokens count] > 0) {
        NSString *string = [self.tokens objectAtIndex: 0];
        if ([string sizeWithFont: self.textField.font].width > CGRectGetWidth(self.frame) - CGRectGetMaxX(self.label.frame) - 2 * kPadding)
            return [NSString stringWithFormat: @"%i total", [self.tokens count]];
        
        // At least one fits, loop over others
        if ([self.tokens count] > 1) {
            NSInteger count = [self.tokens count] - 1;
            NSString *tail = [NSString stringWithFormat: @" & %i more", count];
            CGSize tailSize = [tail sizeWithFont: self.textField.font];
            
            for (NSString *token in [self.tokens subarrayWithRange: NSMakeRange(1, [self.tokens count] - 1)]) {
                // Add the widths together, if larger break out, if smaller add the string
                CGSize tokenSize = [token sizeWithFont: self.textField.font];
                CGSize currentSize = [string sizeWithFont: self.textField.font];
                if (tokenSize.width + tailSize.width + currentSize.width > CGRectGetWidth(self.frame) - CGRectGetMaxX(self.label.frame) - 2 * kPadding)
                    break;
                
                // Fits
                string = [string stringByAppendingFormat: @", %@", token];
                count--;
                                
                // Recalculate the tail
                if (count - 1 == 0)
                    tail = @"";
                else
                    tail = [NSString stringWithFormat: @" & %i more", count];
                
                tailSize = [tail sizeWithFont: self.textField.font];
            }
            
            if (count > 0) {
                // Not all fit in the string add a tail
                string = [string stringByAppendingFormat: @" & %i more", count];
            }
        }
        
        // Return the combined string (may have one token, may have many or even multiple and a tail)
        return string;
    } else {
        return @"";
    }
}

#pragma mark - Touch handling

- (void)startEditing {
    if (self.editing)
        return;
    
    // Not yet editing, start editing
    [self becomeFirstResponder];
}

#pragma mark - Focus handling

- (BOOL)resignFirstResponder {
    // Return value depends on whether we were editing or not
    BOOL wasEditing = editing;
    editing = NO;
    
    // Restore the state of the textfield
    self.textField.alpha = 1.0;
    
    // Check if we have some text in the field, if we do, tokenize it
    NSString *text = [self.textField.text stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: kInvisibleSpaceString]];
    if (text.length > 0) {
        [self addToken: text];
        self.textField.text = kInvisibleSpaceString;
    }
    
    [self.textField resignFirstResponder];
    self.textField.userInteractionEnabled = NO;
    
    // Create the display text to show on the textfield
    self.textField.text = [self tokenStringThatFits];
    
    // Re-enable the editing tap
    self.editingTap.enabled = YES;
    
    // Deselect any selected tokens
    self.selectedToken = nil;
    
    // Layout subviews once again
    [self layoutSubviews];
    
    // Return whether we were editing or not
    return wasEditing;
}

- (BOOL)becomeFirstResponder {
    // Disable editing tap
    self.editingTap.enabled = NO;
    
    // Reset textfield text
    self.textField.text = kInvisibleSpaceString;
    
    // Pass along to the text field and make sure we are editing
    editing = YES;
    self.textField.userInteractionEnabled = YES;
    [self setNeedsLayout];
    
    return [self.textField becomeFirstResponder];
}

#pragma mark - Drawing and layout

- (void)layoutSubviews {
    [super layoutSubviews];

    // Place the tokens
    // If editing
    if (self.editing) {
        CGPoint origin = CGPointMake(CGRectGetMaxX(self.label.frame), kPadding);
        
        for (UIView *view in self.tokenViews) {
            // Show the view
            [view setHidden: NO];
            
            // Calculate the suitable position for the token  
            // If does not fit on the current line, move to the next one
            if (origin.x + CGRectGetWidth(view.frame) + kPadding > CGRectGetWidth(self.frame) - kPadding) {
                // Move to the next line
                origin.y += self.lineHeight + kPadding;
                origin.x = kPadding;
            }
            
            // Assign the new frame
            CGRect frame = view.frame;
            frame.origin = origin;
            view.frame = frame;
            
            // Move the X along
            origin.x += CGRectGetWidth(frame) + roundf(kPadding / 2.0);
        }
        
        // Place the textfield
        if (origin.x > (CGRectGetWidth(self.frame) - 2 * kPadding) / kWrapPoint) {
            // Move this to the next line
            origin.y += self.lineHeight + kPadding;
            origin.x = kPadding;
        }
        
        origin.y += kTextFieldAdjust;
        CGRect frame = self.textField.frame;
        frame.origin = origin;
        frame.size.width = CGRectGetWidth(self.frame) - origin.x - kPadding;
        self.textField.frame = frame;
        
        // Adjust self frame
        // Do this animated, if supposed to
        if (self.animated) {
            [UIView beginAnimations: @"Layout" context: NULL];
            [UIView setAnimationDuration: 0.25];
        }
        
        frame = self.frame;
        frame.size.height = MAX(self.collapsedSize.height, origin.y + self.lineHeight - kTextFieldAdjust + kPadding);
        self.frame = frame;
        
        if (self.animated)
            [UIView commitAnimations];
        
    } else {
        // Not editing, hide the tokenviews
        for (UIView *view in self.tokenViews) {
            [view setHidden: YES];
        }
        
        // Collapse self to one line
        // Do this animated, if supposed to
        if (self.animated) {
            [UIView beginAnimations: @"Layout" context: NULL];
            [UIView setAnimationDuration: 0.25];
        }
        
        CGRect frame = self.frame;
        frame.size.height = self.collapsedSize.height;
        self.frame = frame;
        
        if (self.animated)
            [UIView commitAnimations];
        
        // Adjust the textfield positioning
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.label.frame), kPadding + kTextFieldAdjust, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.label.frame), self.lineHeight - kTextFieldAdjust);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Check whether newline is part of the character set and we have input, if not simply lose focus
    NSString *token = [self.textField.text stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: kInvisibleSpaceString]];
    if ([self.tokenzingCharacterSet characterIsMember: '\n'] && token.length > 0) {
        if ([self.delegate respondsToSelector: @selector(shouldCaptureToken:inTokenTextField:)]) {
            if ([self.delegate shouldCaptureToken: token inTokenTextField: self]) {
                [self addToken: token];
                
                // Clear the textfield (leave everything after the tokenizer, although with iOS will not happen that likely)
                self.textField.text = kInvisibleSpaceString;
            }
        } else {
            // Delegate has not implemented this callback, definitely tokenise
            [self addToken: token];
            
            // Clear the textfield (leave everything after the tokenizer, although with iOS will not happen that likely)
            self.textField.text = kInvisibleSpaceString;
        }
    } else if (self.selectedToken) {
        // Deselect the selected token
        [self deselectTokens: nil];
    } else {
        // Simply resign focus
        [self resignFirstResponder];
    }
    
    // Either way, do not allow a newline input
    return NO;
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Grab the substring
    NSString *substring = [theTextField.text substringWithRange: range];
    
    if ([substring isEqualToString: kInvisibleSpaceString]) {
        // Hide the textfield if not already hidden
        theTextField.alpha = 0.0;
                
        // Check if we have a selected view (if we do, delete that token)
        if (self.selectedToken) {
            [self removeToken: self.selectedToken];
            self.selectedToken = nil;
            
            // Show the textfield
            theTextField.alpha = 1.0;
        } else {
            // Select the last token
            self.selectedToken = [self.tokens lastObject];
        }
        
        return NO;
    } else {
        theTextField.alpha = 1.0;
        
        // Deselect any selected token
        if (self.selectedToken)
            self.selectedToken = nil;
    }
    
    // Check if the new string contains any tokenizers
    if ([string rangeOfCharacterFromSet: self.tokenzingCharacterSet].location != NSNotFound) {
        // We have a tokenizing character in there
        NSRange range = [string rangeOfCharacterFromSet: self.tokenzingCharacterSet];
        NSString *substring = [string substringToIndex: range.location];
        
        // Create the new token
        NSString *token = [[self.textField.text stringByAppendingString: substring] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: kInvisibleSpaceString]];
        
        // Check with the delegate
        if ([self.delegate respondsToSelector: @selector(shouldCaptureToken:inTokenTextField:)]) {
            if ([self.delegate shouldCaptureToken: token inTokenTextField: self]) {
                [self addToken: token];
                
                // Clear the textfield (leave everything after the tokenizer, although with iOS will not happen that likely)
                if (range.location < string.length)
                    string = [kInvisibleSpaceString stringByAppendingString: [[string substringFromIndex: range.location] stringByTrimmingCharactersInSet: self.tokenzingCharacterSet]];
                else
                    string = kInvisibleSpaceString;
                
                self.textField.text = string;
                
                return NO;
            }
            
            return NO;
        } else {
            // Delegate has not implemented this callback, definitely tokenise
            [self addToken: token];
            
            // Clear the textfield (leave everything after the tokenizer, although with iOS will not happen that likely)
            if (range.location < string.length)
                string = [kInvisibleSpaceString stringByAppendingString: [[string substringFromIndex: range.location] stringByTrimmingCharactersInSet: self.tokenzingCharacterSet]];
            else
                string = kInvisibleSpaceString;
            
            self.textField.text = string;
            
            return NO;
        }
    }
    
    return YES;
}

@end
