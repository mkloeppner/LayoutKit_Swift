//
//  LKLayout.swift
//  LayoutKit
//
//  Created by Martin Klöppner on 05/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

import Foundation
import UIKit

struct LayoutKit {
    
    enum Orientation {
        case Horizontal // Positionates views on the horizontal axis
        case Vertical // Positionates views on the vertical axis
    }
    
    /**
    * Gravity specifies how views should be positioned in ralation to their super views.
    *
    * For example a view with a size of 100x100 aligned in a view with 1000x1000 positioned with gravity top and gravity right will be positionated at position 900(1000-100)x100.
    */
    enum Gravity :UInt8 {
        case None = 0b00000001 // Specifies, that the view doesn't stick to any edge
        case Top = 0b00000010 // Specifies that a view is aligned on top
        case Bottom = 0b00000100 // Specifies that a view is aligned on bottom
        case Left = 0b00001000 // Specifies that a view is aligned to the left
        case Right = 0b00010000 // Specifies that a view is aligned to the right
        case Vertical = 0b00100000 // Specifies that a views center is aligned to its superview center on the vertical axis
        case Horizontal = 0b01000000 // Specifies that a views center is aligned to its superview center on the horizontal axis
    }
    
    /**
    * MKLayout is the root class of MKLayoutLibrary
    *
    *
    * @discussion
    *
    * MKLayout maintains the view and layout tree and provides an easy interface for subclasses such as MKLinearLayout
    *
    * MKLayout subclasses can easy implement their layout behavior without the needs to maintain the view and layout hirarchy.
    *
    * Therefore the items array gives easy access to the layout children.
    *
    * Every layout needs to support all MKLayoutItem properties.
    *
    */
    class Layout : NSObject, NSObjectProtocol {
        
        
        // Public section
        /**
        * Allows to store meta data for debugging, layout introspection ...
        */
        var userInfo :NSDictionary?;
        
        /**
        * The layouts content scale factor
        *
        * The views frames will be set in points. With specifying the contentScaleFactor this frames will be round to perfectly match the grid.
        *
        * Default value is 1.0f;
        */
        var contentScaleFactor :Float = 1.0;
        
        /**
        * The layout delegate notifies layout steps and delegate some layout calculations.
        */
        var delegate :LayoutDelegate?;
        
        /**
        * Moves the separator creation to another instance.
        *
        * Ask for numberOfSeparators before the layout executes to prepare for layout calls.
        */
        weak var separatorDelegate :LayoutSeparatorDelegate?;
        
        /**
        * The parent layout item if layout is a sublayout
        */
        var item :LayoutItem?;
        
        /**
        * Adds spacing all around the layout contents
        */
        var margin :UIEdgeInsets =  UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        /**
        * The layouts view.
        *
        * All layout items views and sublayout views will be added into the specified layout view.
        *
        * For sublayouts the view property will be set automatically to parent layouts view.
        */
        var view :UIView?;
        
        /**
        * The layout items representing the layouts structure
        *
        * Contains instances of MKLayoutItem or its subclasses. MKLayout subclasses ensure typesafety by overwriting - (MKLayoutItem *)addView:(UIView *)view and - (MKLayoutItem *)addSublayout:(MKLayout *)sublayout
        */
        var mutableItems :Array<LayoutItem> = Array<LayoutItem>();
        
        /**
        * @param view The root layouts view or the view that needs to be layouted
        */
        // Please implement
        init(view: UIView?) {
            self.view = view;
            self.contentScaleFactor = UIScreen.mainScreen().scale;
        }
        
        // Please implement
        convenience init() {
            self.init(view: nil);
        }
        
        /**
        * Adds a subview to the layout.
        *
        * @param subview a view that will be position by the layout
        * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
        */
        func addSubview(subview: UIView?) -> LayoutItem {
            return self.insertSubview(subview, atIndex:self.mutableItems.count);
        }
        
        /**
        * Adds a sublayout to the layout.
        *
        * @param sublayout a sublayout that will be position by the layout
        * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
        */
        func addSublayout(sublayout: Layout?) -> LayoutItem {
            return self.insertSublayout(sublayout, atIndex:self.mutableItems.count);
        }
        
        /**
        * Adds a subview to the layout with a specific index.
        *
        * @param subview a view that will be position by the layout
        * @param index the position in the layout at which the subview will be inserted
        * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
        */
        func insertSubview(subview: UIView?, atIndex index:NSInteger) -> LayoutItem {
            var layoutItem = LayoutItem(layout: self, subview:subview!);
            self.insertLayoutItem(layoutItem, atIndex:index);
            return layoutItem;
        }
        
        /**
        * Adds a sublayout to the layout with a specific index.
        *
        * @param sublayout a sublayout that will be position by the layout
        * @param index the position in the layout at which the sublayout will be inserted
        * @return the associated MKLayoutItem It allows layout behavior costumization with view layout properties
        */
        func insertSublayout(sublayout: Layout?, atIndex index:NSInteger) -> LayoutItem {
            var layoutItem = LayoutItem(layout: self, sublayout:sublayout!);
            self.insertLayoutItem(layoutItem, atIndex:index);
            return layoutItem;
        }
        
        /**
        * Removed all subviews and sublayouts
        *
        *      Hint: To remove single items, checkout MKLayoutItem:removeFromLayout;
        */
        func clear() {
            var layoutItems :Array<LayoutItem> = self.mutableItems.copy();
            for layoutItem in layoutItems {
                layoutItem.removeFromLayout(); // To notify the delegate for every item that has been removed
            }
        }
        
        /**
        * Add a layout item to allow subclasses using their own item classes with custom properties
        */
        func insertLayoutItem(layoutItem :LayoutItem, atIndex index:NSInteger) {
            layoutItem.removeFromLayout();
            
            if (layoutItem.subview) {
                self.view!.addSubview(layoutItem.subview!);
            }
            if (layoutItem.sublayout?.item) {
                layoutItem.sublayout!.item = layoutItem;
                layoutItem.sublayout!.view = self.view;
                layoutItem.sublayout!.delegate = self.delegate;
                layoutItem.sublayout!.separatorDelegate = self.separatorDelegate;
            }
            
            self.mutableItems.insert(layoutItem, atIndex:index);
            
            if self.delegate {
                self.delegate!.layout(self, didAddLayoutItem: layoutItem);
            }
        }
        
        /**
        * Removes a layout item with a specified index
        *
        * @param index the index of the item that will be removed
        */
        func removeLayoutItemAtIndex(index :NSInteger) {
            
        }
        
        /**
        *  Inserts a layout item at the end of the layout
        *
        *  @param layoutItem the item, that will be added at the end of the layout
        */
        func addLayoutItem(layoutItem :LayoutItem) {
            self.insertLayoutItem(layoutItem, atIndex:self.mutableItems.count);
        }
        
        /**
        *  Removes a layout item from a layout.
        *
        * Additionally it removes its assoicated view, if its a view layout item or its associated sublayout views if its a sublayout item.
        *
        *  @param layoutItem The layout item to be removed from the layout
        */
        func removeLayoutItem(layoutItem :LayoutItem) {
            
        }
        
        /**
        * Calls layoutBounds with the associated view bounds
        */
        func layout() {
            if self.delegate {
                self.delegate!.layoutDidStartToLayout(self);
            }
            self.runLayout(self.view!.bounds);
            if self.delegate {
                self.delegate!.layoutDidFinishToLayout(self);
            }
        }
        
        /**
        * layoutBounds:(CGRect)bounds needs to be implemented by subclasses in order to achieve the layout behavior.
        *
        * It will automatically be called.
        *
        * @param bounds - The rect within the layout calculates the child position
        *
        */
        func layoutBounds(bounds :CGRect) {
            
        }
        
        /**
        * Returns the amount of separators for a specific orientation
        */
        func numberOfBordersForOrientation(orientation :Orientation) -> NSInteger {
            return 0;
        }
        
        /**
        * Flips the orientation to the opposit
        */
        func flipOrientation(orientation :Orientation) -> Orientation {
            return LayoutKit.Orientation.Horizontal;
        }
        
        /**
        *  Moves a frame within another frame edges by gravity
        *
        *  @param rect      The inner frame thats
        *  @param outerRect The outer frame within rect is beeing moved
        *  @param gravity   The gravity to which edge the rect should be moved.
        *
        *  @see MKLayoutGravity
        *
        *  @return The aligned and modified rect
        */
        func moveRect(rect :CGRect, withinRect outerRect :CGRect, gravity :Gravity) -> CGRect {
            return CGRectZero;
        }
        
        /**
        *  Rounds the rects values to numbers within a grid matches the content scale factor
        *
        *  @param rect Any rect with uneven numbers
        *
        *  @return The given rect with grid matching values. Grid of 1 mean even numbers, Grid of 2 (Retina) means half even numbers and so on.
        */
        func roundedRect(rect :CGRect) -> CGRect {
            return CGRectZero;
        }
        
        // Private section
        var bounds :CGRect = CGRectZero;
        
        func runLayout(bounds :CGRect) {
            self.bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
            
            self.layoutBounds(bounds);
            
            if (self.item?.layout == nil) {
                self.callSeparatorDelegate();
            }
            
            self.bounds = CGRectZero;
        }
        
        func callSeparatorDelegate()
        {
            
        }
        
        
    }
    
}
