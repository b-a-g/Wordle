//
//  ScreenDimensions.swift
//  Wordle
//
//  Created by Александр Беляев on 03.05.2022.
//

import SwiftUI

class ScreenDimensions {
  #if os(iOS) || os(tvOS)
    static var width: CGFloat = UIScreen.main.bounds.size.width
    static var height: CGFloat = UIScreen.main.bounds.size.height
  #elseif os(macOS)
    static var width: CGFloat = NSScreen.main?.visibleFrame.size.width ?? 0
    static var height: CGFloat = NSScreen.main?.visibleFrame.size.height ?? 0
  #endif
}
