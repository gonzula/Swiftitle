//
//  ViewController.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 12/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var destinationView: DestinationView! {
        didSet {
            destinationView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ViewController: DestinationViewDelegate {
    func droppedURLS(_ urls: [URL]) {
        print(urls)
    }
}
