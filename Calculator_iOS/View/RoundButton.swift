//
//  RoundButton.swift
//  Calculator_iOS
//
//  Created by Meruyert Tastandiyeva on 2/5/21.
//

import UIKit
@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
