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
               rightButtonTitle: String? = nil,
               rightButtonStyle: UIAlertAction.Style = .default,
               rightButtonHandler: AlertActionHandler? = nil,
               defaultButtonTitle: String? = nil) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        if let okClosure = rightButtonHandler {
            let okAction: UIAlertAction = UIAlertAction(title: rightButtonTitle, style: rightButtonStyle, handler: okClosure)
            let cancelAction: UIAlertAction = UIAlertAction(title: defaultButtonTitle, style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
        } else {
            if let _ = defaultButtonTitle {
                
                let cancelAction: UIAlertAction = UIAlertAction(title: rightButtonTitle, style: rightButtonStyle)
                alert.addAction(cancelAction)
            } else {
                let cancelAction: UIAlertAction = UIAlertAction(title: rightButtonTitle, style: rightButtonStyle)
                alert.addAction(cancelAction)
            }
            
        }
        self.present(alert, animated: true)
    }
}

