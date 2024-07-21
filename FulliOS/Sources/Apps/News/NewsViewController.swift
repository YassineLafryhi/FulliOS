//
//  NewsViewController.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 15/7/2024.
//

import UIKit

internal class NewsViewController: UIViewController, NewsViewProtocol {
    var presenter: NewsPresenterProtocol?
    private var newsItems = [NewsItem]()
    private var searchQuery = ""
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let searchField = UITextField(frame: .zero)
        searchField.placeholder = "Search"
        searchField.borderStyle = .roundedRect
        searchField.addTarget(self, action: #selector(searchFieldChanged(_:)), for: .editingChanged)
        view.addSubview(searchField)

        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send Request", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.addSubview(sendButton)

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        searchField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            sendButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc
    private func searchFieldChanged(_ textField: UITextField) {
        searchQuery = textField.text ?? ""
    }

    @objc
    private func sendButtonTapped() {
        presenter?.fetchNews(for: searchQuery)
    }

    func showNews(_ news: [NewsItem]) {
        newsItems = news
        tableView.reloadData()
    }

    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        newsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = newsItems[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = newsItems[indexPath.row]
        if let url = URL(string: item.url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
