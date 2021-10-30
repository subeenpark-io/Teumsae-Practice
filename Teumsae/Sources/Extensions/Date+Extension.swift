//
//  Date+Extension.swift
//  Teumsae
//
//  Created by Subeen Park on 2021/10/30.
//

import Foundation


extension Date {
    
    // Reference: https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
