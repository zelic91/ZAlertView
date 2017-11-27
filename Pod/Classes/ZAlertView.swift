//
//  ZAlertView.swift
//  Thuong Nguyen
//
//  Created by Thuong Nguyen on 1/9/16.
//

import UIKit

@objc open class ZAlertView: UIViewController {
    
    public enum AlertType: Int {
        case alert
        case confirmation
        case multipleChoice
    }
    
    public enum ShowAnimation: Int {
        case fadeIn
        case flyLeft
        case flyTop
        case flyRight
        case flyBottom
        case bounceLeft
        case bounceRight
        case bounceBottom
        case bounceTop
    }
    
    public enum HideAnimation: Int {
        case fadeOut
        case flyLeft
        case flyTop
        case flyRight
        case flyBottom
        case bounceLeft
        case bounceRight
        case bounceBottom
        case bounceTop
        
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
    open static var padding: CGFloat               = ZAlertView.Padding
    open static var innerPadding: CGFloat          = ZAlertView.InnerPadding
    open static var cornerRadius: CGFloat          = ZAlertView.CornerRadius
    open static var buttonHeight: CGFloat          = ZAlertView.ButtonHeight
    open static var buttonSectionExtraGap: CGFloat = ZAlertView.ButtonSectionExtraGap
    open static var textFieldHeight: CGFloat       = ZAlertView.TextFieldHeight
    open static var backgroundAlpha: CGFloat       = ZAlertView.BackgroundAlpha
    open static var blurredBackground: Bool        = false
    open static var showAnimation: ShowAnimation   = .fadeIn
    open static var hideAnimation: HideAnimation   = .fadeOut
    open static var duration:CGFloat               = 0.3
    open static var initialSpringVelocity:CGFloat  = 0.5
    open static var damping:CGFloat                = 0.5
    open static var statusBarStyle: UIStatusBarStyle?
    
    
    // Font
    open static var alertTitleFont: UIFont?
    open static var messageFont: UIFont?
    open static var buttonFont: UIFont?
    
    // Color
    open static var positiveColor: UIColor?            = UIColor(red:0.09, green:0.47, blue:0.24, alpha:1.0)
    open static var negativeColor: UIColor?            = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1.0)
    open static var neutralColor: UIColor?             = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
    open static var titleColor: UIColor?               = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    open static var buttonTitleColor: UIColor?         = UIColor.white
    open static var messageColor: UIColor?             = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    open static var cancelTextColor: UIColor?          = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    open static var normalTextColor: UIColor?          = UIColor.white
    open static var textFieldTextColor: UIColor?       = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    open static var textFieldBorderColor: UIColor?     = UIColor(red:0.5, green:0.55, blue:0.55, alpha:1.0)
    open static var textFieldBackgroundColor: UIColor? = UIColor.white
    
    // MARK: -
    open var alertType: AlertType = AlertType.alert
    open var alertTitle: String?
    open var message: String?
    open var messageAttributedString: NSAttributedString?
    
    open var okTitle: String? {
        didSet {
            btnOk.setTitle(okTitle, for: UIControlState())
        }
    }
    
    open var cancelTitle: String? {
        didSet {
            btnCancel.setTitle(cancelTitle, for: UIControlState())
        }
    }
    
    open var closeTitle: String? {
        didSet {
            btnClose.setTitle(closeTitle, for: UIControlState())
        }
    }
    
    open var allowTouchOutsideToDismiss: Bool = true {
        didSet {
            weak var weakSelf = self
            if weakSelf != nil {
                if allowTouchOutsideToDismiss == false {       
                    weakSelf!.tapOutsideTouchGestureRecognizer.removeTarget(weakSelf!, action: #selector(ZAlertView.dismissAlertView))
                }
                else {
                    weakSelf!.tapOutsideTouchGestureRecognizer.addTarget(weakSelf!, action: #selector(ZAlertView.dismissAlertView))
                }
            }
        }
    }
    fileprivate var tapOutsideTouchGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    open var isOkButtonLeft: Bool = false
    open var width: CGFloat = ZAlertView.AlertWidth
    open var height: CGFloat = ZAlertView.AlertHeight

    // Master views
    open var backgroundView: UIView!
    open var alertView: UIView!
    
    // View components
    var lbTitle: UILabel!
    var lbMessage: UILabel!
    var btnOk: ZButton!
    var btnCancel: ZButton!
    var btnClose: ZButton!
    var buttons: [ZButton] = []
    var textFields: [ZTextField] = []
    
    // Handlers
    open var cancelHandler: TouchHandler? = { alertView in
        alertView.dismissAlertView()
    }{
        didSet {
            btnCancel.touchHandler = cancelHandler
        }
    }
    
    open var okHandler: TouchHandler? {
        didSet {
            btnOk.touchHandler = okHandler
        }
    }
    
    open var closeHandler: TouchHandler? {
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
        self.init(title: title, message: message, alertType: AlertType.alert)
        self.closeTitle = closeButtonText
        btnClose.setTitle(closeTitle, for: UIControlState())
        self.closeHandler = closeButtonHandler
        self.btnClose.touchHandler = self.closeHandler
    }
    
    public convenience init(title: String?, message: String?, okButtonText: String?, cancelButtonText: String?) {
        self.init(title: title, message: message, alertType: AlertType.confirmation)
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, for: UIControlState())
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, for: UIControlState())
    }
    
    public convenience init(title: String?, message: String?, isOkButtonLeft: Bool?, okButtonText: String?, cancelButtonText: String?, okButtonHandler: TouchHandler?, cancelButtonHandler: TouchHandler?) {
        self.init(title: title, message: message, alertType: AlertType.confirmation)
        if let okLeft = isOkButtonLeft {
            self.isOkButtonLeft = okLeft
        }
        self.message = message
        self.okTitle = okButtonText
        self.btnOk.setTitle(okTitle, for: UIControlState())
        self.cancelTitle = cancelButtonText
        self.btnCancel.setTitle(cancelTitle, for: UIControlState())
        self.okHandler = okButtonHandler
        self.btnOk.touchHandler = self.okHandler
        self.cancelHandler = cancelButtonHandler
        self.btnCancel.touchHandler = self.cancelHandler
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWindow() {
        if viewNotReady() {
            return
        }
        let window = UIWindow(frame: (UIApplication.shared.keyWindow?.bounds)!)
        self.alertWindow = window
        self.alertWindow.windowLevel = UIWindowLevelAlert
        self.alertWindow.backgroundColor = UIColor.clear
        self.alertWindow.rootViewController = self
        self.previousWindow = UIApplication.shared.keyWindow
    }
    
    func setupViews() {
        if viewNotReady() {
            return
        }
        self.view = UIView(frame: (UIApplication.shared.keyWindow?.bounds)!)
        
        // Setup background view
        self.backgroundView = UIView(frame: self.view.bounds)
        
        // Gesture for background
        if allowTouchOutsideToDismiss == true {
            self.tapOutsideTouchGestureRecognizer.addTarget(self, action: #selector(ZAlertView.dismissAlertView))
        }
        backgroundView.addGestureRecognizer(self.tapOutsideTouchGestureRecognizer)
        self.view.addSubview(backgroundView)
        
        // Setup alert view
        self.alertView                    = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.alertView.backgroundColor    = UIColor.white
        self.alertView.layer.cornerRadius = ZAlertView.CornerRadius
        self.view.addSubview(alertView)
        
        // Setup title
        self.lbTitle               = UILabel()
        self.lbTitle.textAlignment = NSTextAlignment.center
        self.lbTitle.textColor     = ZAlertView.titleColor
        self.lbTitle.font          = ZAlertView.alertTitleFont ?? UIFont.boldSystemFont(ofSize: 16)
        self.alertView.addSubview(lbTitle)
        
        // Setup message
        self.lbMessage               = UILabel()
        self.lbMessage.textAlignment = NSTextAlignment.center
        self.lbMessage.numberOfLines = 0
        self.lbMessage.textColor     = ZAlertView.messageColor
        self.lbMessage.font          = ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14)
        self.alertView.addSubview(lbMessage)
        
        // Setup OK Button
        self.btnOk = ZButton(touchHandler: self.okHandler)
        if let okTitle = self.okTitle {
            self.btnOk.setTitle(okTitle, for: UIControlState())
        } else {
            self.btnOk.setTitle("OK", for: UIControlState())
        }
        self.btnOk.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnOk.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnOk)
        
        // Setup Cancel Button
        self.btnCancel = ZButton(touchHandler: self.cancelHandler)
        if let cancelTitle = self.cancelTitle {
            self.btnCancel.setTitle(cancelTitle, for: UIControlState())
        } else {
            self.btnCancel.setTitle("Cancel", for: UIControlState())
        }
        self.btnCancel.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnCancel.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnCancel)
        
        // Setup Close button
        self.btnClose = ZButton(touchHandler: self.closeHandler)
        if let closeTitle = self.closeTitle {
            self.btnClose.setTitle(closeTitle, for: UIControlState())
        } else {
            self.btnClose.setTitle("Close", for: UIControlState())
        }
        self.btnClose.titleLabel?.font = ZAlertView.buttonFont ?? UIFont.boldSystemFont(ofSize: 14)
        self.btnClose.titleColor = ZAlertView.buttonTitleColor
        self.alertView.addSubview(btnClose)
    }
    
    // MARK: - Life cycle
    
    open override func viewWillAppear(_ animated: Bool) {
        registerKeyboardEvents()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        unregisterKeyboardEvents()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var hasContent = false
        
        if ZAlertView.blurredBackground {
            self.backgroundView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            self.backgroundView.addSubview(UIImageView(image: UIImage.imageFromScreen().applyBlurWithRadius(2, tintColor: UIColor(white: 0.5, alpha: 0.7), saturationDeltaFactor: 1.8)))
        } else {
            self.backgroundView.backgroundColor = UIColor.black
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
        }
        
        if let title = self.alertTitle {
            hasContent      = true
            self.height     = ZAlertView.padding
            lbTitle.text    = title
            let size        = lbTitle.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight = size.height
            lbTitle.frame   = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: childHeight)
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
            lbMessage.frame = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: childHeight)
            height          += childHeight
        } else if let messageAttributedString = self.messageAttributedString {
            hasContent               = true
            self.height              += ZAlertView.padding
            lbMessage.attributedText = messageAttributedString
            let size                 = lbMessage.sizeThatFits(CGSize(width: width - ZAlertView.padding * 2, height: 600))
            let childHeight          = size.height
            lbMessage.frame          = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: childHeight)
            height                   += childHeight
        }
        
        if textFields.count > 0 {
            hasContent = true
            for textField in textFields {
                self.height += ZAlertView.innerPadding
                textField.frame = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: ZAlertView.textFieldHeight)
                self.height += ZAlertView.textFieldHeight
            }
        }
        
        self.height += ZAlertView.padding
        
        switch alertType {
        case .alert:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            let buttonWidth             = width -  ZAlertView.padding * 2
            btnClose.frame              = CGRect(x: ZAlertView.padding, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
            btnClose.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.positiveColor, size: btnClose.frame.size), for: UIControlState())
            btnClose.layer.cornerRadius = ZAlertView.cornerRadius
            btnClose.clipsToBounds      = true
            btnClose.addTarget(self, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
            self.height                 += ZAlertView.buttonHeight
            
        case .confirmation:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            let buttonWidth = (width - ZAlertView.padding * 2 - ZAlertView.innerPadding) / 2
            
            if isOkButtonLeft {
                btnOk.frame = CGRect(x: ZAlertView.padding, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
                btnCancel.frame = CGRect(x: ZAlertView.padding + ZAlertView.innerPadding + buttonWidth, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
            } else {
                btnCancel.frame = CGRect(x: ZAlertView.padding, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
                btnOk.frame = CGRect(x: ZAlertView.padding + ZAlertView.innerPadding + buttonWidth, y: height, width: buttonWidth, height: ZAlertView.buttonHeight)
            }
            
            btnCancel.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.negativeColor, size: btnCancel.frame.size), for: UIControlState())
            btnCancel.layer.cornerRadius = ZAlertView.cornerRadius
            btnCancel.clipsToBounds = true
            self.btnCancel.addTarget(self, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
            
            btnOk.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.positiveColor, size: btnOk.frame.size), for: UIControlState())
            btnOk.layer.cornerRadius = ZAlertView.cornerRadius
            btnOk.clipsToBounds = true
            self.btnOk.addTarget(self, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
            self.height += ZAlertView.buttonHeight
            
        case .multipleChoice:
            if hasContent {
                self.height += ZAlertView.buttonSectionExtraGap
            }
            for button in buttons {
                button.frame = CGRect(x: ZAlertView.padding, y: height, width: width - ZAlertView.padding * 2, height: ZAlertView.buttonHeight)
                if button.color != nil {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(button.color!, size: button.frame.size), for: UIControlState())
                } else {
                    button.setBackgroundImage(UIImage.imageWithSolidColor(ZAlertView.neutralColor, size: button.frame.size), for: UIControlState())
                }
                if button.titleColor != nil {
                    button.setTitleColor(button.titleColor!, for: UIControlState())
                } else {
                    button.setTitleColor(ZAlertView.buttonTitleColor, for: UIControlState())
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
        let bounds = UIScreen.main.bounds
        self.alertView.frame = CGRect(x: bounds.width/2 - width/2, y: bounds.height/2 - height/2, width: width, height: height)
    }
    
    // MARK: - Override methods
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        if let statusBarStyle = ZAlertView.statusBarStyle {
            return statusBarStyle
        }
        return UIApplication.shared.statusBarStyle
    }
    
    // MARK: - Convenient helpers
    
    open func addTextField(_ identifier: String, placeHolder: String) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: UIKeyboardType.default,
            font: ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
            padding: ZAlertView.padding,
            isSecured: false)
    }
    
    open func addTextField(_ identifier: String, placeHolder: String, isSecured: Bool) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: UIKeyboardType.default,
            font: ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
            padding: ZAlertView.padding,
            isSecured: true)
    }
    
    
    open func addTextField(_ identifier: String, placeHolder: String, keyboardType: UIKeyboardType) {
        addTextField(identifier,
            placeHolder: placeHolder,
            keyboardType: keyboardType,
            font: ZAlertView.messageFont ?? UIFont.systemFont(ofSize: 14),
            padding: ZAlertView.padding,
            isSecured: false)
    }
    
    open func addTextField(_ identifier: String, placeHolder: String, keyboardType: UIKeyboardType, font: UIFont, padding: CGFloat, isSecured: Bool) {
        let textField                = ZTextField(identifier: identifier)
        textField.leftView           = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: ZAlertView.textFieldHeight))
        textField.rightView          = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: ZAlertView.textFieldHeight))
        textField.leftViewMode       = UITextFieldViewMode.always
        textField.rightViewMode      = UITextFieldViewMode.always
        textField.keyboardType       = keyboardType
        textField.font               = font
        textField.placeholder        = placeHolder
        textField.layer.cornerRadius = ZAlertView.cornerRadius
        textField.layer.borderWidth  = 1

        if ZAlertView.textFieldBorderColor != nil {
            textField.layer.borderColor = ZAlertView.textFieldBorderColor!.cgColor
        } else if ZAlertView.positiveColor != nil {
            textField.layer.borderColor = ZAlertView.positiveColor!.cgColor
        }
        
        if ZAlertView.textFieldBackgroundColor != nil {
            textField.backgroundColor = ZAlertView.textFieldBackgroundColor
        }
        
        if ZAlertView.textFieldTextColor != nil {
            textField.textColor = ZAlertView.textFieldTextColor
        }
        
        textField.clipsToBounds = true
        if isSecured {
            textField.isSecureTextEntry = true
        }
        textFields.append(textField)
        self.alertView.addSubview(textField)
    }
    
    open func addButton(_ title: String, touchHandler: @escaping TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, color: UIColor?, titleColor: UIColor?, touchHandler: @escaping TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), color: color, titleColor: titleColor, touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, hexColor: String, hexTitleColor: String, touchHandler: @escaping TouchHandler) {
        addButton(title, font: ZAlertView.messageFont ?? UIFont.boldSystemFont(ofSize: 14), color: UIColor.color(hexColor), titleColor: UIColor.color(hexTitleColor), touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, font: UIFont, touchHandler: @escaping TouchHandler) {
        addButton(title, font: font, color: nil, titleColor: nil, touchHandler: touchHandler)
    }
    
    open func addButton(_ title: String, font: UIFont, color: UIColor?, titleColor: UIColor?, touchHandler: @escaping TouchHandler) {
        weak var weakSelf = self
        let button              = ZButton(touchHandler: touchHandler)
        button.setTitle(title, for: UIControlState())
        button.color            = color
        button.titleColor       = titleColor
        button.titleLabel?.font = font
        button.addTarget(weakSelf!, action: #selector(ZAlertView.buttonDidTouch(_:)), for: UIControlEvents.touchUpInside)
        buttons.append(button)
        self.alertView.addSubview(button)
    }
    
    open func getTextFieldWithIdentifier(_ identifier: String) -> UITextField? {
        return textFields.filter({ textField in
            textField.identifier == identifier
        }).first
    }
    
    @objc func buttonDidTouch(_ sender: ZButton) {
        weak var weakSelf = self
        if let listener = sender.touchHandler {
            if (weakSelf != nil) {
                listener(weakSelf!)
            }
        }
    }
    
    // MARK: - Handle keyboard
    
    func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(ZAlertView.keyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZAlertView.keyboardDidHide(_:)), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.oldFrame = self.alertView.frame
            let extraHeight = (oldFrame.size.height + oldFrame.origin.y) - (self.view.frame.size.height - keyboardSize.height)
            if extraHeight > 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.alertView.frame = CGRect(x: self.oldFrame.origin.x, y: self.oldFrame.origin.y - extraHeight - 8, width: self.oldFrame.size.width, height: self.oldFrame.size.height)
                })
            }
        }
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        if self.oldFrame == nil {
            return
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alertView.frame = self.oldFrame
        })
    }
    
    func unregisterKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Show & hide
    
    open func show() {
        if ZAlertView.duration < 0.1
        {
            ZAlertView.duration = 0.3
        }
        
        showWithDuration(Double(ZAlertView.duration))
    }
    
    @objc open func dismissAlertView() {
        
        if ZAlertView.duration < 0.1
        {
            ZAlertView.duration = 0.3
        }
        
        dismissWithDuration(0.3)
    }
    
    open func showWithDuration(_ duration: Double) {
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
        case .fadeIn:
            self.view.alpha = 0
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.alpha = 1
            }) 
        case .flyLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }) 
        case .flyRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = 1
            }) 
        case .flyBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }) 
        case .flyTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
            }) 
        case .bounceTop:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height*4, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
              
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
            
            case .bounceBottom:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
        case .bounceLeft:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
           self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
            
        case .bounceRight:
            self.backgroundView.alpha = 0
            let currentFrame = self.alertView.frame
            self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                
                self.alertView.frame = currentFrame
                self.backgroundView.alpha = ZAlertView.backgroundAlpha
                
                }, completion: {  _ in
                    
            })
        }
    }
    
    open func dismissWithDuration(_ duration: Double) {
        let completion = { (complete: Bool) -> Void in
            if complete {
                self.view.removeFromSuperview()
                self.alertWindow.isHidden = true
                self.alertWindow = nil
                self.previousWindow.makeKeyAndVisible()
                self.previousWindow = nil
            }
        }
        
        switch ZAlertView.hideAnimation {
        case .fadeOut:
            self.view.alpha = 1
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.view.alpha = 0
            }, completion: completion)
        case .flyLeft:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .flyRight:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .flyBottom:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
        case .flyTop:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration,
                animations: { () -> Void in
                    self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                    self.backgroundView.alpha = 0
                },
                completion: completion)
            
        case .bounceBottom:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
       
        case .bounceTop:
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: currentFrame.origin.x, y: -currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)

        case .bounceLeft:
            
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: self.view.frame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
            
        case .bounceRight:
            
            self.backgroundView.alpha = ZAlertView.backgroundAlpha
            let currentFrame = self.alertView.frame
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: ZAlertView.damping, initialSpringVelocity: ZAlertView.initialSpringVelocity, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.alertView.frame = CGRect(x: -currentFrame.size.width, y: currentFrame.origin.y, width: currentFrame.size.width, height: currentFrame.size.height)
                self.backgroundView.alpha = 0
                }, completion: completion)
        }
    }
    
    func viewNotReady() -> Bool {
        return UIApplication.shared.keyWindow == nil
    }
    
    open override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.layoutSubviews()
        self.view.setNeedsDisplay()
    }
    
    // MARK: - Subclasses
    
    class ZButton: UIButton {
        
        var touchHandler: TouchHandler?
        
        var color: UIColor?
        var titleColor: UIColor? {
            didSet {
                weak var weakSelf = self
                weakSelf?.setTitleColor(titleColor, for: UIControlState())
            }
        }
        
        init(touchHandler: TouchHandler?) {
            super.init(frame: CGRect.zero)
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
            super.init(frame: CGRect.zero)
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
