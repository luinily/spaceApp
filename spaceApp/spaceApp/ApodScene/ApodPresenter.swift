//
//  ApodPresenter.swift
//  spaceApp
//
//  Created by Coldefy Yoann on 2016/07/17.
//  Copyright (c) 2016年 YoannColdefy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ApodPresenterInput {
	func presentSomething(response: ApodResponse)
}

protocol ApodPresenterOutput: class {
	func displayTodayApod(viewModel: ApodViewModel)
}

class ApodPresenter: ApodPresenterInput {
	weak var output: ApodPresenterOutput!
	
	// MARK: Presentation logic
	
	func presentSomething(response: ApodResponse) {
		// NOTE: Format the response from the Interactor and pass the result back to the View Controller
		
//		let viewModel = ApodViewModel()
//		output.displaySomething(viewModel: viewModel)
	}
}
