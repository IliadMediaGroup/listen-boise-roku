Sub Init()
    print "ListenLiveView: Entering init"
    m.stationGrid = m.top.FindNode("stationGrid")
    m.playbackUI = m.top.FindNode("playbackUI")
    m.toggleButton = m.top.FindNode("toggleButton")
    m.stationLabel = m.top.FindNode("stationLabel")
    m.songLabel = m.top.FindNode("songLabel")
    m.artistLabel = m.top.FindNode("artistLabel")
    m.albumCoverPoster = m.top.FindNode("albumCoverPoster")
    m.tabGroup = m.top.getScene().FindNode("tabGroup")
    m.tabContainer = m.top.getScene().FindNode("tabContainer")
    m.contentStack = m.top.getScene().FindNode("contentStack")
    m.background = m.top.getScene().FindNode("background")
    m.appLogo = m.top.getScene().FindNode("appLogo")

    if m.stationGrid = invalid or m.playbackUI = invalid or m.toggleButton = invalid or m.stationLabel = invalid or m.songLabel = invalid or m.artistLabel = invalid or m.albumCoverPoster = invalid or m.tabGroup = invalid or m.tabContainer = invalid or m.contentStack = invalid or m.background = invalid or m.appLogo = invalid
        print "ERROR: ListenLiveView - Node not found"
        return
    end if

    m.stations = [
        {title: "101.9 The Bull", url: "https://ice64.securenetsystems.net/KQBL", poster: "pkg:/images/bull.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBL.xml"},
        {title: "My 102.7", url: "https://ice9.securenetsystems.net/KZMG", poster: "pkg:/images/my.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KZMG.xml"},
        {title: "Bob FM 96.1", url: "https://ice64.securenetsystems.net/KSRV", poster: "pkg:/images/bob.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KSRV.xml"},
        {title: "Wild 101.1", url: "https://ice9.securenetsystems.net/KWYD", poster: "pkg:/images/wild.png", xmlUrl: "https://streamdb7web.securenetsystems.net/player_status_update/KWYD.xml"},
        {title: "IRock 99.1 FM", url: "https://ice64.securenetsystems.net/KQBLHD2", poster: "pkg:/images/irock.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2.xml"},
        {title: "Fox Sports 99.9", url: "https://ice64.securenetsystems.net/KSRVHD2", poster: "pkg:/images/fox.png", xmlUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2.xml"},
        {title: "101.5 Kool FM", url: "https://ice5.securenetsystems.net/KKOO", poster: "pkg:/images/kool.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KKOO.xml"},
        {title: "96.5 The Alternative", url: "https://ice9.securenetsystems.net/KQBLHD3", poster: "pkg:/images/alt.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3.xml"}
    ]

    m.stationGrid.visible = true
    m.playbackUI.visible = false
    m.stationGrid.numColumns = 4
    m.stationGrid.itemSize = "[200, 200]"
    m.stationGrid.itemSpacing = "[20, 20]"
    m.isGridContentLoaded = false

    print "ListenLiveView: Setting observers"
    m.stationGrid.observeField("itemFocused", "OnStationGridItemFocused")
    m.stationGrid.observeField("itemSelected", "OnStationGridItemSelected")
    m.top.observeField("keyEvent", "onKeyEvent")
    m.toggleButton.observeField("keyEvent", "OnToggleButtonKeyEvent")
    m.top.observeField("selectedStationIndex", "onStationSelected")

    print "ListenLiveView: Init complete"
End Sub

Sub LoadStationGridContent()
    if m.isGridContentLoaded
        print "ListenLiveView: stationGrid content already loaded"
        return
    end if

    print "ListenLiveView: Loading stationGrid content"
    content = CreateObject("roSGNode", "ContentNode")
    for each station in m.stations
        child = content.CreateChild("ContentNode")
        child.title = station.title
        child.url = station.url
        child.HDPosterUrl = station.poster
        child.SDPosterUrl = station.poster
    end for
    m.stationGrid.content = content
    m.isGridContentLoaded = true
    print "ListenLiveView: stationGrid content loaded"
End Sub

Sub OnStationGridItemFocused()
    focusedIndex = m.stationGrid.itemFocused
    print "ListenLiveView: stationGrid itemFocused: "; focusedIndex; ", grid hasFocus: "; m.stationGrid.hasFocus()
    if not m.isGridContentLoaded and m.stationGrid.hasFocus()
        LoadStationGridContent()
    end if
End Sub

Sub OnStationGridItemSelected()
    selectedIndex = m.stationGrid.itemSelected
    print "ListenLiveView: stationGrid itemSelected: "; selectedIndex; ", grid hasFocus: "; m.stationGrid.hasFocus()
    m.top.selectedStationIndex = selectedIndex
End Sub

Sub onStationSelected()
    selectedIndex = m.top.selectedStationIndex
    print "ListenLiveView: onStationSelected triggered, selectedStationIndex: "; selectedIndex

    if selectedIndex < 0 or selectedIndex >= m.stations.Count()
        print "ListenLiveView: Invalid station index: "; selectedIndex
        return
    end if

    m.stationLabel.text = m.stations[selectedIndex].title
    m.songLabel.text = "Loading..."
    m.artistLabel.text = "Loading..."
    m.albumCoverPoster.uri = m.stations[selectedIndex].poster
    m.playbackUI.visible = true
    m.stationGrid.visible = false
    m.albumCoverPoster.visible = true
    m.toggleButton.visible = true
    m.artistLabel.visible = true
    m.stationLabel.visible = true
    m.songLabel.visible = true

    print "ListenLiveView: Set albumCoverPoster uri to fallback: "; m.stations[selectedIndex].poster
    print "ListenLiveView: playbackUI visible: "; m.playbackUI.visible
    print "ListenLiveView: albumCoverPoster visible: "; m.albumCoverPoster.visible
    print "ListenLiveView: toggleButton visible: "; m.toggleButton.visible
    print "ListenLiveView: artistLabel visible: "; m.artistLabel.visible
    print "ListenLiveView: stationLabel visible: "; m.stationLabel.visible
    print "ListenLiveView: songLabel visible: "; m.songLabel.visible

    print "ListenLiveView: top boundingRect: "; m.top.boundingRect()
    print "ListenLiveView: playbackUI boundingRect: "; m.playbackUI.boundingRect()
    print "ListenLiveView: albumCoverPoster boundingRect: "; m.albumCoverPoster.boundingRect()
    print "ListenLiveView: toggleButton boundingRect: "; m.toggleButton.boundingRect()
    print "ListenLiveView: artistLabel boundingRect: "; m.artistLabel.boundingRect()
    print "ListenLiveView: stationLabel boundingRect: "; m.stationLabel.boundingRect()
    print "ListenLiveView: songLabel boundingRect: "; m.songLabel.boundingRect()

    print "ListenLiveView: Hiding MainScene UI elements using FindNode (excluding appLogo)"
    m.tabGroup.visible = false
    m.tabContainer.visible = false
    m.contentStack.visible = true
    m.background.visible = true
    m.appLogo.visible = true
    print "ListenLiveView: appLogo visible: "; m.appLogo.visible
    print "ListenLiveView: tabGroup visible: "; m.tabGroup.visible
    print "ListenLiveView: tabContainer visible: "; m.tabContainer.visible
    print "ListenLiveView: contentStack visible: "; m.contentStack.visible
    print "ListenLiveView: Keeping background visible"
    print "ListenLiveView: Scene visibility: "; m.top.visible
    print "ListenLiveView: Scene focus: "; m.top.hasFocus()
    m.toggleButton.setFocus(true)
    print "ListenLiveView: toggleButton focus: "; m.toggleButton.hasFocus()

    m.metaTask = CreateObject("roSGNode", "FetchMetaTask")
    m.metaTask.xmlUrl = m.stations[selectedIndex].xmlUrl
    m.metaTask.observeField("artist", "OnArtistFetched")
    m.metaTask.observeField("songTitle", "OnSongTitleFetched")
    m.metaTask.control = "RUN"
    print "ListenLiveView: FetchMetaTask started for URL: "; m.stations[selectedIndex].xmlUrl
End Sub

Sub OnArtistFetched()
    artist = m.metaTask.artist
    print "ListenLiveView: Artist fetched: "; artist
    m.artistLabel.text = artist
    print "ListenLiveView: Updated artistLabel text to: "; artist
End Sub

Sub OnSongTitleFetched()
    songTitle = m.metaTask.songTitle
    print "ListenLiveView: Song title fetched: "; songTitle
    m.songLabel.text = songTitle
    print "ListenLiveView: Updated songLabel text to: "; songTitle
End Sub

Function OnToggleButtonKeyEvent() As Boolean
    key = m.toggleButton.keyEvent.key
    press = m.toggleButton.keyEvent.press
    print "ListenLiveView: Toggle button key event - Key: "; key; ", Press: "; press
    if press and (key = "OK" or key = "play")
        print "ListenLiveView: OK or play key pressed on toggleButton, notifying MainScene"
        m.top.getScene().callFunc("OnToggleButton", {})
        return true
    end if
    return false
End Function

Function onKeyEvent(key as String, press as Boolean) As Boolean
    print "ListenLiveView: Key event - Key: "; key; ", Press: "; press; ", stationGrid hasFocus: "; m.stationGrid.hasFocus()
    if not press
        return false
    end if

    if m.playbackUI.visible and m.toggleButton.hasFocus()
        if key = "back"
            print "ListenLiveView: Back key pressed in playbackUI, returning to tabGroup"
            m.stationGrid.visible = true
            m.playbackUI.visible = false
            m.tabGroup.visible = true
            m.tabContainer.visible = true
            m.contentStack.visible = true
            m.background.visible = true
            m.appLogo.visible = true
            m.tabGroup.setFocus(true)
            m.top.getScene().FindNode("listenLiveTab").setFocus(true)
            print "ListenLiveView: listenLiveTab focus: "; m.top.getScene().FindNode("listenLiveTab").hasFocus()
            print "ListenLiveView: tabGroup focus: "; m.tabGroup.hasFocus()
            return true
        else if key = "OK" or key = "play"
            print "ListenLiveView: OK or play key pressed in playbackUI, notifying MainScene"
            m.top.getScene().callFunc("OnToggleButton", {})
            return true
        end if
    else if m.stationGrid.visible and m.stationGrid.hasFocus()
        if key = "left"
            focusedIndex = m.stationGrid.itemFocused
            print "ListenLiveView: Left key pressed in stationGrid, focused index: "; focusedIndex
            if focusedIndex = 0 or focusedIndex = 4
                print "ListenLiveView: In leftmost column, moving focus to tabGroup"
                m.tabGroup.setFocus(true)
                m.top.getScene().FindNode("listenLiveTab").setFocus(true)
                return true
            end if
        else if key = "OK"
            focusedIndex = m.stationGrid.itemFocused
            print "ListenLiveView: OK key pressed in stationGrid, index: "; focusedIndex; ", grid hasFocus: "; m.stationGrid.hasFocus()
            if m.stationGrid.hasFocus() and m.isGridContentLoaded
                m.stationGrid.itemSelected = focusedIndex
                return true
            else
                print "ListenLiveView: stationGrid not focused or content not loaded, ignoring OK key"
                return false
            end if
        end if
    end if

    return false
End Function