//
//  MessageLabel.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/26/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class MessageLabel: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        var inset = UIEdgeInsetsMake(0, 10, 0, 0)
        if (self.accessibilityHint == "x") {
            print("yoooo")
            inset = UIEdgeInsetsMake(0, 0, 0, 10)
        }
        // super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 10, 0, 10)))
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, inset))
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let size = CGSizeMake(270.0, 1000.0)
        let frame = NSString(string: self.text!).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)], context: nil)
        return CGRectMake(0, 0, frame.width + 20, frame.height + 10)
    }

}
