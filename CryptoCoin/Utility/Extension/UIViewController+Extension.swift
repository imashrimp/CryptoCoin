//
//  UIViewController+Extension.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/29/24.
//

import UIKit

extension UIViewController {
    
    typealias AlertActionHandler = ((UIAlertAction) -> Void)
    
    func alert(title: String,
               leftButtonTitle: String? = nil,
               leftButtonStyle: UIAlertAction.Style = .default,
               leftButtonHandler: AlertActionHandler? = nil,
               rightButtonTitle: String? = nil,
               rightButtonStyle: UIAlertAction.Style = .cancel) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        if let okClosure = leftButtonHandler {
            let okAction: UIAlertAction = UIAlertAction(title: leftButtonTitle, style: leftButtonStyle, handler: okClosure)
            let cancelAction: UIAlertAction = UIAlertAction(title: rightButtonTitle, style: rightButtonStyle)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
        } else {
            if let _ = rightButtonTitle {
                
                let cancelAction: UIAlertAction = UIAlertAction(title: leftButtonTitle, style: leftButtonStyle)
                alert.addAction(cancelAction)
            } else {
                let cancelAction: UIAlertAction = UIAlertAction(title: leftButtonTitle, style: leftButtonStyle)
                alert.addAction(cancelAction)
            }
            
        }
        self.present(alert, animated: true)
    }
}

