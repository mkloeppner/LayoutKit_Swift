//
//  LinearLayout.swift
//  LayoutKit
//
//  Created by Martin Klöppner on 05/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

import Foundation
import UIKit

extension LayoutKit {
    
    class LinearLayout :Layout {
        
        override func layoutBounds(bounds: CGRect) {
            for item in self.mutableItems {
                item.subview!.frame = bounds;
            }
        }
        
    }
    
}