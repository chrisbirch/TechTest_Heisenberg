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
        let request = Character.CharacterRequest(returnFromCacheIfAvaiable: returnFromCache, searchForName: searchForName, filterBySeason: filteredBySeason)
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

    private lazy var stackView = StackView(.vertical, [
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
        view.add(view: backgroundImageView)
        view.add(view: stackView, .rectSafe)
    }
    
    override func updateFromModel() {
        guard model != nil else { return }
        tableView.reloadData()
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
