//
//  ViewController.swift
//  mercury
//
//  Created by Stanley on 12/02/21.
//

import UIKit
import SkeletonView

class ViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerView: UIView!
    var wordViewController: WordViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        
        wordViewController = children[0] as? WordViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "wordContainerSegue") {
//            let view = segue.destination as! WordViewController
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count >= 3 {
            searchWord(text: searchBar.text!)
        } else {
            
        }
    }
    
    func searchWord(text: String) {
        wordViewController?.loadWord(word: text)
    }
}
