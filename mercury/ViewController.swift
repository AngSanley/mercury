//
//  ViewController.swift
//  mercury
//
//  Created by Stanley on 12/02/21.
//

import UIKit
import SkeletonView
import SwipeMenuViewController
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var swipeMenuView: SwipeMenuView!
    
    let API_URL = "https://myawesomedictionary.herokuapp.com/words"

    var words: [Word] = []
    
    var wordViewController: WordViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        
        swipeMenuView.dataSource = self
        swipeMenuView.delegate = self

        let options: SwipeMenuViewOptions = .init()

        swipeMenuView.reloadData(options: options)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count >= 3 {
            searchWord(text: searchBar.text!)
        } else {
            
        }
    }
    
    func searchWord(text: String) {
        // reset
        self.words = []
              
        // request api
        AF.request(API_URL, parameters: ["q": text])
          .validate(statusCode: 200..<300)
          .validate(contentType: ["application/json"])
            .response{ response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value!)
                        
                        for word in json.arrayValue {
                            let theWord = word["word"]
                            let definitionJson = JSON(word["definitions"])
                            
                            var definitions: [Definition] = []
                            
                            for definition in definitionJson.arrayValue {
                                definitions.append(Definition(imageUrl: definition["image_url"].stringValue, type: definition["type"].stringValue, definition: definition["definition"].stringValue))
                            }
                            
                            self.words.append(Word(word: theWord.stringValue, definitions: definitions))
                            
                            self.swipeMenuView.reloadData()
                        }
                        
                        
                        
//                        print("JSON: \(json[0]["word"])")
                        
                    case .failure(let error):
                        print(error)
                    }
            }
    }
}

extension ViewController: SwipeMenuViewDelegate {

    // MARK - SwipeMenuViewDelegate
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
        // Codes
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        // Codes
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // Codes
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // Codes
    }
}

extension ViewController: SwipeMenuViewDataSource {

    //MARK - SwipeMenuViewDataSource
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        if words.count > 0 {
            return words.count
        } else {
            return 1
        }
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        if self.words.count > index {
            return self.words[index].word
        } else {
            return "Hello!"
        }
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WordViewController") as! WordViewController
        
        if self.words.count > index {
            vc.setWord(word: self.words[index].word)
            vc.setDefinitions(definitions: self.words[index].definitions)
        }
        
        
        return vc
    }
}
