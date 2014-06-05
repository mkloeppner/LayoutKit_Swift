//
//  LayoutDelegate.swift
//  LayoutKit
//
//  Created by Martin Klöppner on 05/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

import Foundation

protocol LayoutDelegate {
    func layoutDidStartToLayout(layout: LayoutKit.Layout);
    func layoutDidFinishToLayout(layout: LayoutKit.Layout);
    func layout(layout: LayoutKit.Layout, didAddLayoutItem layoutItem:LayoutKit.LayoutItem);
}