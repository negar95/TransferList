//
//  Logger.swift
//  AppFoundation
//
//  Created by Negar Moshtaghi on 8/24/25.
//

import Foundation

public struct Logger {
    public static func info(
        _ message: Any...,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("[\(fileName):\(line)] \(function) - INFO: ", message)
        #endif
    }
    public static func error(
        _ message: Any...,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("🔴 [\(fileName):\(line)] \(function) - ERROR: ", message)
        #endif
    }
    public static func warning(
        _ message: Any...,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        print("⚠️ [\(fileName):\(line)] \(function) - WARNING: ", message)
        #endif
    }
}
