//
//  FilePicker.swift
//  llamaMacExample
//
//  Created by david Chiu on 11/8/23.
//

import Foundation
import Cocoa

func filePicker( fileExtension: [String]) -> String? {
    let dialog = NSOpenPanel();
    
    dialog.title                   = "Choose an image | Our Code World";
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.allowsMultipleSelection = false;
    dialog.canChooseDirectories = false;
    dialog.allowedFileTypes        = fileExtension; //["png", "jpg", "jpeg", "gif"];
    
    if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
        let result = dialog.url // Pathname of the file
        
        if (result != nil) {
            let path: String = result!.path
            
            return path
            // path contains the file path e.g
            // /Users/ourcodeworld/Desktop/tiger.jpeg
        }
        
    } else {
        // User clicked on "Cancel"
    }
    return nil
}
