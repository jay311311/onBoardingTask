//
//  MainStep.swift
//  onBoardingTask
//
//  Created by pineone on 2022/08/17.
//

import Foundation
import RxFlow

enum MainStep : Step{
    //common
    case initStep
    case Back
    //tabBar
    case NewBook
    case Search
    case Detail
}
