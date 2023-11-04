//
//  ViewController.swift
//  llamaMacExample
//
//  Created by david Chiu on 11/3/23.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var topicstext: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".gguf")

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc
    func llamaCallback(_ chatReply: UnsafePointer<CChar>?) -> Void {
        DispatchQueue.main.async {
            if let reply = chatReply {
                print("- \(String( cString: reply))")
                self.topicstext.stringValue = String( cString: reply)
            }
        }
    }
    //T##((UnsafePointer<CChar>?) -> Void)?##((UnsafePointer<CChar>?) -> Void)?##(UnsafePointer<CChar>?) -> Void
    
    @IBAction func startChat(_ sender: Any) {
        // cannot run in background somehow
        DispatchQueue.global(qos: .userInitiated).async {
            
            LlamaCpp.start("what day is today", completion: self.llamaCallback(_:))
            /*var args: [String]
             const char args_const[6][128]={" ./main", "-m", "models/mistral-7b-instruct-v0.1.Q4_K_M.gguf", "-p", "what date is today", "-e"};
             for(int i=0;i<6;i++) {
             args[i] = (char*)malloc(sizeof(char)*128);
             strcpy(args[i], args_const[i]);
             }
             //strcpy(args[4], "what date is today");
             
             printf("%s", args[1]);
             llama_main(5, (char**)args);*/
        }
    }
    
}

