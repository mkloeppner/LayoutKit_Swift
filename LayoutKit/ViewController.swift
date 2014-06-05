//
//  ViewController.swift
//  LayoutKit
//
//  Created by Martin Klöppner on 05/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var layout :LayoutKit.Layout?;
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.layout = LayoutKit.LinearLayout(view: self.view);
        
        var greenView = UIView();
        greenView.backgroundColor = UIColor.greenColor();
        
        var greenViewItem = self.layout!.addSubview(greenView);
        greenViewItem.size = CGSizeMake(30.0, 30.0);
        
        self.layout!.layout();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

