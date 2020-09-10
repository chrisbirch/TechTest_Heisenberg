import UIKit
class ListViewControllerModel: ViewControllerModel {
    var characters = [Character.Character]()
    var error: Error?
    var filteredBySeason: [Int]?
    var searchForName: String?
    
    
    override func controllerConnected() {
        filteredBySeason = nil
        searchForName = nil
        listCharacters(returnFromCache: false)
    }
    
    func listCharacters(returnFromCache: Bool = true) {
        let characterService = Injected.characterService!
        let request = Character.CharacterRequest(returnFromCacheIfAvailable: returnFromCache, searchForName: searchForName, filterBySeason: filteredBySeason)
        characterService.retrieveCharacters(request) {[weak self] result in
            guard let self = self else { return }
            self.characters = []
            self.error = nil
            switch result {
            case .success(let chars):
                self.characters = chars
            case .failure(let error):
                self.error = error
            }

            self.viewController?.updateFromModel()
        }
    }
    
    
}
class ListViewController: ModelViewController<ListViewControllerModel> {
     let backgroundImageView = ImageView(UIImage(named: "BackgroundImage")!).content(.scaleAspectFill)
    let topBarView = View()
    let tableView = UITableView()
    let busyView = BusyView()
        .backgroundColour(UIColor.black.withAlphaComponent(0.8))
    lazy var searchBar = SearchBar(placeholder: "Enter character name")
        .textChanged {[unowned self] text in
            guard let model = self.model else { return }
            model.searchForName = text
            model.listCharacters()
    }
    lazy var seasonFilterBar = SeasonFilterBar().seasonsSelected { selectedSeasons in
        guard let model = self.model else { return }
        model.filteredBySeason = selectedSeasons
        model.listCharacters()
    }
    private lazy var searchControlStack = StackView(.vertical, [
        searchBar,  seasonFilterBar
    ])

    private lazy var stackView = StackView(.vertical, spacing: 0, [
        topBarView,  tableView
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Breaking Bad Explorer"
        tableView.delegate = self
        
        tableView.dataSource = self
        tableView.register(ListTableCell.self, forCellReuseIdentifier: ListTableCell.reuseIdentifier)
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        topBarView.add(view: searchControlStack)
        view.add(view: backgroundImageView, Edges.rect.bottom(-40))
        view.add(view: stackView, .topLeftRightSafe)
        view.add(view: busyView)
       
        stackView.vConstrain(.bottom, to: view, .bottom)
        let barBackgroundColour = UIColor(red: 0.071, green: 0.093, blue: 0.027, alpha: 1)
        let barForegroundColour = UIColor.white
        searchBar.barTintColor = barBackgroundColour
        searchBar.tintColor = barForegroundColour
        searchBar.searchTextField.textColor = barForegroundColour
        navigationController?.navigationBar.barTintColor = barBackgroundColour
        navigationController?.navigationBar.tintColor = barForegroundColour
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: barForegroundColour]
        searchBar.beganEditing = {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tapGesture)
        }
        searchBar.endedEditing = {
            self.searchBar.resignFirstResponder()
        }
        busyView.retryHandler = {[unowned self] in
            self.busyView.state = .busy
            self.busyView.isHidden = false
            self.model?.listCharacters(returnFromCache: false)
        }
        busyView.loadingText = "Please wait - Loading content"
        
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    override func updateFromModel() {
        guard let model = model else { return }
        if let error = model.error {
            busyView.state = .retry
            busyView.isHidden = false
        } else {
            tableView.reloadData()
            if model.characters.isEmpty == false {
                busyView.isHidden = true
            }
        }
        
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
        view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.characters.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model, model.characters.count > indexPath.row else { return UITableViewCell() }
        let cellModel = model.characters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.reuseIdentifier, for: indexPath) as! ListTableCell
        cell.selectionStyle = .none
        cell.model = cellModel
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = model, model.characters.count > indexPath.row else { return }
        let charModel = model.characters[indexPath.row]
        let vc = DetailViewController(model: DetailViewControllerModel(charModel))
        present(vc, animated: true)
    }
}


