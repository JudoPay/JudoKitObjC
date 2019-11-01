import UIKit

protocol SettingsTableViewControllerDelegate: class {
    func settingsTable(viewController: SettingsTableViewController, didUpdate settings: Settings)
}

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var avsSwitch: UISwitch!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!

    weak var delegate: SettingsTableViewControllerDelegate?

    var settings: Settings?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let settings = settings else {
            return
        }

        avsSwitch.isOn = settings.isAVSEnabled

        let range = 0..<currencySegmentedControl.numberOfSegments
        let index = range.map { (index) -> String in
            return self.currencySegmentedControl.titleForSegment(at: index) ?? ""
        }.firstIndex(of: settings.currency)

        currencySegmentedControl.selectedSegmentIndex = index ?? 0
    }

    @IBAction func dismiss(_ sender: Any) {
        let index = currencySegmentedControl.selectedSegmentIndex
        let currency = currencySegmentedControl.titleForSegment(at: index) ?? "GBP"
        let settings = Settings(isAVSEnabled: avsSwitch.isOn, currency: currency)

        dismiss(animated: true) {
            self.delegate?.settingsTable(viewController: self, didUpdate: settings)
        }
    }

}
