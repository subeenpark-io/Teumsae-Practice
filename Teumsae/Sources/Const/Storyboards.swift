//
//  Storyboards.swift
//  Teumsae
//
//  Created by Subeen Park on 2021/10/30.
//

import UIKit

extension Const {
    
    enum Storyboard: String {
            
            case recording = "Recording"

            
            var storyboard: UIStoryboard {
                UIStoryboard(name: self.rawValue, bundle: nil)
                
            }
            
            var viewController: UIViewController {
                let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
                return storyboard.instantiateViewController(withIdentifier: "\(self.rawValue)ViewController")
            }
        
    }
    
}
