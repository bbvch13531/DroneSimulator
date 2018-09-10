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
	var lblText = UILabel()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white
		print("viewDidLoad!!")
		createButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("viewWillAppear!!")
		
		let userDefault = UserDefaults.standard
		userDefault.addSuite(named: "group.DroneSimulator")
		if let dictabc = userDefault.object(forKey: "imgData")  {
			var dict = dictabc as! NSDictionary
			print("dict=\(dict)")
			let data = dict.value(forKey: "imgData") as! Data
			let str = dict.value(forKey: "name") as! String
			
			self.imgView.image = UIImage(data: data)
			print("123123data = \(userDefault.value(forKey: "imgData") as? NSDictionary)")
			self.lblText.text = str
			//
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
		
		imgView.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
		lblText.frame = CGRect(x: 100, y: 200, width: 500, height: 300)
		lblText.text = "testtest"
		
		var testBtn = UIButton(frame: CGRect(x: 300, y: 200, width: 200, height: 100))
		testBtn.setTitle("test", for: .normal)
		testBtn.addTarget(self, action: #selector(test), for: .touchUpInside)
		testBtn.tintColor = UIColor.black
		testBtn.backgroundColor = UIColor.blue
		
		self.view.addSubview(imgView)
		self.view.addSubview(lblText)
		self.view.addSubview(testBtn)
	}
	
	@objc func test(sender: UIButton){
		let userDefault = UserDefaults.standard
		userDefault.addSuite(named: "group.DroneSimulator")
		
		//		if let dict = userDefault.value(forKey: "imgData") as? NSDictionary{
		//			print("dict=\(dict)")
		//			let data = dict.value(forKey: "imgData") as! Data
		//			let str = dict.value(forKey: "name") as! String
		//
		//			self.imgView.image = UIImage(data: data)
		//			print("123123data = \(data)")
		//			self.lblText.text = str
		//
		//			userDefault.removeObject(forKey: "imgData")
		//			userDefault.synchronize()
		//		}
		if let dictabc = userDefault.object(forKey: "imgData")  {
			var dict = dictabc as! NSDictionary
			print("dict=\(dict)")
			let data = dict.value(forKey: "imgData") as! Data
			let str = dict.value(forKey: "name") as! String
			
			self.imgView.image = UIImage(data: data)
			print("123123data = \(userDefault.value(forKey: "imgData") as? NSDictionary)")
			self.lblText.text = str
			//
			userDefault.removeObject(forKey: "imgData")
			userDefault.synchronize()
			
		}else {
			print("fail to get userDefault")
		}
	}
	
	
}
