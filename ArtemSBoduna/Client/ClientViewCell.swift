import UIKit


final class ClientViewCell: UITableViewCell {
    static let reuseIdentifier: String = "ClientRoomViewCell"
    
    //MARK: - Private Properties
    private let descriptionLabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let visitsButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "medical.thermometer"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var visitsButtonAction: (() -> Void)?
    
  
    
    @objc
    private func didTapvisitsButton() {
        visitsButtonAction?()
    }
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Public Methods
    func setupCell(client: ClientResponse) {
        descriptionLabel.text = "\(client.fullName)\n\(client.phoneNumber)\n\(client.address)\nПотрачено: \(client.summa)\nНомер: \(client.livingRoom.number)"
    }
    
    
    //MARK: - Private Methods
    private func setupViews(){
        

        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(visitsButton)
        visitsButton.addTarget(self, action: #selector(didTapvisitsButton), for: .touchUpInside)
        

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: visitsButton.leadingAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            visitsButton.widthAnchor.constraint(equalToConstant: 44),
            visitsButton.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            visitsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
    }
}




