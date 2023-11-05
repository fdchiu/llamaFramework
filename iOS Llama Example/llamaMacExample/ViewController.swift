//
//  ViewController.swift
//  llamaMacExample
//
//  Created by david Chiu on 11/3/23.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var topicstext: NSTextField!
    
    @IBOutlet var answerText: NSTextView!
    @IBOutlet weak var questionText: NSTextField!
    let modelName = "mistral-7b-instruct-v0.1.Q4_K_M.gguf"
    
    var llamaWrapper: LlamaCppWrapper!
    
    override func viewDidLoad() {
        llamaWrapper = LlamaCppWrapper()
        llamaWrapper.loadModel(modelName)
        super.viewDidLoad()
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".gguf")

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func submit(_ sender: Any) {
        //self.startChat(sender)
    }
    
    @objc
    func llamaCallback(_ chatReply: UnsafePointer<CChar>?) -> Void {
        DispatchQueue.main.async {
            if let reply = chatReply {
                print("- \(String( cString: reply))")
                self.answerText.string = String( cString: reply)
            }
        }
    }
    //T##((UnsafePointer<CChar>?) -> Void)?##((UnsafePointer<CChar>?) -> Void)?##(UnsafePointer<CChar>?) -> Void
    
    @IBAction func startChat(_ sender: Any) {
        let questionStr = self.questionText.stringValue
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.llamaWrapper.chat(questionStr, completion: self.llamaCallback(_:))
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

