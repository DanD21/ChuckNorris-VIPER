//
//  HomeView.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeView: class {
    func showJoke(joke: Joke)
    func showError()
    func showCategories(categories: Category)
}

class HomeViewImpl: UIViewController, HomeView {

    var presenter: HomePresenter!

    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var jokeTextView: UITextView!

    @IBOutlet weak var randomButton: UIButton!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.presenter?.viewDidLoad()
        randomButton.rx.tap
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                 self.presenter?.randomButtonPressed()
            }).disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.        
    }

    func showJoke(joke: Joke) {
        jokeTextView.text = joke.value
    }

    func showError() {
        jokeTextView.text = "ERROR 42: Chuck Norris doesn't want you to get his jokes!"
    }

    func showCategories(categories: Category) {
        let alert = UIAlertController(title: "Categories",
                                      message: "Please Choose a Category",
                                      preferredStyle: .actionSheet)
        for category in categories.categories {
            alert.addAction(UIAlertAction(title: "\(category)", style: .default, handler: { (action) in
                //execute some code when this option is selected
                self.presenter?.getJokeByCategory(category: category)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func categoriesButtonPressed(_ sender: Any) {
        self.presenter?.categoriesButtonPressed()
    }
}
