//
//  LayoutItem.swift
//  LayoutKit
//
//  Created by Martin Klöppner on 05/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

import Foundation
import UIKit

let kMKLayoutItemSizeValueMatchParent :CGFloat = -1 ;

extension LayoutKit {
    
    class LayoutItem {
        
        init(layout: Layout, subview: UIView) {
            self.layout = layout;
            self.subview = subview;
        }
        
        init(layout :Layout, sublayout: Layout) {
            self.layout = layout;
            self.sublayout = sublayout;
        }
        
        /**
        * The parent layout of the current layout item
        */
        var layout :Layout?;
        
        /**
        * An absolute size within a layout
        *
        * kMKLayoutItemSizeValueMatchParent can be used to set either
        *
        * - the width
        * - the height
        * - or both to parents size to perfectly fit the space
        */
        var size :CGSize = CGSizeMake(kMKLayoutItemSizeValueMatchParent, kMKLayoutItemSizeValueMatchParent);
        
        /**
        * Ensures a margin around the layout items view.
        */
        var padding :UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        /**
        * Moves the items view or sublayout by the specified offset.
        *
        * Positive values increases the offset from the top left while negatives do the opposite
        */
        var offset :UIOffset = UIOffsetMake(0.0, 0.0);
        
        /**
        * Inserts a border
        *
        * Default: NO
        */
        var insertBorder :Bool = false;
        
        /**
        * Can store a subview or a sublayout.
        *
        * Use the property which instance is not nil
        */
        var subview :UIView?
        var sublayout: Layout?
        
        /**
        * Gravity aligns the layout items view to the following options:
        *
        * gravity = MKLayoutGravityTop | MKLayoutGravityLeft = The view is on the upper left corner
        * gravity = MKLayoutGravityBottom | MKLayoutGravityCenterHorizontal = The view is on the horizontal center of the bottom view
        * gravity = MKLayoutGravityCenterVertical | MKLayoutGravityCenterHorizontal = The view is on the center of the cell
        *
        * @see MKLayoutGravity
        */
        var gravity :Gravity = Gravity.None;
        
        /**
        * Allows to store meta data for debugging, layout introspection ...
        */
        var userInfo :NSDictionary?
        
        /**
        * Removes the whole layout contents and cleans them up
        */
        func removeFromLayout() {
            
        }
    }
    
}