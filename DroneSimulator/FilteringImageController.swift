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
		
		if let dict = userDefault.value(forKey: "img") as? NSDictionary{
			
			let data = dict.value(forKey: "imgData") as! Data
			let str = dict.value(forKey: "name") as! String
			
			self.imgView.image = UIImage(data: data)
			print("data = \(data)")
			self.lblText.text = str
			
			userDefault.removeObject(forKey: "imgData")
			userDefault.synchronize()
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
		
		self.view.addSubview(imgView)
		self.view.addSubview(lblText)
	}
}
