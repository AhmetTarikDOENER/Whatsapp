import UIKit
import SwiftUI

final class MessageListController: UIViewController {
    
    //  MARK: - Properties
    private let cellIdentifier = "MessageListControllerCell"
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

//  MARK: - MessageListController+UITableViewDelegate & UITableViewDataSource
extension MessageListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.contentConfiguration = UIHostingConfiguration {
            BubbleTextView(item: .sentPlaceholder)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

#Preview {
    MessageListView()
}
