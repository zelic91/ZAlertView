//
//  ZAlertView.swift
//  Thuong Nguyen
//
//  Created by Thuong Nguyen on 1/9/16.
//

import UIKit

public class ZAlertView: UIViewController {
    
    public enum AlertType: Int {
        case Alert
        case Confirmation
        case MultipleChoice
    }
    
    public enum ShowAnimation: Int {
        case FadeIn
        case FlyLeft
        case FlyTop
        case FlyRight
        case FlyBottom
        case BounceLeft
        case BounceRight
        case BounceBottom
        case BounceTop
    }
    
    public enum HideAnimation: Int {
        case FadeOut
        case FlyLeft
        case FlyTop
        case FlyRight
        case FlyBottom
        case BounceLeft
        case BounceRight
        case BounceBottom
        case BounceTop
        
    }
    
    public typealias TouchHandler = (ZAlertView) -> ()

    static let Padding: CGFloat               = 12
    static let InnerPadding: CGFloat          = 8
    static let CornerRadius: CGFloat          = 4
    static let ButtonHeight: CGFloat          = 40
    static let ButtonSectionExtraGap: CGFloat = 12
    static let TextFieldHeight: CGFloat       = 40
    static let AlertWidth: CGFloat            = 280
    static let AlertHeight: CGFloat           = 65
    static let BackgroundAlpha: CGFloat       = 0.5
    
    // MARK: - Global
    public static var padding: CGFloat               = ZAlertView.Padding
    public static var innerPadding: CGFloat          = ZAlertView.InnerPadding
    public static var cornerRadius: CGFloat          = ZAlertView.CornerRadius
    public static var buttonHeight: CGFloat          = ZAlertView.ButtonHeight
    public static var buttonSectionExtraGap: CGFloat = ZAlertView.ButtonSectionExtraGap
    public static var textFieldHeight: CGFloat = ZAlertView.TextFieldHeight
    public static var backgroundAlpha: CGFloat = ZAlertView.BackgroundAlpha
    public static var blurredBackground: Bool = false
    public static var showAnimation: ShowAnimation = .FadeIn
    public static var hideAnimation: HideAnimation = .FadeOut
    public static var duration:CGFloat = 0.3
    public static var initialSpringVelocity:CGFloat = 0.5
    public static var damping:CGFloat = 0.5
    
    
    // Font
    public static var alertTitleFont: UIFont?
    public static var messageFont: UIFont?
    public static var buttonFont: UIFont?
    
    // Color
    public static var positiveColor: UIColor?    = UIColor(red:0.09, green:0.47, blue:0.24, alpha:1.0)
    public static var negativeColor: UIColor?    = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1.0)
    public static var neutralColor: UIColor?     = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
    public static var titleColor: UIColor?       = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var buttonTitleColor: UIColor? = UIColor.whiteColor()
    public static var messageColor: UIColor?     = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var cancelTextColor: UIColor?  = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    public static var normalTextColor: UIColor?  = UIColor.whiteColor()
    
    // MARK: -
    public var alertType: AlertType = AlertType.Alert
    public var alertTitle: String?
    public var message: String?
    public var messageAttributedString: NSAttributedString?
    
    public var okTitle: String? {
        didSet {
            btnOk.setTitle(okTitle, forState: UIControlState.Normal)
        }
    }
    
    public var cancelTitle: String? {
        didSet {
            btnCancel.setTitle(cancelTitle, forState: UIControlState.Normal)
        }
    }
    
    public var closeTitle: String? {
        didSet {
            btnClose.setTitle(closeTitle, forState: UIControlState.Normal)
        }
    }
    
    public var allowTouchOutsideToDismiss: Bool = true {
        didSet {
            if allowTouchOutsideToDismiss == false {
                self.tapOutsideTouchGestureRecognizer.removeTarget(self, action: "dismiss")
            }
            else {
                self.tapOutsideTouchGestureRecognizer.addTarget(self, action: "dismiss")
            }
        }
    }
    private var tapOutsideTouchGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    public var isOkButtonLeft: Bool = false
    public var width: CGFloat = ZAlertView.AlertWidth
    public var height: CGFloat = ZAlertView.AlertHeight

    // Master views
    public var backgroundView: UIView!
    public var alertView: UIView!
    
    // View components
    var lbTitle: UILabel!
    var lbMessage: UILabel!
    var btnOk: ZButton!
    var btnCancel: ZButton!
    var btnClose: ZButton!
    var buttons: [ZButton] = []
    var textFields: [ZTextField] = []
    
    // Handlers
    public var cancelHandler: TouchHandler? = { alertView in
        alertView.dismiss()
    }
    
    public var okHandler: TouchHandler? {
        didSet {
            btnOk.touchHandler = okHandler
        }
    }
    
    public var closeHandler: TouchHandler? {
        didSet {
            btnClose.touchHandler = closeHandler
        }
    }
    
    // Windows
    var previousWindow: UIWindow!
    var alertWindow: UIWindow!
    
    // Old frame
    var oldFrame: CGRect!
    
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
    }
    
    public init(title: String?, message: String?, alertType: AlertType) {
        super.init(nibName: nil, bundle: nil)
        self.setupViews()
        self.setupWindow()
        self.alertTitle = title
        self.alertType = alertType
        self.message = message
    }
    
    public convenience init(title: String?, message: String?, closeButtonText: String?, closeButtonHandler: TouchHandler?) {
        self.init(title: title, message: message, alertType: AlertType.Alert)
        self.closeTitle = closeButtonText
        btnClose.setTitle(closeTitle, forState: UIControlState.Normal)
        self.closeHandler = closeButtonHandler
        self.btnClose.touchHandler = self.closeHandler
    }
    
    public convenience init(title: String?, message: String?, okButtonText: String?, cancelButtonText: String?) {
        self.init(title: title, message: message, alertType: AlertType.Confirmation)
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, forState: UIControlState.Normal)
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, forState: UIControlState.Normal)
    }
    
    public convenience init(title: String?, message: String?, isOkButtonLeft: Bool?, okButtonText: String?, cancelButtonText: String?, okButtonHandler: TouchHandler?, cancelButtonHandler: TouchHandler?) {
        self.init(title: title, message: message, alertType: AlertType.Confirmation)
        if let okLeft = isOkButtonLeft {
            self.isOkButtonLeft = okLeft
        }
        self.message = message
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, forState: UIControlState.Normal)
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, forState: UIControlState.Normal)
        self.okHandler = okButtonHandler
        self.btnOk.touchHandler = self.okHandler
        self.cancelHandler = cancelButtonHandler
        self.btnCancel.touchHandler = self.cancelHandler
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWindow() {
        if viewNotReady() {
            return
        }
        let window = UIWindow(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
        self.alertWindow = window
        self.alertWindow.windowLevel = UIWindowLevelAlert
        self.alertWindow.backgroundColor = UIColor.clearColor()
        self.alertWindow.rootViewController = self
        self.previousWindow = UIApplication.sharedApplication().keyWindow
    }
    
    func setupViews() {
        if viewNotReady() {
            return
        }
        self.view = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
        
        // Setup background view
        self.backgroundView = UIView(frame: self.view.bounds)
        if ZAlertView.blurredBackground {
            self.backgroundView.addSubview(UIImageView(image: UIImage.imageFromScreen().applyBlurWithRadius(2, tintColor: UIColor(white: 0.5, alpha: 0.7), saturationDeltaFactor: 1.8)))
        } else {
            self.backgroundView.backgroundColor = UIColor.blackColor()
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
        }
        // Gesture for background
        if allowTouchOutsideToDismiss == true {
            self.tapOutsideTouchGestureRecognizer.addTarget(self, action: "dismiss")
        }
        backgroundView.addGestureRecognizer(self.tapOutsideTouchGestureRecognizer)
        self.view.addSubview(backgroundView)
        
        // Setup alert view
        self.alertView                    = UIView(frame: CGRectMake(0, 0, width, height))
        self.alertView.backgroundColor    = UIColor.whiteColor()
        self.alertView.layer.cornerRadius = ZAlertView.CornerRadius
        self.view.addSubview(alertView)
        
        // Setup title
        self.lbTitle               = UILabel()
        self.lbTitle.textAlignment = NSTextAlignment.Center
        self.lbTitle.textColor     = ZAlertView.titleColor
        self.lbTitle.font          = ZAlertView.alertTitleFont ?? UIFont.boldSystemFontOfSize(16)
        self.alertView.addSubview(lbTitle)
        
        // Setup message
        self.lbMessage               = UILabel()
        self.lbMessage.textAlignment = NSTextAlignment.Center
        self.lbMessage.numberOfLines = 0
        self.lbMessage.textColor     = ZAlertView.messageColor
        self.lbMessage.font          = ZAlertView.messageFont ?? UIFont.systemFontOfSize(14)
        self.alertView.addSubview(lbMessage)
        
        // Setup OK Button
        self.btnOk = ZButton(touchHandler: self.okHandler)
        if let okTitle = self.okTitle {
            self.btnOk.setTitle(okTitle, forState: UIControlState.Normal)
        } else {
            self.btnOk.setTitle("OK", forState: UIControlState.Normal)
        }
        self.btnOk.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFontOfSize(14)
        self.btnOk.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnOk)
        
        // Setup Cancel Button
        self.btnCancel = ZButton(touchHandler: self.cancelHandler)
        if let cancelTitle = self.cancelTitle {
            self.btnCancel.setTitle(cancelTitle, forState: UIControlState.Normal)
        } else {
            self.btnCancel.setTitle("Cancel", forState: UIControlState.Normal)
        }
        self.btnCancel.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFontOfSize(14)
        self.btnCancel.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnCancel)
        
        // Setup Close button
        self.btnClose = ZButton(touchHandler: self.closeHandler)
        if let closeTitle = self.closeTitle {
            self.btnClose.setTitle(closeTitle, forState: UIControlState.Normal)
        } else {
            self.btnClose.setTitle("Close", forState: UIControlState.Normal)
        }
        self.btnClose.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFontOfSize(14)
        self.btnClose.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnClose)
    }
    
    // MARK: - Life cycle
    
    public override func viewWillAppear(animated: Bool) {
        registerKeyboardEvents()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        unregisterKeyboardEvents()
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var hasContent = false
        
        if let title = self.alertTitle {
            hasContent      = true
            self.height     = ZAlertView.padding
            lbTitle.text    = title
            let size        = lbTitle.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight = size.height
            lbTitle.frame   = CGRectMake(ZAlertView.padding, height, width - ZAlertView.padding * 2, childHeight)
            height          += childHeight
        } else {
            self.height = 0
        }
        
        if let message = self.message {
            hasContent      = true
            self.height     += ZAlertView.padding
            lbMessage.text  = message
            let size        = lbMessage.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight = size.height
            lbMessage.frame = CGRectMake(ZAlertView.padding, height, width - ZAlertView.padding * 2, childHeight)
            height          += childHeight
        } else if let messageAttributedString = self.messageAttributedString {
            hasContent               = true
            self.height              += ZAlertView.padding
            lbMessage.attributedText = messageAttributedString
            let size                 = lbMessage.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight          = size.height
            lbMessage.frame          = CGRectMake(ZAlertView.padding, height, width - ZAlertView.padding * 2, childHeight)
            height                   += childHeight
        }
        
        if textFields.count > 0 {
            hasContent = true
            for textField in textFields {
                self.height += ZAlertView.innerPadding
                textField.frame = CGRectMake(ZAlertView.padding, height, width - ZAlertView.padding * 2, ZAlertView.textFieldHeight)
                self.height += ZAlertView.textFieldHeight
            }
        }
        
        self.height += ZAlertView.padding
        
        switch alertType {
        case .Alert:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            let buttonWidth             = width -  ZAlertView.padding * 2
            btnClose.frame              = CGRectMake(ZAlertView.padding, height, buttonWidth, ZAlertView.buttonHeight)
            btnClose.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.positiveColor, size: btnClose.frame.size), forState: UIControlState.Normal)
            btnClose.layer.cornerRadius = ZAlertView.cornerRadius
            btnClose.clipsToBounds      = true
            btnClose.addTarget(self, action: Selector("buttonDidTouch:"), forControlEvents: UIControlEvents.TouchUpInside)
            self.height                 += ZAlertView.buttonHeight
            
        case .Confirmation:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            let buttonWidth = (width - ZAlertView.padding * 2 - ZAlertView.innerPadding) / 2
            
            if isOkButtonLeft {
                btnOk.frame = CGRectMake(ZAlertView.padding, height, buttonWidth, ZAlertView.buttonHeight)
                btnCancel.frame = CGRectMake(ZAlertView.padding + ZAlertView.innerPadding + buttonWidth, height, buttonWidth, ZAlertView.buttonHeight)
            } else {
                btnCancel.frame = CGRectMake(ZAlertView.padding, height, buttonWidth, ZAlertView.buttonHeight)
                btnOk.frame = CGRectMake(ZAlertView.padding + ZAlertView.innerPadding + buttonWidth, height, buttonWidth, ZAlertView.buttonHeight)
            }
            
            btnCancel.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.negativeColor, size: btnCancel.frame.size), forState: UIControlState.Normal)
            btnCancel.layer.cornerRadius = ZAlertView.cornerRadius
            btnCancel.clipsToBounds = true
            self.btnCancel.addTarget(self, action: Selector("buttonDidTouch:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            btnOk.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.positiveColor, size: btnOk.frame.size), forState: UIControlState.Normal)
            btnOk.layer.cornerRadius = ZAlertView.cornerRadius
            btnOk.clipsToBounds = true
            self.btnOk.addTarget(self, action: Selector("buttonDidTouch:"), forControlEvents: UIControlEvents.TouchUpInside)
            self.height += ZAlertView.buttonHeight
            
        case .MultipleChoice:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            for button in buttons {
                button.frame = CGRectMake(ZAlertView.padding, height, width - ZAlertView.padding * 2, ZAlertView.buttonHeight)
                if button.color != nil {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(button.color!, size: button.frame.size), forState: UIControlState.Normal)
                } else {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.neutralColor, size: button.frame.size), forState: UIControlState.Normal)
                }
                if button.titleColor != nil {
                    button.setTitleColor(button.titleColor!, forState: .Normal)
                } else {
                    button.setTitleColor(ZAlertView.buttonTitleColor, forState: .Normal)
                }
                button.layer.cornerRadius = ZAlertView.cornerRadius
                button.clipsToBounds = true
                self.height += ZAlertView.buttonHeight
                if button != buttons.last {
                    self.height += ZAlertView.innerPadding
                }
            }
        }
        
        self.height += ZAlertView.padding
        let bounds = self.view.bounds
        self.alertView.frame = CGRectMake(bounds.width/2 - width/2, bounds.height/2 - height/2, width, height)
    }
    
    // MARK: - Convenient helpers
    
    public func addTextField(identifier: String, placeHolder: String) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: UIKeyboardType.Default,
            font: ZAlertView.messageFont ?? UIFont.systemFontOfSize(14),
            padding: ZAlertView.padding,
            isSecured: false)
    }
    
    public func addTextField(identifier: String, placeHolder: String, isSecured: Bool) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: UIKeyboardType.Default,
            font: ZAlertView.messageFont ?? UIFont.systemFontOfSize(14),
            padding: ZAlertView.padding,
            isSecured: true)
    }
    
    
    public func addTextField(identifier: String, placeHolder: String, keyboardType: UIKeyboardType) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: keyboardType,
            font: ZAlertView.messageFont ?? UIFont.systemFontOfSize(14),
            padding: ZAlertView.padding,
            isSecured: false)
    }
    
    public func addTextField(identifier: String, placeHolder: String, keyboardType: UIKeyboardType, font: UIFont, padding: CGFloat, isSecured: Bool) {
        let textField                = ZTextField(identifier: identifier)
        textField.leftView           = UIView(frame: CGRectMake(0, 0, padding, ZAlertView.textFieldHeight))
        textField.rightView          = UIView(frame: CGRectMake(0, 0, padding, ZAlertView.textFieldHeight))
        textField.leftViewMode       = UITextFieldViewMode.Always
        textField.rightViewMode      = UITextFieldViewMode.Always
        textField.keyboardType       = keyboardType
        textField.font               = font
        textField.placeholder        = placeHolder
        textField.layer.cornerRadius = ZAlertView.cornerRadius
        textField.layer.borderWidth  = 1
        if ZAlertView.positiveColor != nil {
            textField.layer.borderColor = ZAlertView.positiveColor!.CGColor
        }
        textField.clipsToBounds = true
        if isSecured {
            textField.secureTextEntry = true
        }
        textFields.append(textField)
        self.alertView.addSubview(textField)
        
    }
    
    public func addButton(title: String, touchHandler: TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFontOfSize(14), touchHandler: touchHandler)
    }
    
    public func addButton(title: String, color: UIColor?, titleColor: UIColor?, touchHandler: TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFontOfSize(14), color: color, titleColor: titleColor, touchHandler: touchHandler)
    }
    
    public func addButton(title: String, hexColor: String, hexTitleColor: String, touchHandler: TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFontOfSize(14), color: UIColor.color(hexColor), titleColor: UIColor.color(hexTitleColor), touchHandler: touchHandler)
    }
    
    public func addButton(title: String, font: UIFont, touchHandler: TouchHandler) {
        addButton(title, font: font, color: nil, titleColor: nil, touchHandler: touchHandler)
    }
    
    public func addButton(title: String, font: UIFont, color: UIColor?, titleColor: UIColor?, touchHandler: TouchHandler) {
        let button              = ZButton(touchHandler: touchHandler)
        button.setTitle(title, forState: .Normal)
        button.color            = color
        button.titleColor       = titleColor
        button.titleLabel?.font = font
        button.addTarget(self, action: Selector("buttonDidTouch:"), forControlEvents: UIControlEvents.TouchUpInside)
        buttons.append(button)
        self.alertView.addSubview(button)
    }
    
    public func getTextFieldWithIdentifier(identifier: String) -> UITextField? {
        return textFields.filter({ textField in
            textField.identifier == identifier
        }).first
    }
    
    func buttonDidTouch(sender: ZButton) {
        if let listener = sender.touchHandler {
            listener(self)
        }
    }
    
    // MARK: - Handle keyboard
    
    func registerKeyboardEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name:UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidHide:"), name:UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo
        let keyboardSize = (info![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size)!
        self.oldFrame = self.alertView.frame
        let extraHeight = (oldFrame.size.height + oldFrame.origin.y) - (self.view.frame.size.height - keyboardSize.height)
        if extraHeight > 0 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alertView.frame = CGRectMake(self.oldFrame.origin.x, self.oldFrame.origin.y - extraHeight - 8, self.oldFrame.size.width, self.oldFrame.size.height)
            })
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        if self.oldFrame == nil {
            return
        }
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alertView.frame = self.oldFrame
        })
    }
    
    func unregisterKeyboardEvents() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Show & hide
    
    public func show() {
        if ZAlertView.duration < 0.1
        {
            ZAlertView.duration = 0.3
        }
        
        showWithDuration(Double(ZAlertView.duration))
    }
    
    public func dismiss() {
        
        if ZAlertView.duration < 0.1
        {
            ZAlertView.duration = 0.3
        }
        
        dismissWithDuration(0.3)
    }
    
    public func showWithDuration(duration: Double) {
        if viewNotReady() {
            return
        }
        
        if ZAlertView.damping <= 0
        {
            ZAlertView.damping = 0.1
        }
        else if ZAlertView.damping >= 1
        {
            ZAlertView.damping = 1
        }
        
        if ZAlertView.initialSpringVelocity <= 0
        {
            ZAlertView.initialSpringVelocity = 0.1
        }
        else if ZAlertView.initialSpringVelocity >= 1
        {
            ZAlertView.initialSpringVelocity = 1
        }
        
        
        self.alertWindow.addSubview(self.view)
        self.alertWindow.makeKeyAndVisible()
        switch ZAlertView.showAnimation {
        case .FadeIn:
            self.view.alpha = 0
            UIView.animateWithDuration(duration) { () -> Void in
                self.view.alpha = 1
            }
        case .FlyLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(duration) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }
        case .FlyRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(duration) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = 1
            }
        case .FlyBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(duration) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }
        case .FlyTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height, currentFrame.size.width, currentFrame.size.height)
            UIView.animateWithDuration(duration) { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }
        case .BounceTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height*4, currentFrame.size.width, currentFrame.size.height)
            
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
              
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  fn in
                    
            })
            
            case .BounceBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
            
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  fn in
                    
            })
        case .BounceLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
           self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  fn in
                    
            })
            
        case .BounceRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
            
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  fn in
                    
            })
            



            
          
        default:
            break
        }
    }
    
    public func dismissWithDuration(duration: Double) {
        let completion = { (complete: Bool) -> Void in
            if complete {
                self.view.removeFromSuperview()
                self.alertWindow.hidden = true
                self.alertWindow = nil
                self.previousWindow.makeKeyAndVisible()
                self.previousWindow = nil
            }
        }
        
        switch ZAlertView.hideAnimation {
        case .FadeOut:
            self.view.alpha = 1
            UIView.animateWithDuration(duration,
                animations: { () -> Void in
                    self.view.alpha = 0
            }, completion: completion)
        case .FlyLeft:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .FlyRight:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .FlyBottom:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .FlyTop:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height, currentFrame.size.width, currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
            
        case .BounceBottom:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(currentFrame.origin.x, self.view.frame.size.height, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
       
        case .BounceTop:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(currentFrame.origin.x, -currentFrame.size.height, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)

        case .BounceLeft:
            
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
            
        case .BounceRight:
            
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRectMake(-currentFrame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
            
        default:
            break
        }
    }
    
    func viewNotReady() -> Bool {
        return UIApplication.sharedApplication().keyWindow == nil
    }
    
    // MARK: - Subclasses
    
    class ZButton: UIButton {
        
        var touchHandler: TouchHandler?
        
        var color: UIColor?
        var titleColor: UIColor? {
            didSet {
                self.setTitleColor(titleColor, forState: .Normal)
            }
        }
        
        init(touchHandler: TouchHandler?) {
            super.init(frame: CGRectZero)
            self.touchHandler = touchHandler
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    
    class ZTextField: UITextField {
        
        var identifier: String!
        
        init(identifier: String) {
            super.init(frame: CGRectZero)
            self.identifier = identifier
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
    }
}
