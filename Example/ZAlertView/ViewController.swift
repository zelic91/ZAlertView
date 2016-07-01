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
        ZAlertView.showAnimation            = .BounceBottom
        ZAlertView.hideAnimation            = .BounceRight
        ZAlertView.initialSpringVelocity    = 0.9
        ZAlertView.duration                 = 2
        ZAlertView.textFieldTextColor       = UIColor.brownColor()
        ZAlertView.textFieldBackgroundColor = UIColor.color("#EFEFEF")
        ZAlertView.textFieldBorderColor     = UIColor.color("#669999")
    }
    
    @IBAction func alertDialogButtonDidTouch(sender: AnyObject) {
        let dialog = ZAlertView(title: "Success",
            message: "Thank you for purchasing our products. Have a nice day.",
            closeButtonText: "Okay",
            closeButtonHandler: { alertView in
                alertView.dismiss()
            }
        )
        dialog.allowTouchOutsideToDismiss = false
        let attrStr = NSMutableAttributedString(string: "Are you sure you want to quit?")
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(10, 12))
        dialog.messageAttributedString = attrStr
        dialog.show()
    }
    
    @IBAction func confirmDialogButtonDidTouch(sender: AnyObject) {
        let dialog = ZAlertView(title: "Quit",
            message: "Are you sure you want to quit?",
            isOkButtonLeft: true,
            okButtonText: "Sure",
            cancelButtonText: "No",
            okButtonHandler: { (alertView) -> () in
                alertView.dismiss()
            },
            cancelButtonHandler: { (alertView) -> () in
                alertView.dismiss()
            }
        )
        dialog.show()
        dialog.allowTouchOutsideToDismiss = true
    }
    
    @IBAction func inputDialogButtonDidTouch(sender: AnyObject) {
        let dialog = ZAlertView(title: "Login", message: "Please enter your information", isOkButtonLeft: false, okButtonText: "Login", cancelButtonText: "Cancel",
            okButtonHandler: { alertView in
                alertView.dismiss()
            },
            cancelButtonHandler: { alertView in
                alertView.dismiss()
            }
        )
        dialog.addTextField("username", placeHolder: "Username")
        dialog.addTextField("password", placeHolder: "Password", isSecured: true)
        dialog.show()
    }

    @IBAction func multipleChoiceDialogButtonDidTouch(sender: AnyObject) {
        let dialog = ZAlertView(title: "More", message: nil, alertType: ZAlertView.AlertType.MultipleChoice)
        
        dialog.addButton("Share to Facebook", hexColor: "#EFEFEF", hexTitleColor: "#999999", touchHandler: { alertView in
            alertView.dismiss()
        })
        
        dialog.addButton("Share to Twitter", hexColor: "#EFEFEF", hexTitleColor: "#999999", touchHandler: { alertView in
            alertView.dismiss()
        })
        
        dialog.addButton("Invite friends", hexColor: "#9b59b6", hexTitleColor: "#FFFFFF", touchHandler: { alertView in
            alertView.dismiss()
        })
        
        dialog.show()
    }
}

