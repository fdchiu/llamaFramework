//
//  ClickableImageView.swift
//  llamaMacExample
//
//  Created by david Chiu on 11/10/23.
//

import Foundation
import Cocoa

class ClickableImageView: NSImageView {

    override func mouseDown(with event: NSEvent) {
        let clickCount: Int = event.clickCount

        if clickCount > 1 {
            // User at least double clicked in image view
        } else {
            if let url = URL(string: "https://creataai.com/llamaframework") {
                NSWorkspace.shared.open(url)
            }

        }
    }

}
