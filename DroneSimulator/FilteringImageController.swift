//
//  FilteringImageController.swift
//  DroneSimulator
//
//  Created by KyungYoung Heo on 2018. 9. 8..
//  Copyright © 2018년 KyungYoung Heo. All rights reserved.
//

import UIKit
import Alamofire

class FilteringImageController: UIViewController {
	var imgView = UIImageView()
	var filenameLabel = UILabel()
	var imageId = UILabel()
	var imageIdField = UITextField()
	var pointNumber = UILabel()
	var pointNumberField = UITextField()
	var leafSize = UILabel()
	var leafSizeField = UITextField()
	var widthSize = UILabel()
	var widthSizeField = UITextField()
	var scrollView = UIScrollView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white
		
		scrollView = UIScrollView(frame: view.bounds)

		self.view.addSubview(scrollView)
		scrollView.contentSize = self.view.frame.size
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

		
		print("viewDidLoad!!")
		createButton()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
		let userDefault = UserDefaults.standard
		print("userDefault = \(userDefault.value(forKey: "imgData"))")
		userDefault.addSuite(named: "group.DroneSimulator")
		if let dictabc = userDefault.value(forKey: "imgData")  {
			var dict = dictabc as! NSDictionary
//			print("dict=\(dict)")
			let data = dict.value(forKey: "imgData") as! Data
			let str = dict.value(forKey: "name") as! String
			
			self.imgView.image = UIImage(data: data)
//			print("123123data = \(userDefault.value(forKey: "imgData") as? NSDictionary)")
			self.filenameLabel.text = str
			
			userDefault.removeObject(forKey: "imgData")
			userDefault.synchronize()
			
		}else {
			print("fail to get userDefault")
		}
	}
	
	@objc func keyboardWillShow(notification:NSNotification){
		//give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
		var userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)
		
		var contentInset:UIEdgeInsets = self.scrollView.contentInset
		contentInset.bottom = keyboardFrame.size.height
		scrollView.contentInset = contentInset
	}
	
	@objc func keyboardWillHide(notification:NSNotification){
		let contentInset:UIEdgeInsets = UIEdgeInsets.zero
		scrollView.contentInset = contentInset
	}
	
	func createButton(){
		
		// Image from extension
		// Image ID
		// Number of points
		// Interval of points
		// Total size of image
		
		filenameLabel.textAlignment = .center
		imageId.textAlignment = .center
		pointNumber.textAlignment = .center
		leafSize.textAlignment = .center
		widthSize.textAlignment = .center
		
		var submitBtn = UIButton(frame: CGRect(x: 300, y: 200, width: 200, height: 100))
		submitBtn.setTitle("Submit", for: .normal)
		submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
		submitBtn.tintColor = UIColor.black
		submitBtn.backgroundColor = UIColor.blue
		
		imageId.text = "Image ID :"
		pointNumber.text = "Number of point :"
		leafSize.text = "Size of leaf :"
		widthSize.text = "Size of width :"
		
		imgView.translatesAutoresizingMaskIntoConstraints = false
		filenameLabel.translatesAutoresizingMaskIntoConstraints = false
		submitBtn.translatesAutoresizingMaskIntoConstraints = false
		imageId.translatesAutoresizingMaskIntoConstraints = false
		imageIdField.translatesAutoresizingMaskIntoConstraints = false
		pointNumber.translatesAutoresizingMaskIntoConstraints = false
		pointNumberField.translatesAutoresizingMaskIntoConstraints = false
		leafSize.translatesAutoresizingMaskIntoConstraints = false
		leafSizeField.translatesAutoresizingMaskIntoConstraints = false
		widthSize.translatesAutoresizingMaskIntoConstraints = false
		widthSizeField.translatesAutoresizingMaskIntoConstraints = false
		
		self.scrollView.addSubview(imgView)
		self.scrollView.addSubview(filenameLabel)
		self.scrollView.addSubview(submitBtn)
		self.scrollView.addSubview(imageId)
		self.scrollView.addSubview(imageIdField)
		self.scrollView.addSubview(pointNumber)
		self.scrollView.addSubview(pointNumberField)
		self.scrollView.addSubview(leafSize)
		self.scrollView.addSubview(leafSizeField)
		self.scrollView.addSubview(widthSize)
		self.scrollView.addSubview(widthSizeField)
		
		imgView.heightAnchor.constraint(equalToConstant: 300).isActive = true
		imgView.widthAnchor.constraint(equalToConstant: 300).isActive = true
		
		imgView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
		imgView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: -250).isActive = true
		
		setLabelSizeTo(label: filenameLabel, width: 300, height: 150)
		setLabelSizeTo(label: imageId, width: 300, height: 150)
		setLabelSizeTo(label: pointNumber, width: 300, height: 150)
		setLabelSizeTo(label: leafSize, width: 300, height: 150)
		setLabelSizeTo(label: widthSize, width: 300, height: 150)
		
		setTextFieldSizeTo(textField: imageIdField, width: 300, height: 150)
		setTextFieldSizeTo(textField: pointNumberField, width: 300, height: 150)
		setTextFieldSizeTo(textField: leafSizeField, width: 300, height: 150)
		setTextFieldSizeTo(textField: widthSizeField, width: 300, height: 150)
		
		filenameLabel.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
		filenameLabel.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: -50).isActive = true
		
	}
	
	@objc func submit(sender:UIButton){
		
	}
	func setLabelSizeTo(label: UILabel, width: CGFloat, height: CGFloat){
		label.widthAnchor.constraint(equalToConstant: width).isActive = true
		label.heightAnchor.constraint(equalToConstant: height).isActive = true
	}
	func setTextFieldSizeTo(textField: UITextField, width: CGFloat, height: CGFloat){
		textField.widthAnchor.constraint(equalToConstant: width).isActive = true
		textField.heightAnchor.constraint(equalToConstant: height).isActive = true
	}
}
