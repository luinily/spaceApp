//
//  ApodViewController.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ApodViewControllerInput {
	func displayApod(viewModel: ApodViewModel)
}

protocol ApodViewControllerOutput {
	func fetchTodayApod(request: TodayApodRequest)
}

class ApodViewController: UIViewController, ApodViewControllerInput {
	var output: ApodViewControllerOutput!
	var router: ApodRouter!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var explanationTextView: UITextView!
	// MARK: Object lifecycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		ApodConfigurator.sharedInstance.configure(viewController: self)
	}
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchTodaysApod()
	}
	
	// MARK: Event handling
	
	func fetchTodaysApod() {
		// NOTE: Ask the Interactor to do some work
		
		let request = TodayApodRequest()
		output.fetchTodayApod(request: request)
	}
	
	// MARK: Display logic
	
	func displayApod(viewModel: ApodViewModel) {
		titleLabel.text = viewModel.title
		explanationTextView.text = viewModel.explanation
		image.image = viewModel.picture
		image.reloadInputViews()
	}
}
