//
//  CustomTextField.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/12/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let inset: CGFloat = 16

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , inset , inset)
    }
}