//
//  ViewController.swift
//  ZAlertView
//
//  Created by Thuong Nguyen on 01/09/2016.
//  Copyright (c) 2016 Thuong Nguyen. All rights reserved.
//

import UIKit
import ZAlertView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ZAlertView.positiveColor            = UIColor.color("#669999")
        ZAlertView.negativeColor            = UIColor.color("#CC3333")
        ZAlertView.blurredBackground        = true
        ZAlertView.showAnimation            = .bounceBottom
        ZAlertView.hideAnimation            = .bounceRight
        ZAlertView.initialSpringVelocity    = 0.9
        ZAlertView.duration                 = 2
        ZAlertView.textFieldTextColor       = UIColor.brown
        ZAlertView.textFieldBackgroundColor = UIColor.color("#EFEFEF")
        ZAlertView.textFieldBorderColor     = UIColor.color("#669999")
    }

    @IBAction func alertDialogButtonDidTouch(_ sender: AnyObject) {
        let dialog = ZAlertView(title: "Success",
            message: "Thank you for purchasing our products. Have a nice day.",
            closeButtonText: "Okay",
            closeButtonHandler: { alertView in
                alertView.dismissAlertView()
            }
        )
        dialog.allowTouchOutsideToDismiss = false
        let attrStr = NSMutableAttributedString(string: "Are you sure you want to quit?")
        attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSMakeRange(10, 12))
        dialog.messageAttributedString = attrStr
        dialog.show()
    }
    
    @IBAction func confirmDialogButtonDidTouch(_ sender: AnyObject) {
        let dialog = ZAlertView(title: "Quit",
            message: "Are you sure you want to quit?",
            isOkButtonLeft: true,
            okButtonText: "Sure",
            cancelButtonText: "No",
            okButtonHandler: { (alertView) -> () in
                alertView.dismissAlertView()
            },
            cancelButtonHandler: { (alertView) -> () in
                alertView.dismissAlertView()
            }
        )
        dialog.show()
        dialog.allowTouchOutsideToDismiss = true
    }
    
    @IBAction func inputDialogButtonDidTouch(_ sender: AnyObject) {
        let dialog = ZAlertView(title: "Login", message: "Please enter your information", isOkButtonLeft: false, okButtonText: "Login", cancelButtonText: "Cancel",
            okButtonHandler: { alertView in
                alertView.dismissAlertView()
            },
            cancelButtonHandler: { alertView in
                alertView.dismissAlertView()
            }
        )
        dialog.addTextField("username", placeHolder: "Username")
        dialog.addTextField("password", placeHolder: "Password", isSecured: true)
        dialog.show()
    }

    @IBAction func multipleChoiceDialogButtonDidTouch(_ sender: AnyObject) {
        let dialog = ZAlertView(title: "More", message: nil, alertType: ZAlertView.AlertType.multipleChoice)
        
        dialog.addButton("Share to Facebook", hexColor: "#EFEFEF", hexTitleColor: "#999999", touchHandler: { alertView in
            alertView.dismissAlertView()
        })
        
        dialog.addButton("Share to Twitter", hexColor: "#EFEFEF", hexTitleColor: "#999999", touchHandler: { alertView in
            alertView.dismissAlertView()
        })
        
        dialog.addButton("Invite friends", hexColor: "#9b59b6", hexTitleColor: "#FFFFFF", touchHandler: { alertView in
            alertView.dismissAlertView()
        })
        
        dialog.show()
    }
}

