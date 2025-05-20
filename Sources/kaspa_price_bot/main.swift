import Foundation
import Alamofire
import AppKit

class MainWindowController: NSWindowController {
    private let priceLabel: NSTextField
    
    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 100),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Kaspa Price"
        window.center()
        
        // 设置窗口层级为浮动窗口
        window.level = .floating
        
        // 设置窗口始终保持在最前面
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // 创建价格标签
        priceLabel = NSTextField(frame: NSRect(x: 20, y: 40, width: 260, height: 20))
        priceLabel.isEditable = false
        priceLabel.isBordered = false
        priceLabel.backgroundColor = .clear
        priceLabel.alignment = .center
        priceLabel.font = .systemFont(ofSize: 16, weight: .medium)
        priceLabel.stringValue = "Loading..."
        
        window.contentView?.addSubview(priceLabel)
        
        super.init(window: window)
        
        // 确保窗口不会在关闭时退出应用
        window.isReleasedWhenClosed = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePrice(_ price: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.priceLabel.stringValue = "KAS: $\(String(format: "%.4f", price))"
        }
    }
}

class StatusBarController {
    private var statusItem: NSStatusItem!
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "KAS: Loading..."
    }
    
    func updatePrice(_ price: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.statusItem.button?.title = "KAS: $\(String(format: "%.4f", price))"
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindowController: MainWindowController?
    var statusBarController: StatusBarController?
    var timer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 设置应用程序为激活状态
        NSApp.setActivationPolicy(.regular)
        
        // 初始化窗口控制器
        mainWindowController = MainWindowController()
        mainWindowController?.showWindow(nil)
        
        // 初始化状态栏控制器
        statusBarController = StatusBarController()
        
        // 激活应用程序并将其带到前台
        NSApp.activate(ignoringOtherApps: true)
        
        // 启动定时器
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.fetchPrice()
        }
        timer?.fire()
    }
    
    func fetchPrice() {
        AF.request(priceURL).responseDecodable(of: KaspaTickerResponse.self) { [weak self] response in
            switch response.result {
            case .success(let tickerResponse):
                if let firstTicker = tickerResponse.tickers.first {
                    let price = firstTicker.last
                    // 更新窗口和状态栏的价格
                    self?.mainWindowController?.updatePrice(price)
                    self?.statusBarController?.updatePrice(price)
                    print("Price: $\(String(format: "%.4f", price))")
                }
            case .failure(let error):
                print("Error fetching price: \(error.localizedDescription)")
            }
        }
    }
    
    // 添加窗口关闭处理
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// 设置应用基本信息
let priceURL = "https://api.coingecko.com/api/v3/coins/kaspa/tickers?exchange_ids=gate"
let updateInterval: TimeInterval = 10 // 更新间隔（秒）

// 初始化应用
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// 创建主菜单（macOS应用必需）
let mainMenu = NSMenu()
app.mainMenu = mainMenu

app.run()