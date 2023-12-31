import UIKit


final class ClientViewController: UIViewController {
    //MARK: - Private Properties
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.placeholder = "ФИО"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Поиск", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.separatorColor = .black
        return tableView
    }()
    
    var cellDataSource: [ClientResponse] = []
    private let clientService = ClientService()
    private var selectedLivingRoom: LivingRoomResponse?
    private var currentPage = 0
    private let itemsPerPage = 20
    private var currentAlert: UIAlertController?
    private var inLoad = false
    private var isEnd = false {
        didSet {
            if isEnd == false {
                currentPage = 0
                cellDataSource = []
                getClient()
            }
        }
    }
    //MARK: - Override methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}


//MARK: - Private Methods
private extension ClientViewController {
    
    func setupView() {
        view.backgroundColor = .darkGray
        setupTableView()
        addSubviews()
        activateConstraints()
        getClient()
        addAction()
    }
    
    func addAction() {
        addButton.addTarget(self, action: #selector(Self.didTapAddButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(Self.searchWithFilter), for: .touchUpInside)
    }
    
    @objc
    func searchWithFilter() {
        
        isEnd = false
    }
    
    @objc
    func openSelect() {
        let vc = SelectLivingRoomViewController()
        vc.delegate = self
        currentAlert?.present(vc, animated: true)
    }
    
    
    @objc
    func didTapAddButton() {
        let alert = UIAlertController(title: "Клиент", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "ФИО"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Номер телефона"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Адрес"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Комната"
            textField.addTarget(self, action: #selector(Self.openSelect), for: .editingDidBegin)
        }
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
            if let self,
               let name = alert?.textFields?[0].text,
               let phone = alert?.textFields?[1].text,
               let address = alert?.textFields?[2].text,
               let room = selectedLivingRoom
            {
                let client = ClientRequest(fullName: name, phoneNumber: phone, address: address, livingRoomId: room.id)
                self.clientService.addClient(client: client, completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success( _):
                        selectedLivingRoom = nil
                        isEnd = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                    }
                })
            }
        }
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancel)
        currentAlert = alert
        self.present(alert, animated: true)
    }
    
    func getClient() {
        inLoad.toggle()
        clientService.fetchAllClient(page: currentPage, count: itemsPerPage, param: nameTextField.text ?? "", completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let clients):
                if clients.isEmpty {
                    currentPage += 1
                }
                else {
                    isEnd = true
                }
                self.cellDataSource.append(contentsOf: clients)
                inLoad.toggle()
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                inLoad.toggle()
                let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
        })
    }
    
    func updateCLient(client: ClientResponse) {
        selectedLivingRoom = client.livingRoom
        let alert = UIAlertController(title: "Клиент", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "ФИО"
            textField.text = client.fullName
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Номер телефона"
            textField.text = client.phoneNumber
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Адрес"
            textField.text = client.address
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Комната"
            textField.addTarget(self, action: #selector(Self.openSelect), for: .editingDidBegin)
            textField.text = "Номер: \(client.livingRoom.number)"
        }
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
            if let self,
               let name = alert?.textFields?[0].text,
               let phone = alert?.textFields?[1].text,
               let address = alert?.textFields?[2].text,
               let room = selectedLivingRoom
            {
                let newClient = ClientRequest(fullName: name, phoneNumber: phone, address: address, livingRoomId: room.id)
                self.clientService.updateClient(clientId: client.id ,client: newClient, completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success( _):
                        selectedLivingRoom = nil
                        isEnd = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                    }
                })
            }
        }
        alert.addAction(save)
        let delete = UIAlertAction(title: "Удалить", style: .default) { [weak self] _ in
            if let self
            {
                self.clientService.deleteClient(clientId: client.id, completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success( _):
                        selectedLivingRoom = nil
                        isEnd = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                    }
                })
            }
        }
        alert.addAction(delete)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancel)
        currentAlert = alert
        self.present(alert, animated: true)
    }
    
    
    func addSubviews(){
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(searchButton)
        view.addSubview(nameTextField)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            addButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -20),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            searchButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalTo: searchButton.widthAnchor, multiplier: 1),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
    }
    
    func registerCell() {
        tableView.register(ClientViewCell.self, forCellReuseIdentifier: ClientViewCell.reuseIdentifier)
    }
    
}


//MARK: - UITableViewDelegate
extension ClientViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCLient(client: cellDataSource[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height && !inLoad && !isEnd{
            getClient()
        }
    }
    
}

//MARK: - UITableViewDataSource
extension ClientViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClientViewCell.reuseIdentifier, for: indexPath) as? ClientViewCell else { return UITableViewCell() }
            let client = cellDataSource[indexPath.row]
        cell.setupCell(client: client)
        cell.visitsButtonAction = { [weak self] in
            guard let self else { return }
            let vc = ClientProcedureViewController()
            vc.client = client
            self.present(vc, animated: true)
        }
        return cell
    }
    
}


extension ClientViewController: SelectLivingRoomDelegate {
    
    func setLivingRoom(_ room: LivingRoomResponse) {
        selectedLivingRoom = room
        currentAlert?.textFields?.last?.text = "Номер: \(room.number)"
    }
    
}
