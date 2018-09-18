//
//  ShareViewController.swift
//  ImageExportor
//
//  Created by KyungYoung Heo on 2018. 9. 8..
//  Copyright © 2018년 KyungYoung Heo. All rights reserved.
//

import UIKit
import Social
import Alamofire

class ShareViewController: SLComposeServiceViewController {
	let userDefault = UserDefaults(suiteName: "group.DroneSimulator")
	var filename = String()
	var imageimage = Data()
		
		
	override func isContentValid() -> Bool {
		// Do validation of contentText and/or NSExtensionContext attachments here
		return true
	}
	
	override func didSelectPost() {
		// This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
		
		// Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
		
		if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem {
			
			for ele in item.attachments!{
				
				let itemProvider = ele as! NSItemProvider
				
				if itemProvider.hasItemConformingToTypeIdentifier("public.png"){
					print(itemProvider)
				
					itemProvider.loadItem(forTypeIdentifier: "public.png", options: nil, completionHandler: {(item,error) in
						
						var imgData = UIImage()
						
						if let url = item as? NSURL{
							if let data = NSData(contentsOf: url as URL){
								imgData = UIImage(data: data as Data)!
							}
						}
						
						if let uploadImgData = UIImagePNGRepresentation(imgData) {
							
							self.uploadImage(data: uploadImgData)
							var dictArr = [[String: Any]]()
							
							/**/
							self.imageimage = uploadImgData
							/**/
							
//							var originDict = self.userDefault?.value(forKey: "dataName") as? [[String: Any]]
//
////							var originDict: [String : Any] = self.userDefault?.value(forKey: "imgData") as! [String : Any]
////							dictArr.append(originDict)
//
//							let dict: [String : Any] = ["imgData" :  uploadImgData, "name" : self.contentText]
//							originDict.append(dict)

							self.filename = self.contentText
							//								userDefault.addSuite(named: "group.DroneSimulator")
							
//							self.userDefault?.set(originDict, forKey: "dataName")
//							self.userDefault?.synchronize()
//							let dicData = self.userDefault?.value(forKey: "imgData") as? NSDictionary
							print("userDefault saved")
						}
				
					})
				}
				else	{
					print("Cannot find image")
				}
			}
		}
		self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
	}
	override func configurationItems() -> [Any]! {
		// To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
		return []
	}
	func uploadImage(data:Data){
		var params: Parameters = [
			"file" : data
		]
		
		// get userDefault and set DicArr
		
		
		var lk = String()
		
		
		print("data = \(data)")
		Alamofire.upload(
			multipartFormData: { multipartFormData in
				multipartFormData.append(data, withName:"file", fileName: self.filename+".png", mimeType: "image/png")
		},
			to : "http://neinsys.io:5000/insertImagePost",
			encodingCompletion: { encodingResult in
				switch encodingResult {
				case .success(let upload, _, _):
					upload.responseJSON { response in
//						debugPrint(response.result.value)
						if let json = response.result.value{
							if let objArr = json as? [Any] {
								if let object = objArr[0] as? NSObject{
////									print(object)
									if let dic = object as? [String:Any]{
										if let id = dic["_id"] as? String {
											print(id)

											lk = id

											self.userDefault?.set(self.imageimage, forKey: id)
											self.userDefault?.set(lk, forKey: "lastKey")
											self.userDefault?.set(self.filename, forKey: "fileName")
										}
									}
								}
							}
						}
					}
					
				case .failure(let encodingError):
					print("fail! \(encodingError)")
				}
		}
		)
	}
}
