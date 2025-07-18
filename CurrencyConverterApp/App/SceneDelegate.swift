//
//  SceneDelegate.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    // 마지막으로 방문한 화면 정보를 CoreData에서 로드
    let lastScreen = CoreDataManager.shared.loadLastVisitedScreen()
    let exchangeRateViewController = ExchangeRateViewController()
    exchangeRateViewController.navigationItem.title = "환율 정보"
    let navigationController = UINavigationController(rootViewController: exchangeRateViewController)
    
    // 마지막 방문한 화면이 'calculator'인 경우 계산기 화면으로 이동
    if lastScreen.screenType == .calculator {
      // CoreData에 저장된 환율 데이터를 기반으로 ViewModel 생성
      let viewModel = CalculatorViewModel(rateData: getSavedRate(currencyCode: lastScreen.currencyCode))
      let calculatorViewController = CalculatorViewController(viewModel: viewModel)
      
      navigationController.pushViewController(calculatorViewController, animated: true)
    }
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
  }
  
  // CoreData에 저장된 환율 정보로 ExchangeRateData 모델 생성
  private func getSavedRate(currencyCode: String) -> ExchangeRateData {
    let entity = CoreDataManager.shared.loadExchangeRate(for: currencyCode)
    
    guard !entity.currencyCode.isEmpty else {
      return ExchangeRateData(
        currencyCode: currencyCode,
        country: CountryData[currencyCode] ?? "Unknown",
        rate: 0.0
      )
    }
    
    return ExchangeRateData(
      currencyCode: entity.currencyCode,
      country: CountryData[currencyCode] ?? "Unknown",
      rate: entity.rate
    )
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    
    // Save changes in the application's managed object context when the application transitions to the background.
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
  
  
}

