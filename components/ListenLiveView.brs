Sub Init()
    print "ListenLiveView: Entering init"
    m.stationGrid = m.top.FindNode("stationGrid")
    m.playbackUI = invalid
    m.toggleButton = invalid
    m.stationLabel = invalid
    m.songLabel = invalid
    m.artistLabel = invalid
    m.albumCoverPoster = invalid
    m.isPlaybackUILoaded = false

    if m.stationGrid = invalid
        print "ERROR: ListenLiveView - stationGrid not found"
        return
    end if

    m.stationGrid.visible = true
    m.stationGrid.numColumns = 4
    m.stationGrid.itemSize = "[150, 150]"
    m.stationGrid.itemSpacing = "[20, 20]"
    m.stationGrid.translation = "[60, -4]"

    print "ListenLiveView: Loading stationGrid content"
    LoadStationGridContent()
    print "ListenLiveView: stationGrid content loaded"

    print "ListenLiveView: Setting observers"
    m.stationGrid.observeField("itemSelected", "OnStationGridItemSelected")
    m.top.observeField("keyEvent", "onKeyEvent")
    m.top.observeField("selectedStationIndex", "onStationSelected")
    m.top.observeField("stations", "onStationsUpdated")

    print "ListenLiveView: stationGrid initial state - focused item: "; m.stationGrid.itemFocused; ", hasFocus: "; m.stationGrid.hasFocus()
    print "ListenLiveView: Init complete"
End Sub

Sub onStationsUpdated()
    print "ListenLiveView: Stations updated, count: "; m.top.stations.Count()
    if m.top.stations = invalid or m.top.stations.Count() = 0
        print "ERROR: ListenLiveView - Invalid or empty stations data"
        return
    end if
    LoadStationGridContent()
End Sub

Sub LoadStationGridContent()
    print "ListenLiveView: Loading stationGrid content"
    if m.top.stations = invalid or m.top.stations.Count() = 0
        print "ERROR: ListenLiveView - No valid stations data"
        return
    end if
    content = CreateObject("roSGNode", "ContentNode")
    for each station in m.top.stations
        child = content.CreateChild("ContentNode")
        child.title = station.title
        child.url = station.url
        child.HDPosterUrl = station.poster
        child.SDPosterUrl = station.poster
        print "ListenLiveView: Added station to grid: "; station.title
    end for
    m.stationGrid.content = content
    print "ListenLiveView: stationGrid content loaded, item count: "; m.stationGrid.content.GetChildCount()
End Sub

Sub LoadPlaybackUI()
    if m.isPlaybackUILoaded
        print "ListenLiveView: playbackUI already loaded"
        return
    end if
    print "ListenLiveView: Loading playbackUI"
    m.playbackUI = m.top.FindNode("playbackUI")
    m.stationLabel = m.playbackUI.FindNode("stationLabel")
    m.songLabel = m.playbackUI.FindNode("songLabel")
    m.artistLabel = m.playbackUI.FindNode("artistLabel")
    m.albumCoverPoster = m.playbackUI.FindNode("albumCoverPoster")
    m.toggleButton = m.playbackUI.FindNode("toggleButton")
    if m.playbackUI = invalid or m.stationLabel = invalid or m.songLabel = invalid or m.artistLabel = invalid or m.albumCoverPoster = invalid or m.toggleButton = invalid
        print "ERROR: ListenLiveView - Playback UI nodes not found"
        return
    end if
    m.toggleButton.observeField("keyEvent", "OnToggleButtonKeyEvent")
    m.isPlaybackUILoaded = true
    print "ListenLiveView: playbackUI loaded"
End Sub

Sub OnStationGridItemSelected()
    selectedIndex = m.stationGrid.itemSelected
    print "ListenLiveView: stationGrid itemSelected: "; selectedIndex; ", Focused: "; m.stationGrid.itemFocused; ", Grid hasFocus: "; m.stationGrid.hasFocus()
    if selectedIndex >= 0 and selectedIndex < m.top.stations.Count()
        print "ListenLiveView: Setting selectedStationIndex to: "; selectedIndex
        m.top.selectedStationIndex = selectedIndex
    else
        print "ListenLiveView: Invalid station index: "; selectedIndex
    end if
End Sub

Sub onStationSelected()
    selectedIndex = m.top.selectedStationIndex
    print "ListenLiveView: onStationSelected triggered, selectedStationIndex: "; selectedIndex

    if selectedIndex < 0 or selectedIndex >= m.top.stations.Count()
        print "ListenLiveView: Invalid station index: "; selectedIndex
        return
    end if

    if not m.isPlaybackUILoaded
        LoadPlaybackUI()
    end if

    if m.playbackUI = invalid or m.stationLabel = invalid or m.songLabel = invalid or m.artistLabel = invalid or m.albumCoverPoster = invalid or m.toggleButton = invalid
        print "ERROR: ListenLiveView - Playback UI nodes not loaded"
        return
    end if

    m.stationLabel.text = m.top.stations[selectedIndex].title
    m.songLabel.text = "Loading..."
    m.artistLabel.text = "Loading..."
    m.albumCoverPoster.uri = m.top.stations[selectedIndex].poster
    m.playbackUI.visible = true
    m.stationGrid.visible = false
    m.albumCoverPoster.visible = true
    m.toggleButton.visible = true
    m.artistLabel.visible = true
    m.stationLabel.visible = true
    m.songLabel.visible = true

    tabGroup = m.top.getScene().FindNode("tabGroup")
    tabContainer = m.top.getScene().FindNode("tabContainer")
    contentStack = m.top.getScene().FindNode("contentStack")
    appLogo = m.top.getScene().FindNode("appLogo")
    background = m.top.getScene().FindNode("background")

    print "ListenLiveView: Managing MainScene UI elements"
    if appLogo <> invalid
        appLogo.visible = true
    end if
    if tabGroup <> invalid
        tabGroup.visible = true
    end if
    if tabContainer <> invalid
        tabContainer.visible = true
    end if
    if contentStack <> invalid
        contentStack.visible = true
    end if
    if background <> invalid
        print "ListenLiveView: Keeping background visible"
        background.visible = true
    end if

    print "ListenLiveView: Set albumCoverPoster uri to: "; m.top.stations[selectedIndex].poster
    print "ListenLiveView: playbackUI visible: "; m.playbackUI.visible
    m.top.getScene().callFunc("ShowPlaybackUI", {})
    m.toggleButton.setFocus(true)
    print "ListenLiveView: Scene visibility: "; m.top.getScene().visible
    print "ListenLiveView: Scene focus: "; m.top.getScene().hasFocus()
    print "ListenLiveView: toggleButton focus: "; m.toggleButton.hasFocus()

    m.metaTask = CreateObject("roSGNode", "FetchMetaTask")
    m.metaTask.xmlUrl = m.top.stations[selectedIndex].xmlUrl
    m.metaTask.observeField("artist", "OnArtistFetched")
    m.metaTask.observeField("songTitle", "OnSongTitleFetched")
    m.metaTask.control = "RUN"
    print "ListenLiveView: FetchMetaTask started for URL: "; m.top.stations[selectedIndex].xmlUrl
End Sub

Sub OnArtistFetched()
    if m.artistLabel = invalid
        print "ListenLiveView: artistLabel not loaded, ignoring artist fetch"
        return
    end if
    artist = m.metaTask.artist
    if artist = "" or artist = invalid
        artist = "Unknown Artist"
    end if
    print "ListenLiveView: Artist fetched: "; artist
    m.artistLabel.text = artist
End Sub

Sub OnSongTitleFetched()
    if m.songLabel = invalid
        print "ListenLiveView: songLabel not loaded, ignoring song title fetch"
        return
    end if
    songTitle = m.metaTask.songTitle
    if songTitle = "" or songTitle = invalid
        songTitle = "Unknown Song"
    end if
    print "ListenLiveView: Song title fetched: "; songTitle
    m.songLabel.text = songTitle
End Sub

Function OnToggleButtonKeyEvent() As Boolean
    if m.toggleButton = invalid
        print "ListenLiveView: toggleButton not loaded, ignoring key event"
        return false
    end if
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

    if m.playbackUI <> invalid and m.playbackUI.visible and m.toggleButton <> invalid and m.toggleButton.hasFocus()
        if key = "back"
            print "ListenLiveView: Back key pressed in playbackUI, returning to tabGroup"
            m.stationGrid.visible = true
            m.playbackUI.visible = false
            tabGroup = m.top.getScene().FindNode("tabGroup")
            tabContainer = m.top.getScene().FindNode("tabContainer")
            contentStack = m.top.getScene().FindNode("contentStack")
            appLogo = m.top.getScene().FindNode("appLogo")
            background = m.top.getScene().FindNode("background")
            if tabGroup <> invalid
                tabGroup.visible = true
                tabGroup.setFocus(true)
                listenLiveTab = tabGroup.FindNode("listenLiveTab")
                if listenLiveTab <> invalid
                    listenLiveTab.setFocus(true)
                end if
            end if
            if tabContainer <> invalid
                tabContainer.visible = true
            end if
            if contentStack <> invalid
                contentStack.visible = true
            end if
            if appLogo <> invalid
                appLogo.visible = true
            end if
            if background <> invalid
                background.visible = true
            end if
            return true
        else if key = "OK" or key = "play"
            print "ListenLiveView: OK or play key pressed in playbackUI, notifying MainScene"
            print "DEBUG: Scene ID: "; m.top.getScene().id
            m.top.getScene().callFunc("OnToggleButton", {})
            return true
        end if
    else if m.stationGrid.visible and m.stationGrid.hasFocus()
        if key = "left"
            focusedIndex = m.stationGrid.itemFocused
            print "ListenLiveView: Left key pressed in stationGrid, focused index: "; focusedIndex
            if focusedIndex = 0 or focusedIndex = 4
                print "ListenLiveView: In leftmost column, moving focus to tabGroup"
                tabGroup = m.top.getScene().FindNode("tabGroup")
                if tabGroup <> invalid
                    tabGroup.setFocus(true)
                    listenLiveTab = tabGroup.FindNode("listenLiveTab")
                    if listenLiveTab <> invalid
                        listenLiveTab.setFocus(true)
                    end if
                end if
                return true
            end if
        else if key = "OK"
            focusedIndex = m.stationGrid.itemFocused
            print "ListenLiveView: OK key pressed in stationGrid, index: "; focusedIndex
            if m.stationGrid.hasFocus()
                m.stationGrid.itemSelected = focusedIndex
                return true
            end if
        end if
    end if
    return false
End Function