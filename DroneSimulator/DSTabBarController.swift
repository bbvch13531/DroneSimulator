//
//  DSTabBarController.swift
//  DroneSimulator
//
//  Created by KyungYoung Heo on 2018. 9. 8..
//  Copyright © 2018년 KyungYoung Heo. All rights reserved.
//

import UIKit

class DSTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let filteringImageController = FilteringImageController()
		let navFilterController = UINavigationController(rootViewController: filteringImageController)
		navFilterController.tabBarItem.title = "Filtering"
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.minimumLineSpacing = 10
		flowLayout.minimumInteritemSpacing = 10
		
		let customCollectionViewController = CustomCollectionViewController(collectionViewLayout: flowLayout)
		let navCollectionController = UINavigationController(rootViewController: customCollectionViewController)
		navCollectionController.tabBarItem.title = "Make Path"
		
		viewControllers = [navFilterController,navCollectionController]

	}
}
