import UIKit
import SwiftUI
import Combine

final class MessageListController: UIViewController {
    
    //  MARK: - Properties
    private let cellIdentifier = "MessageListControllerCell"
    private let viewModel: ChatroomViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.backgroundColor = .gray.withAlphaComponent(0.2)
        listConfiguration.showsSeparators = false
        
        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
        section.contentInsets.leading = 0
        section.contentInsets.trailing = 0
        section.interGroupSpacing = -10
        
        return section
    }
    
    private lazy var messagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.selfSizingInvalidation = .enabledIncludingConstraints
        collectionView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.refreshControl = pullToRefresh
        
        return collectionView
    }()
    
    private lazy var pullToRefresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .chatbackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    //  MARK: - Initializer
    init(_ viewModel: ChatroomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.backgroundColor = .clear
        view.backgroundColor = .clear
        setupViews()
        setupMessageListeners()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(messagesCollectionView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupMessageListeners() {
        viewModel.$messages
            .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.messagesCollectionView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.$scrollToBottomRequest
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] scrollRequest in
                if scrollRequest.scroll {
                    self?.messagesCollectionView.scrollToLastItem(at: .bottom, animated: scrollRequest.isAnimated)
                }
            }.store(in: &subscriptions)
    }
    
    @objc private func refreshData() {
        messagesCollectionView.refreshControl?.endRefreshing()
    }
}

private extension UICollectionView {
    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard numberOfItems(inSection: numberOfSections - 1) > 0 else { return }
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfItems(inSection: lastSectionIndex) - 1
        let lastRowIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        scrollToItem(at: lastRowIndexPath, at: scrollPosition, animated: animated)
    }
}

//  MARK: - MessageListController+UICollectionViewDelegate & UICollectionViewDataSource
extension MessageListController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        let message = viewModel.messages[indexPath.item]
        
        cell.contentConfiguration = UIHostingConfiguration {
            BubbleView(message: message, channel: viewModel.channel, isNewDay: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.dismissKeyboard()
        let message = viewModel.messages[indexPath.row]
        switch message.messageType {
        case .video:
            guard let videoURLString = message.videoURL,
                  let videoURL = URL(string: videoURLString) else { return }
            viewModel.showMediaPlayer(videoURL)
        default:
            break
        }
    }
}

#Preview {
    MessageListView(.init(.placeholder))
        .ignoresSafeArea()
}
