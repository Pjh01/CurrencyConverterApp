//
//  ViewModelProtocol.swift
//  CurrencyConverterApp
//
//  Created by estelle on 7/10/25.
//

protocol ViewModelProtocol {
  associatedtype Action
  associatedtype State
  
  var action: ((Action) -> Void)? { get }
  var state: State { get }
}
