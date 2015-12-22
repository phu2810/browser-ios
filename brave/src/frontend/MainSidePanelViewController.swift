import Storage

class MainSidePanelViewController : UIViewController {

  var browser:BrowserViewController?

  let bookmarks = BookmarksPanel()
  let history = HistoryPanel()

  var bookmarksButton = UIButton()
  var historyButton = UIButton()

  let topButtonsView = UIView()
  let addBookmarkButton = UIButton()

  //let triangleViewContainer = UIView()
  let triangleView = UIView()

  let tabTitleViewContainer = UIView()
  let tabTitleView = UILabel()

  override func viewDidLoad() {
    view.backgroundColor = UIColor(white: 77/255.0, alpha: 1.0)

    tabTitleViewContainer.backgroundColor = UIColor.whiteColor()
    tabTitleView.textColor = self.view.tintColor
    bookmarks.profile = getApp().profile
    history.profile = getApp().profile

    view.addSubview(topButtonsView)

    view.addSubview(tabTitleViewContainer)
    tabTitleViewContainer.addSubview(tabTitleView)
    topButtonsView.addSubview(triangleView)

    topButtonsView.addSubview(bookmarksButton)
    topButtonsView.addSubview(historyButton)
    topButtonsView.addSubview(addBookmarkButton)

    bookmarksButton.setTitle("B", forState: UIControlState.Normal)
    bookmarksButton.addTarget(self, action: "showBookmarks", forControlEvents: .TouchUpInside)

    historyButton.setTitle("H", forState: UIControlState.Normal)
    historyButton.addTarget(self, action: "showHistory", forControlEvents: .TouchUpInside)

    addBookmarkButton.setTitle("A", forState: UIControlState.Normal)
    addBookmarkButton.addTarget(self, action: "addBookmark", forControlEvents: .TouchUpInside)

    view.addSubview(history.view)
    view.addSubview(bookmarks.view)

    showBookmarks()

    bookmarks.view.hidden = false

    view.bringSubviewToFront(topButtonsView)
  }

  func addBookmark() {
    guard let tab = browser?.tabManager.selectedTab,
      let url = tab.displayURL?.absoluteString else {
        return
    }

    browser?.addBookmark(url, title: tab.title)
    showBookmarks()

    delay(0.1) {
      self.bookmarks.reloadData()
    }
  }

  func setupConstraints() {
    topButtonsView.snp_remakeConstraints {
      make in
      make.top.equalTo(view).offset(spaceForStatusBar())
      make.left.right.equalTo(view)
      make.height.equalTo(44.0)
    }

    bookmarksButton.snp_remakeConstraints {
      make in
      make.bottom.equalTo(self.topButtonsView)
      make.centerX.equalTo(self.topButtonsView).dividedBy(2.0)
    }

    historyButton.snp_remakeConstraints {
      make in
      make.bottom.equalTo(self.topButtonsView)
      make.centerX.equalTo(self.topButtonsView)
    }

    addBookmarkButton.snp_remakeConstraints {
      make in
      make.bottom.equalTo(self.topButtonsView)
      make.centerX.equalTo(self.topButtonsView).multipliedBy(1.5)
    }

    tabTitleViewContainer.snp_remakeConstraints {
      make in
      make.right.left.equalTo(view)
      make.top.equalTo(topButtonsView.snp_bottom)
      make.height.equalTo(44.0)
    }

    tabTitleView.snp_remakeConstraints {
      make in
      make.right.top.bottom.equalTo(tabTitleViewContainer)
      make.left.lessThanOrEqualTo(view).inset(24)
    }

    bookmarks.view.snp_remakeConstraints { make in
      make.left.right.bottom.equalTo(view)
      make.top.equalTo(tabTitleView.snp_bottom)
    }

    history.view.snp_remakeConstraints { make in
      make.left.right.bottom.equalTo(view)
      make.top.equalTo(tabTitleView.snp_bottom)
    }
  }

  func showBookmarks() {
    tabTitleView.text = "Bookmarks"
    history.view.hidden = true
    bookmarks.view.hidden = false
    moveTabIndicator(bookmarksButton)
  }

  func showHistory() {
    tabTitleView.text = "History"
    bookmarks.view.hidden = true
    history.view.hidden = false
    moveTabIndicator(historyButton)
  }

  func moveTabIndicator(button: UIButton) {
    triangleView.backgroundColor = UIColor.redColor()
    triangleView.snp_remakeConstraints {
      make in
      make.width.equalTo(button)
      make.height.equalTo(8)
      make.left.equalTo(button)
      make.top.equalTo(button.snp_bottom)
    }
  }

  func spaceForStatusBar() -> Double {
    let spacer = BraveApp.isIPhoneLandscape() ? 0.0 : 20.0
    return spacer
  }

  func verticalBottomPositionMainToolbar() -> Double {
    return Double(UIConstants.ToolbarHeight) + spaceForStatusBar()
  }

  func showAndSetDelegate(showing: Bool, delegate: HomePanelDelegate?) {
    if (showing) {
      bookmarks.tableView.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
      history.tableView.backgroundColor = bookmarks.tableView.backgroundColor
      bookmarks.homePanelDelegate = delegate
      bookmarks.reloadData()
      history.homePanelDelegate = delegate
      history.reloadData()
      setupConstraints()
    } else {
      bookmarks.homePanelDelegate = nil
      history.homePanelDelegate = nil
    }
  }

  func finishedShow() {
  }
}

