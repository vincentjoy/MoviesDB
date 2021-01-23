//
//  ReusableUIComponent.swift
//  MoviesDB
//
//  Created by Rehlat Online Services Pvt Ltd on 23/01/21.
//

import UIKit

protocol InputAccessoryProtocol: class {
    func createInputAccessoryView() -> UIToolbar
}

extension InputAccessoryProtocol where Self: UIViewController {
    
    func createInputAccessoryView() -> UIToolbar {
        
        let toolbarAccessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolbarAccessoryView.barStyle = .default
        toolbarAccessoryView.tintColor = UIColor.blue
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target:nil, action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:.done, target:self, action:Selector(("doneTouched")))
        toolbarAccessoryView.setItems([flexSpace, doneButton], animated: false)
        
        return toolbarAccessoryView
    }
}
