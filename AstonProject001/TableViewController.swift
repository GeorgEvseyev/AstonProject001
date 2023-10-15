//
//  LeadersViewController.swift
//  AstonProject001
//
//  Created by Георгий Евсеев on 21.09.23.
//

import UIKit

final class TableViewController: UIViewController, FirstControllerDelegate {
    private let tableView = UITableView()

    var players: [Player] = []

    init(players: [Player]) {
        super.init(nibName: nil, bundle: nil)
        self.players = players
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstViewController = ViewController()
        firstViewController.delegate = self

        addViews()
        setupView()
        setupLayout()
    }

    func passData(_ data: [ViewController]) {
    }
}

private extension TableViewController {
    func addViews() {
        view.addSubview(tableView)
        setupLayout()
        setupView()
    }

    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setupView() {
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        let cellWithModel = players[indexPath.row]
        cell.configureView(cellWithModel)
        return cell
    }
}
