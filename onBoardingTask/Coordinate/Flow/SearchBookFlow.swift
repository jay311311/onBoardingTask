//
//  SearchBookFlow.swift
//  onBoardingTask
//
//  Created by pineone on 2022/08/17.
//

import Foundation
import RxFlow

class SearchBookFlow:Flow{
    var root: Presentable {
        rootViewController.topViewController?.title = "Seach Books"
        rootViewController.navigationBar.prefersLargeTitles = true
        return self.rootViewController
    }
    
    let rootViewController =  UINavigationController(rootViewController: SearchViewController())
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? MainStep else{ return .none}
        
        switch step {
        case .Search:
            return setSearchScreen()
            
        case .Back:
            return goToBack()
        default :
            return .none

        }
    }
    
    func setSearchScreen() -> FlowContributors{
        print("검색 세팅 한다")
        return .none
//        let searchVC = SearchViewController()
//        self.rootViewController.pushViewController(searchVC, animated: false)
//        return .one(flowContributor: .contribute(withNextPresentable: searchVC, withNextStepper: <#T##Stepper#>, allowStepWhenNotPresented: <#T##Bool#>, allowStepWhenDismissed: <#T##Bool#>))
    }
    func goToBack() -> FlowContributors{
        
        return .none
    }
    
    
}
