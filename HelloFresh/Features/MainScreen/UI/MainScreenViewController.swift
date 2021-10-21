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
        static let topInset: CGFloat = 8
        static let backgroundColor = UIColor.white
        static let title = "Recipes"
        static let cellId = String(describing: RecipeCell.self)
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
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - Initializable
    
    private var viewModel: MainScreenViewModel
    
    // MARK: - Init
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupSubviews()
        addedRefreshControl()
        tableView.register(RecipeCell.self, forCellReuseIdentifier: Consts.cellId)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Consts.title
        view.backgroundColor = Consts.backgroundColor
        
        binding()
        
        viewModel.loadRecipes()
    }
    
    // MARK: - Private methods
    
    private func binding() {
        viewModel.updateView = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.showAlert = { [weak self] message in
            self?.showAlert(message)
        }
    }
    
    private func addedRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func showAlert(_ message: String) {
        
    }
    
    @objc private func refresh() {
        viewModel.loadRecipes()
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
                equalTo: view.bottomAnchor,
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
        cell.configure(recipe: viewModel.items[indexPath.row])
        
        return cell
    }
}
