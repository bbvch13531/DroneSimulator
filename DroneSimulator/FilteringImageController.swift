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
	var imageIdFromData = UILabel()
	var pointNumber = UILabel()
	var pointNumberField = UITextField()
	var leafSize = UILabel()
	var leafSizeField = UITextField()
	var widthSize = UILabel()
	var widthSizeField = UITextField()
	var scrollView = UIScrollView()
	
	var lastKey = String()
	var fileName = String()
	var dic = [String:Any]()
	
	
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
//		print("userDefault = \(userDefault.value(forKey: "dataName"))")
		
		userDefault.addSuite(named: "group.DroneSimulator")
		
		if let lk = userDefault.value(forKey: "lastKey") as? String {
			self.lastKey = lk
		}
		if let fn = userDefault.value(forKey: "fileName") as? String {
			self.fileName = fn
		}
		if let dicArr = userDefault.value(forKey: "imageData")  {
			
			self.dic = dicArr as! [String:Any]
//			print("dict=\(dict)")
//			let data = dict.value(forKey: "imgData") as! Data
//			let str = dict.value(forKey: "name") as! String
			let data = self.dic[lastKey] as! Data
			
			self.imgView.image = UIImage(data: data)
//			print("123123data = \(userDefault.value(forKey: "imgData") as? NSDictionary)")
			self.filenameLabel.text = self.fileName
			
//			userDefault.removeObject(forKey: "imgData")
			userDefault.synchronize()
			
		}else {
			print("fail to get userDefault")
		}
		
		self.imageIdFromData.text = lastKey
		
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
		
		pointNumberField.textAlignment = .center
		leafSizeField.textAlignment = .center
		widthSizeField.textAlignment = .center
		
		var submitBtn = UIButton()
		submitBtn.setTitle("Submit", for: .normal)
		submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
		submitBtn.tintColor = UIColor.white
		submitBtn.backgroundColor = self.view.tintColor
		submitBtn.layer.cornerRadius = 10
		
		
		setBorderToTextField()
		
		imageId.text = "Image ID :"
		pointNumber.text = "Number of point :"
		leafSize.text = "Size of leaf :"
		widthSize.text = "Size of width :"
		
		imgView.translatesAutoresizingMaskIntoConstraints = false
		filenameLabel.translatesAutoresizingMaskIntoConstraints = false
		submitBtn.translatesAutoresizingMaskIntoConstraints = false
		imageId.translatesAutoresizingMaskIntoConstraints = false
		imageIdFromData.translatesAutoresizingMaskIntoConstraints = false
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
		self.scrollView.addSubview(imageIdFromData)
		self.scrollView.addSubview(pointNumber)
		self.scrollView.addSubview(pointNumberField)
		self.scrollView.addSubview(leafSize)
		self.scrollView.addSubview(leafSizeField)
		self.scrollView.addSubview(widthSize)
		self.scrollView.addSubview(widthSizeField)
		
		submitBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
		submitBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
		
		submitBtn.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
		submitBtn.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: 250).isActive = true
		
		imgView.heightAnchor.constraint(equalToConstant: 300).isActive = true
		imgView.widthAnchor.constraint(equalToConstant: 300).isActive = true
		
		imgView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
		imgView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: -250).isActive = true
		
		setLabelSizeTo(label: filenameLabel, width: 300, height: 150)
		setLabelSizeTo(label: imageId, width: 300, height: 150)
		setLabelSizeTo(label: pointNumber, width: 300, height: 150)
		setLabelSizeTo(label: leafSize, width: 300, height: 150)
		setLabelSizeTo(label: widthSize, width: 300, height: 150)
		setLabelSizeTo(label: imageIdFromData, width: 300, height: 150)
		
		pointNumberField.placeholder = "100"
		leafSizeField.placeholder = "1"
		widthSizeField.placeholder = "50"
		
		setTextFieldSizeTo(textField: pointNumberField, width: 150, height: 40)
		setTextFieldSizeTo(textField: leafSizeField, width: 150, height: 40)
		setTextFieldSizeTo(textField: widthSizeField, width: 150, height: 40)
		
		filenameLabel.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
		filenameLabel.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: -50).isActive = true
		setConstraintToLable(label: imageId, xConstant: -100, yConstant: 0)
		setConstraintToLable(label: pointNumber, xConstant: -100, yConstant: 50)
		setConstraintToLable(label: leafSize, xConstant: -100, yConstant: 100)
		setConstraintToLable(label: widthSize, xConstant: -100, yConstant: 150)
		setConstraintToLable(label: imageIdFromData, xConstant: 100, yConstant: 0)
		
		setConstraintToTextField(textField: pointNumberField, xConstant: 100, yConstant: 50)
		setConstraintToTextField(textField: leafSizeField, xConstant: 100, yConstant: 100)
		setConstraintToTextField(textField: widthSizeField, xConstant: 100, yConstant: 150)
	}
	
	@objc func submit(sender:UIButton){
		let imageId = self.imageIdFromData.text!
		var number = self.pointNumberField.text!
		var leaf_size = self.leafSizeField.text!
		var width = self.widthSizeField.text!
		
		if number == "" {
			number = "100"
		}
		if leaf_size == "" {
			leaf_size = "1"
		}
		if width == "" {
			width = "50"
		}
		
		let params: Parameters = [
			"image" : imageId,
			"number" : number,
			"leaf_size" : leaf_size,
			"width" : width
		]
		
		Alamofire.request("http://neinsys.io:5000/filteringImage", method: .post, parameters: params)
			.responseJSON { response in
//				print(response.result.value)
				if let imageArray = response.result.value as? [NSObject]{
					if let value = imageArray[0] as? [String:Any] {
						if let newId = value["_id"] as? String  {
							print(newId)
							self.dic[newId] = self.dic[self.lastKey]
							
							let userDefault = UserDefaults.standard
							userDefault.addSuite(named: "group.DroneSimulator")
							userDefault.set(self.dic,forKey:"imageData")
							
						}
					}
				}
		}
	}
	func setConstraintToLable(label: UILabel,xConstant: CGFloat, yConstant: CGFloat){
		label.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: xConstant).isActive = true
		label.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: yConstant).isActive = true
	}
	func setConstraintToTextField(textField: UITextField,xConstant: CGFloat, yConstant: CGFloat){
		textField.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant: xConstant).isActive = true
		textField.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: yConstant).isActive = true
	}
	func setLabelSizeTo(label: UILabel, width: CGFloat, height: CGFloat){
		label.widthAnchor.constraint(equalToConstant: width).isActive = true
		label.heightAnchor.constraint(equalToConstant: height).isActive = true
	}
	func setTextFieldSizeTo(textField: UITextField, width: CGFloat, height: CGFloat){
		textField.widthAnchor.constraint(equalToConstant: width).isActive = true
		textField.heightAnchor.constraint(equalToConstant: height).isActive = true
	}
	
	func setBorderToTextField(){
		
		pointNumberField.layer.borderColor = UIColor.gray.cgColor
		pointNumberField.layer.borderWidth = 1
		pointNumberField.layer.cornerRadius = 8.0
		
		leafSizeField.layer.borderColor = UIColor.gray.cgColor
		leafSizeField.layer.borderWidth = 1
		leafSizeField.layer.cornerRadius = 8.0
		
		widthSizeField.layer.borderColor = UIColor.gray.cgColor
		widthSizeField.layer.borderWidth = 1
		widthSizeField.layer.cornerRadius = 8.0
	}
}
