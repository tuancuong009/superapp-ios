//
//  SearchLocationViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 3/30/21.
//

import UIKit
import MapKit


class SearchLocationViewController: BaseViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var results: [MKLocalSearchCompletion] = []
    private var searchCompleter = MKLocalSearchCompleter()
    
    var didSelectLocation: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

extension SearchLocationViewController {
    
    private func setup() {
        searchTextField.delegate = self
        searchCompleter.delegate = self
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: SearchLocationTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
        if keyboardHeight > 0 {
            keyboardHeight = keyboardHeight - (view.window?.safeAreaInsets.bottom ?? 0.0)
        }
        self.tableView.contentInset.bottom = keyboardHeight
    }
}

extension SearchLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        searchCompleter.queryFragment = textField.trimmedText ?? ""
    }
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        self.tableView.reloadData()
    }
}

extension SearchLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchLocationTableViewCell.identifier, for: indexPath) as! SearchLocationTableViewCell
        cell.locationNameLabel.text = results[indexPath.row].title
        cell.subTitleLabel.text = results[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectLocation?(results[indexPath.row].title)
        self.navigationController?.popViewController(animated: true)
    }
}
