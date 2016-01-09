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
        ZAlertView.positiveColor = UIColor.color("#669999")!
        ZAlertView.negativeColor = UIColor.color("#CC3333")!
        ZAlertView.blurredBackground = true
        ZAlertView.showAnimation = .FadeIn
        ZAlertView.hideAnimation = .FlyBottom
    }
    
    @IBAction func alertDialogButtonDidTouch(sender: AnyObject) {
        let dialog = ZAlertView(title: "Success",
            message: "Thank you for purchasing our products. Have a nice day.",
            closeButtonText: "Okay",
            closeButtonHandler: { alertView in
                alertView.dismiss()
            }
        )
        
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
        
        dialog.addButton("Share to Facebook", touchHandler: { alertView in
            alertView.dismiss()
        })
        
        dialog.addButton("Share to Twitter", touchHandler: { alertView in
            alertView.dismiss()
        })
        
        dialog.addButton("Invite friends", hexColor: "#9b59b6", hexTitleColor: "#FFFFFF", touchHandler: { alertView in
            alertView.dismiss()
        })
        
        dialog.show()
    }
}

