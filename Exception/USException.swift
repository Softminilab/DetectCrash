//
//  Exception.swift
//  Exception
//
//  Created by Kare on 2018/10/4.
//  Copyright © 2018 xxxxxxx. All rights reserved.
//

import Foundation

func UncaughtExceptionHandler(exception: NSException) {
    let stackAry = exception.callStackSymbols
    let reason = exception.reason ?? ""
    let name = exception.name
    let exceptionInfo = """
    Exception reason: \(reason)\n
    Exception name: \(name)\n
    Exception stackSymbols: \(stackAry)\n
    """
    saveCrash(exceptionInfo)
}

func setException() {
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler)
}

func setUnixException() {
    signal(SIGHUP, SignalHandler)
    signal(SIGINT, SignalHandler)
    signal(SIGQUIT, SignalHandler)
    signal(SIGABRT, SignalHandler)
    signal(SIGILL, SignalHandler)
    signal(SIGSEGV, SignalHandler)
    signal(SIGFPE, SignalHandler)
    signal(SIGBUS, SignalHandler)
    signal(SIGPIPE, SignalHandler)
}

func SignalHandler(signal: Int32) -> Void {
    processSignal(signal)
}

func processSignal(_ signal: Int32) {
    var exceptionStr = "Stack:\n"
    exceptionStr.append(Thread.callStackSymbols.joined(separator: "\n"))
    saveCrash(exceptionStr, type: .mach)
}

enum CrashType {
    case exception
    case mach
}

func saveCrash(_ crash: String, type: CrashType? = .exception) {
    if type == .exception {
        let pathInfo = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent("ExceptionCrash")
        
        if !FileManager().fileExists(atPath: pathInfo) {
            do {
                try FileManager().createDirectory(atPath: pathInfo, withIntermediateDirectories: true, attributes: nil)
            }catch {
                print("create path error.localizedDescription: \(error.localizedDescription)")
            }
        }
        
        let savePath = pathInfo.appending("/error \(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970).log")
        
        do {
            try crash.write(toFile: savePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("write string error.localizedDescription: \(error.localizedDescription)")
        }
    }else {
        let pathInfo = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString).appendingPathComponent("MachCrash")
        
        if !FileManager().fileExists(atPath: pathInfo) {
            do {
                try FileManager().createDirectory(atPath: pathInfo, withIntermediateDirectories: true, attributes: nil)
            }catch {
                print("mach -> create path error.localizedDescription: \(error.localizedDescription)")
            }
        }
        
        let savePath = pathInfo.appending("/error \(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970).log")
        
        do {
            try crash.write(toFile: savePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("mach -> write string error.localizedDescription: \(error.localizedDescription)")
        }
    }
}
