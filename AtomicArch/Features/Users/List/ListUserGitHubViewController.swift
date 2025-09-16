import AtomicCore
import Combine
import UIKit

protocol ListUserGitHubViewControllerDelegate: AnyObject {
  func didSelectUser(_ user: UserEntity)
}

final class ListUserGitHubViewController: UIViewController, View {
  typealias ViewModelType = ListUserGitHubViewModel

  // MARK: - Properties

  let viewModel: ViewModelType
  weak var delegate: ListUserGitHubViewControllerDelegate?

  // MARK: - UI Components

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.backgroundColor = .systemBackground
    tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    tableView.estimatedRowHeight = 80
    tableView.rowHeight = UITableView.automaticDimension
    return tableView
  }()

  private lazy var loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.color = .systemBlue
    indicator.hidesWhenStopped = true
    return indicator
  }()

  private lazy var errorView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    view.isHidden = true
    view.alpha = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var errorImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
    imageView.tintColor = .systemOrange
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .label
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var retryButton: UIButton = {
    let button = UIButton(type: .system)
    var configuration = UIButton.Configuration.filled()
    configuration.title = "Try Again"
    configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .systemFont(ofSize: 16, weight: .semibold)
      return outgoing
    }
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
    configuration.cornerStyle = .medium
    button.configuration = configuration
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .systemBlue
    refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    return refreshControl
  }()

  private lazy var scrollToTopButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
    button.tintColor = .systemBlue
    button.backgroundColor = .systemBackground
    button.layer.cornerRadius = 25
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 2)
    button.layer.shadowRadius = 4
    button.layer.shadowOpacity = 0.2
    button.alpha = 0
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(self.scrollToTopTapped), for: .touchUpInside)
    return button
  }()

  // MARK: - Initialization

  init(viewModel: ViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    self.setupConstraints()
    self.bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  // MARK: - View Protocol

  func setupUI() {
    view.backgroundColor = .systemBackground
    title = "GitHub Users"
    navigationController?.navigationBar.prefersLargeTitles = true

    self.tableView.refreshControl = self.refreshControl

    view.addSubview(self.tableView)
    view.addSubview(self.loadingIndicator)
    view.addSubview(self.scrollToTopButton)

    self.errorView.addSubview(self.errorImageView)
    self.errorView.addSubview(self.errorLabel)
    self.errorView.addSubview(self.retryButton)
    view.addSubview(self.errorView)
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      // Table View
      self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      // Scroll to Top Button
      self.scrollToTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      self.scrollToTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      self.scrollToTopButton.widthAnchor.constraint(equalToConstant: 50),
      self.scrollToTopButton.heightAnchor.constraint(equalToConstant: 50),

      // Loading Indicator
      self.loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      self.loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      // Error View
      self.errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      self.errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      self.errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      self.errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      // Error Image
      self.errorImageView.centerXAnchor.constraint(equalTo: self.errorView.centerXAnchor),
      self.errorImageView.centerYAnchor.constraint(equalTo: self.errorView.centerYAnchor, constant: -60),
      self.errorImageView.widthAnchor.constraint(equalToConstant: 60),
      self.errorImageView.heightAnchor.constraint(equalToConstant: 60),

      // Error Label
      self.errorLabel.topAnchor.constraint(equalTo: self.errorImageView.bottomAnchor, constant: 16),
      self.errorLabel.leadingAnchor.constraint(equalTo: self.errorView.leadingAnchor, constant: 32),
      self.errorLabel.trailingAnchor.constraint(equalTo: self.errorView.trailingAnchor, constant: -32),

      // Retry Button
      self.retryButton.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 24),
      self.retryButton.centerXAnchor.constraint(equalTo: self.errorView.centerXAnchor)
    ])
  }

  func bind() {
    // Create input publishers
    let loadUsers = Just(()).eraseToAnyPublisher()
    let loadMore = PassthroughSubject<UserEntity, Never>()

    // Transform input to output
    let output = self.viewModel.transform(input: .init(
      loadUsers: loadUsers,
      loadMore: loadMore.eraseToAnyPublisher()
    ))

    // Bind output to UI
    output.viewState
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.handleViewState(state)
      }
      .store(in: &self.viewModel.cancellables)

    // Store loadMore subject for later use
    self.loadMoreSubject = loadMore
  }

  // MARK: - Private Properties

  private var loadMoreSubject: PassthroughSubject<UserEntity, Never>?

  // MARK: - Private Methods

  private func handleViewState(_ state: ViewModelType.ViewState) {
    switch state {
    case .idle:
      self.animateStateTransition {
        self.tableView.isHidden = true
        self.loadingIndicator.stopAnimating()
        self.errorView.isHidden = true
      }

    case .loading:
      self.animateStateTransition {
        // Only hide table view if we don't have any users yet
        if self.viewModel.users.isEmpty {
          self.tableView.isHidden = true
        }
        self.loadingIndicator.startAnimating()
        self.errorView.isHidden = true
      }

    case .loaded:
      self.animateStateTransition {
        self.tableView.isHidden = false
        self.loadingIndicator.stopAnimating()
        self.errorView.isHidden = true
        self.tableView.reloadData()
      }
      self.refreshControl.endRefreshing()

    case .error:
      self.animateStateTransition {
        self.tableView.isHidden = true
        self.loadingIndicator.stopAnimating()
        self.errorView.isHidden = false
        self.errorLabel.text = "A server error occurred. Please try again"
      }
      self.refreshControl.endRefreshing()
    }
  }

  private func animateStateTransition(_ changes: @escaping () -> Void) {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      changes()
      self.errorView.alpha = self.errorView.isHidden ? 0 : 1
    }
  }

  @objc private func refreshData() {
    Task {
      await self.viewModel.loadUsers()
    }
  }

  @objc private func scrollToTopTapped() {
    self.tableView.setContentOffset(.zero, animated: true)
  }
}

// MARK: - UITableViewDataSource

extension ListUserGitHubViewController: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    self.viewModel.users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
      return UITableViewCell()
    }

    let user = self.viewModel.users[indexPath.row]
    cell.configure(with: user)
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ListUserGitHubViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let user = self.viewModel.users[indexPath.row]
    self.delegate?.didSelectUser(user)
  }

  func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let user = self.viewModel.users[indexPath.row]
    self.loadMoreSubject?.send(user)

    // Add fade-in animation for cells
    cell.alpha = 0
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
      cell.alpha = 1
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let shouldShowButton = scrollView.contentOffset.y > 300
    UIView.animate(withDuration: 0.3) {
      self.scrollToTopButton.alpha = shouldShowButton ? 1 : 0
    }
  }
}
