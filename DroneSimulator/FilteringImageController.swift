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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white
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
		
		self.view.addSubview(imgView)
		self.view.addSubview(filenameLabel)
		self.view.addSubview(submitBtn)
		self.view.addSubview(imageId)
		self.view.addSubview(imageIdField)
		self.view.addSubview(pointNumber)
		self.view.addSubview(pointNumberField)
		self.view.addSubview(leafSize)
		self.view.addSubview(leafSizeField)
		self.view.addSubview(widthSize)
		self.view.addSubview(widthSizeField)
		
		imgView.heightAnchor.constraint(equalToConstant: 300).isActive = true
		imgView.widthAnchor.constraint(equalToConstant: 300).isActive = true
		
		imgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		imgView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150).isActive = true
		
		
		filenameLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
		filenameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
		
		filenameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		filenameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50).isActive = true
		
	}
	
	@objc func submit(sender:UIButton){
		
	}
	
}
