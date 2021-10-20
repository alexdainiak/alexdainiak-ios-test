//
//  MainScreenViewController.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import UIKit

class MainScreenViewController: UIViewController {

    // MARK: - Private properties
    
    private enum Consts {
        static let inset: CGFloat = 16
        static let backgroundColor = UIColor.white
        static let title = "Recipes"
        static let cellId = "RecipeCell"
    }

    
    private lazy var refreshControl = UIRefreshControl()
    
    
    /// It is better to use parent ParentTableView with prepared props and methods or even data driven approach with viewDatas, but it is require the time. Therefore only local delegates and dataSources
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 56
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Consts.backgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: Consts.cellId)
        
        return tableView
    }()
    
    // MARK: - Initializable
    
    private let viewModel: MainScreenViewModel
    
    // MARK: - Init
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupSubviews()
        addedRefreshControl()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Consts.title
        view.backgroundColor = Consts.backgroundColor
    }
    
    // MARK: - Private methods
    
    private func addedRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        
    }
    
    private func setupSubviews() {
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: layoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: layoutGuide.leadingAnchor,
                constant: Consts.inset
            ),
            tableView.bottomAnchor.constraint(
                equalTo: layoutGuide.bottomAnchor,
                constant: -Consts.inset
            ),
            tableView.trailingAnchor.constraint(
                equalTo: layoutGuide.trailingAnchor,
                constant: -Consts.inset
            )
        ])
    }
}
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.cellId, for: indexPath) as! RecipeCell
        return cell
    }
}
