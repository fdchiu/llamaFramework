//
//  Helper.swift
//  iOS Llama Example
//
//  Created by david Chiu on 11/1/23.
//

import Foundation

public func copyFilesFromBundleToDocumentsFolderWith(fileExtension: String) {
    if var resPath = Bundle.main.resourcePath {
        do {
            let prefix = ""///Frameworks/llamaFramework.framework"
            resPath += prefix
            #if DEBUG
                print("resPath:\(resPath)")
            #endif
            resPath += "/models"
            let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
            let subdirstr = "models"
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let subdir = documentsURL!.appendingPathComponent(subdirstr)
            let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
            
            /*do {
                deleteDir("models")
            } catch {
                #if DEBUG
                    print("Error deleting Models dir")
                #endif
            }*/
            
            do {
                try FileManager.default.createDirectory(at: subdir, withIntermediateDirectories: true, attributes: nil)
                //print("Create subdir: \(subdirstr)")
            } catch{
                print("Failed to create subdir: \(subdirstr)")
            }

            for fileName in filteredFiles {
                if let documentsURL = documentsURL {
                    var sourceURL = Bundle.main.bundleURL.appendingPathComponent(prefix+"models/"+fileName)
#if os(OSX)
                        sourceURL = Bundle.main.resourceURL!.appendingPathComponent(prefix+"models/"+fileName)
#endif
                    
                    let destURL = subdir.appendingPathComponent(fileName)
                    #if DEBUG
                        print("copying: \(fileName) to app's Document/models dir")
                    #endif
                    if !FileManager.default.fileExists(atPath: destURL.path) {
                        do {
                                try FileManager.default.copyItem(at: sourceURL, to: destURL)
                            } catch is Error { print("error copying:\(Error.self)") }
                    }
                }
            }
        } catch { }
    }
}

public func deleteDir(_ dirname: String) {
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let dir = documentsUrl.appendingPathComponent(dirname)
    
    if !FileManager.default.fileExists(atPath: dir.absoluteString) {
        return;
    }
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: dir,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)
        for fileURL in fileURLs {
            try FileManager.default.removeItem(at: fileURL)
        }
        try FileManager.default.removeItem(at: dir)
    } catch  { print(error) }
}

///
///Only for athena app's tmp dir
///
public func deleteTmpDir(_ dirname: String) {
    let documentsUrl =  FileManager.default.temporaryDirectory
    let dir = documentsUrl.appendingPathComponent(dirname)
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: dir,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)
        for fileURL in fileURLs {
            try FileManager.default.removeItem(at: fileURL)
        }
        try FileManager.default.removeItem(at: dir)
    } catch  { print(error) }
}

///
///Only for athena app's tmp dir
///
public func deleteFileInTmpDir(_ filename: String) {
    let documentsUrl =  FileManager.default.temporaryDirectory
    let dir = documentsUrl.appendingPathComponent(filename)
    do {
        try FileManager.default.removeItem(at: dir)
    } catch  { print(error) }
}

