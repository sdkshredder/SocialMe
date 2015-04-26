//
//  SignUpVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/17/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController, UITextFieldDelegate {
	
	var (username, password, email) = (UITextField(), UITextField(), UITextField())
	let (circle, check, x, bg, label, info) = (UIImageView(), UIImageView(), UIImageView(), UIView(), UILabel(), UILabel())
	
	override func viewDidLoad() {
		super.viewDidLoad();
		self.initDisplay()
	}
	
	func initDisplay() {
		initBGTap()
		addBackButton()
		addLogo()
		usernameInit()
		passwordInit()
		emailInit()
	}
	
	func usernameInit() {
		var inset = self.view.frame.width/10.0
		username.frame = CGRectMake(inset, 66, self.view.frame.width - inset * 2, 60)
		username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
		username.font = UIFont(name: "HelveticaNeue-Light", size: 18)
		username.delegate = self
		username.autocapitalizationType =  .None
		view.addSubview(username)
		addDiv(username)
	}
	
	func passwordInit() {
		var inset = self.view.frame.width/10.0
		password.frame = CGRectMake(inset, 126, self.view.frame.width - inset * 2, 60)
		password.attributedPlaceholder = NSAttributedString(string:"Password",
			attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
		password.font = UIFont(name: "HelveticaNeue-Light", size: 18)
		password.delegate = self
		password.secureTextEntry = true
		self.view.addSubview(password)
		self.addDiv(password)
	}
	
	func emailInit() {
		var inset = self.view.frame.width/10.0
		email.frame = CGRectMake(inset, 186, self.view.frame.width - inset * 2, 60)
		email.attributedPlaceholder = NSAttributedString(string:"Email",
			attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
		email.font = UIFont(name: "HelveticaNeue-Light", size: 18)
		email.delegate = self
		self.view.addSubview(email)
		self.addDiv(email)
	}
	
	func age() {
		
	}
	
	
	func formatLabel(frame: CGRect) {
		label.frame = frame
		label.text = "SIGN UP"
		label.textColor = UIColor.blackColor()
		label.textAlignment = .Center
		label.alpha = 0
		label.userInteractionEnabled = true
	}
	
	func addSignUpButton() {
		var frame = CGRectMake(0, 247, self.view.frame.width, 66)
		bg.frame = CGRectMake(0, 247, self.view.frame.width, 0)
		bg.backgroundColor = UIColor.greenColor()
		self.view.addSubview(bg)
		
		formatLabel(frame)
		
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
		let listener = UITapGestureRecognizer(target: self, action: "signUpUser:")
		label.addGestureRecognizer(listener)
		self.view.addSubview(label)
		
		UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
			self.bg.frame = frame
			}, completion: {
				(value: Bool) in
				UIView.animateWithDuration(0.1, animations: {
					self.label.alpha = 1
				})
		})
	}
	
	func signUpUser(sender: UITapGestureRecognizer) {
		var user = PFUser()
		(user.username, user.password, user.email) =
			(username.text, password.text, email.text)
		
		user.signUpInBackgroundWithBlock {
			(succeeded, error) -> Void in
			if error == nil {
				println("success for user \(user.username)")
				let tabVC : UITabBarController = self.storyboard!
					.instantiateViewControllerWithIdentifier("tab")
					as! UITabBarController
				
				self.presentViewController(tabVC,
					animated: true,
					completion: nil)
			} else {
				let alert = UIAlertView(title: "Error", message: error?.description, delegate: self, cancelButtonTitle: "okay")
				alert.show()
			}
		}
	}
	
	func setupX(textField : UITextField) {
		var a = (textField.frame.height - 18) / 2
		x.frame = CGRectMake(0, 0, 18, 18)
		x.frame.origin = CGPointMake(textField.frame.width - 18, a)
		x.image = UIImage(named: "x")
		x.alpha = 0
	}
	
	func addX(textField : UITextField) {
		
		setupX(textField)
		textField.addSubview(x)
		
		let rightShake = CGAffineTransformMakeRotation(0.2)
		let leftShake = CGAffineTransformMakeRotation(-0.2)
		let none = CGAffineTransformMakeRotation(0)
		
		UIView.animateWithDuration(0.1, delay: 0, options: nil, animations: {
			self.x.alpha = 1
			}, completion: {
				(value: Bool) in
				UIView.animateWithDuration(0.06, delay: 0, options: UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.CurveEaseOut, animations: {
					self.x.transform = rightShake
					}, completion: {
						(value: Bool) in
						self.x.transform = none
						UIView.animateWithDuration(0.06, delay: 0, options: UIViewAnimationOptions.Autoreverse  | UIViewAnimationOptions.CurveEaseIn, animations: {
							self.x.transform = leftShake
							}, completion: {
								(value: Bool) in
								self.x.transform = none
						})
				})
		})
		
	}
	
	func addCheck(textField : UITextField) {
		
		var a = (textField.frame.height - 34) / 2
		circle.frame = CGRectMake(0, 0, 34, 34)
		circle.frame.origin = CGPointMake(textField.frame.width - 34, a)
		circle.image = UIImage(named: "check-outline")
		circle.alpha = 0.3
		
		var mask = CALayer()
		var w = circle.frame.width * 2
		var o = circle.frame.origin
		
		mask.frame = CGRectMake(-w, w, w, w)
		mask.contents = UIImage(named: "mask")?.CGImage
		
		circle.layer.mask = mask
		textField.addSubview(circle)
		
		let animation = CABasicAnimation(keyPath: "position")
		animation.fromValue = mask.valueForKey("position")
		animation.toValue = NSValue(CGPoint: CGPointMake(w, -w))
		animation.duration = 0.6
		
		check.frame = circle.frame
		check.image = UIImage(named: "check")
		check.alpha = 0
		textField.addSubview(check)
		
		UIView.animateWithDuration(0.8, delay: 0, options: .CurveEaseOut, animations: {
			self.check.alpha = 1
			}, completion: nil)
		
		UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
			}, completion: {
				(value: Bool) in
				mask.addAnimation(animation, forKey: "position")
		})
		
	}
	
	func usernameAvailable() {
		if username.text == "" {
			
		}
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			var query = PFUser.query()
			query!.whereKey("username", equalTo:self.username.text)
			var res : NSArray = query!.findObjects()!
			dispatch_async(dispatch_get_main_queue()) {
				if res.count == 0 {
					self.addCheck(self.username)
				} else {
					self.addX(self.username)
				}
			}
		}
	}
	
	func removeIndicators(textField: UITextField) {
		UIView.animateWithDuration(0.3, animations: {
			self.circle.alpha = 0
			self.check.alpha = 0
			self.info.alpha = 0
			self.x.alpha = 0
		})
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		if textField.placeholder == "Password" {
			usernameAvailable()
			
		} else if textField.placeholder == "Email" {
			if bg.frame.height == 0 {
				addSignUpButton()
			}
		} else {
			removeIndicators(username)
		}
	}
	
	func removeButton() {
		if (password.text == "" && label.frame.height != 0) {
			UIView.animateWithDuration(0.1, animations: {
				self.label.alpha = 0
				}, completion: {
					(value: Bool) in
					UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
						self.bg.frame = CGRectMake(0, self.bg.frame.origin.y, self.view.frame.width, 0)
						}, completion: nil)
			})
		}
	}
	
	func initBGTap() {
		let bgTap = UIButton(frame: view.frame)
		bgTap.addTarget(self, action: "bgTap:", forControlEvents: UIControlEvents.TouchUpInside)
		view.addSubview(bgTap)
	}
	
	func addDiv(tf: UITextField) {
		let div = UIView(frame: CGRectMake(0, tf.frame.origin.y + tf.frame.size.height, self.view.frame.width, 1))
		div.backgroundColor = UIColor.grayColor()
		self.view.addSubview(div)
	}
	
	func addLogo() {
		let logo = UILabel(frame: CGRectMake(self.view.frame.width/2 - 80, 0, 160, 80))
		logo.text = "SocialMe"
		logo.textColor = UIColor.grayColor()
		logo.font = UIFont(name: "HelveticaNeue-Light", size: 33)
		logo.textAlignment = .Center
		self.view.addSubview(logo)
	}
	
	func addBackButton() {
		let nav = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.width, 64))
		let back = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "barButtonItemClicked:")
		let b = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "back:")
		let n = UINavigationItem()
		n.setLeftBarButtonItem(b, animated: true)
		nav.pushNavigationItem(n, animated: true)
		nav.tintColor = UIColor.grayColor()
		self.view.addSubview(nav)
	}
	
	func back(sender: UIBarButtonItem) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
}
