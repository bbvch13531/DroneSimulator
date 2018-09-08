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
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.minimumLineSpacing = 10
		flowLayout.minimumInteritemSpacing = 10
		
		let customCollectionViewController = CustomCollectionViewController(collectionViewLayout: flowLayout)
		let navController = UINavigationController(rootViewController: customCollectionViewController)
		navController.tabBarItem.title = "Make Path"
		
		viewControllers = [navController]

	}
}
