//
//  UIView+findViewByID.swift
//  JSONLayout
//
//  Created by Maxim Volgin on 10/02/2019.
//  Copyright © 2019 Maxim Volgin. All rights reserved.
//

import UIKit

extension UIView {    
    public func findViewByID(_ id: String) -> UIView? {
        return self.viewWithTag(id.hash)
    }
}

