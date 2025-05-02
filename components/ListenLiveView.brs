sub init()
    print "ListenLiveView: Entering init"
    m.stationGrid = m.top.FindNode("stationGrid")
    m.playbackUI = m.top.FindNode("playbackUI")
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    m.toggleButton = m.top.FindNode("toggleButton")
    m.stationLabel = m.top.FindNode("stationLabel")
    m.songLabel = m.top.FindNode("songLabel")
    m.artistLabel = m.top.FindNode("artistLabel")
    m.albumCoverPoster = m.top.FindNode("albumCoverPoster")
=======
=======
>>>>>>> Stashed changes
    m.toggleButton = m.playbackUI.FindNode("toggleButton")
    m.stationLabel = m.playbackUI.FindNode("stationLabel")
    m.songLabel = m.playbackUI.FindNode("songLabel")
    m.artistLabel = m.playbackUI.FindNode("artistLabel")
    m.albumCoverPoster = m.playbackUI.FindNode("albumCoverPoster")
    m.isPlaybackUILoaded = false
>>>>>>> Stashed changes

    if m.stationGrid = invalid or m.playbackUI = invalid or m.toggleButton = invalid or m.stationLabel = invalid or m.songLabel = invalid or m.artistLabel = invalid or m.albumCoverPoster = invalid
        print "ERROR: ListenLiveView - Node not found"
        return
    end if
    if m.playbackUI = invalid or m.toggleButton = invalid or m.stationLabel = invalid or m.songLabel = invalid or m.artistLabel = invalid or m.albumCoverPoster = invalid
        print "ERROR: ListenLiveView - Playback UI nodes not found"
        m.playbackUI = invalid
    else
        m.isPlaybackUILoaded = true
    end if

<<<<<<< Updated upstream
    m.stations = [
        {title: "101.9 The Bull", url: "https://ice64.securenetsystems.net/KQBL", poster: "pkg:/images/bull.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBL.xml"},
        {title: "My 102.7", url: "https://ice9.securenetsystems.net/KZMG", poster: "pkg:/images/my.png", xmlUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KZMG.xml"},
        {title: "Bob FM 96.1", url: "https://ice64.securenetsystems.net/KSRV", poster: "pkg:/images/bob.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KSRV.xml"},
        {title: "Wild 101.1", url: "https://ice9.securenetsystems.net/KWYD", poster: "pkg:/images/wild.png", xmlUrl: "https://streamdb7web.securenetsystems.net/player_status_update/KWYD.xml"},
        {title: "IRock 99.1 FM", url: "https://ice64.securenetsystems.net/KQBLHD2", poster: "pkg:/images/irock.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2.xml"},
        {title: "Fox Sports 99.9", url: "https://ice64.securenetsystems.net/KSRVHD2", poster: "pkg:/images/fox.png", xmlUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2.xml"},
        {title: "101.5 Kool FM", url: "https://ice5.securenetsystems.net/KKOO", poster: "pkg:/images/kool.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KKOO.xml"},
        {title: "96.5 The Alternative", url: "https://ice9.securenetsystems.net/KQBLHD3", poster: "pkg:/images/alt.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3.xml"}
    ]

    m.currentStationIndex = -1

    content = CreateObject("roSGNode", "ContentNode")
    for each station in m.stations
        child = content.CreateChild("ContentNode")
        child.title = station.title
        child.hdPosterUrl = station.poster
        child.url = station.url
    end for
    m.stationGrid.content = content

    m.top.observeFieldScoped("selectedStationIndex", "onStationSelected")
    m.top.observeFieldScoped("keyEvent", "onKeyEvent")
    m.stationGrid.observeFieldScoped("itemFocused", "onItemFocused")

    m.playbackUI.visible = false
    m.stationGrid.visible = true
<<<<<<< Updated upstream
    m.stationLabel.visible = false
    m.songLabel.visible = false
    m.artistLabel.visible = false
    m.albumCoverPoster.visible = false
    m.toggleButton.visible = false
    m.top.callFunc("forceGridFocus", invalid)
    print "ListenLiveView: Init complete"
end sub

sub forceGridFocus()
    print "ListenLiveView: Forcing stationGrid focus"
    m.stationGrid.itemFocused = 0
    m.stationGrid.setFocus(true)
end sub
=======
    m.stationGrid.visible = true
=======
>>>>>>> Stashed changes
    print "ListenLiveView: Loading stationGrid content"
    LoadStationGridContent()
    print "ListenLiveView: stationGrid content loaded"

    print "ListenLiveView: Setting observers"
    m.stationGrid.ObserveField("rowItemSelected", "OnStationGridItemSelected")
    m.top.ObserveField("keyEvent", "onKeyEvent")
    m.top.ObserveField("selectedStationIndex", "onStationSelected")
    m.top.ObserveField("stations", "onStationsUpdated")
    if m.toggleButton <> invalid
        m.toggleButton.ObserveField("buttonSelected", "OnToggleButtonSelected")
    end if

    print "ListenLiveView: stationGrid initial state - focused item: "; m.stationGrid.rowItemFocused; ", hasFocus: "; m.stationGrid.hasFocus()
    print "ListenLiveView: stationGrid boundingRect: "; m.stationGrid.boundingRect()
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
    for i = 0 to 1 ' 2 rows
        row = content.CreateChild("ContentNode")
        row.AddFields({ HandlerConfigGrid: { name: "StationContentHandler" } })
        startIndex = i * 4
        endIndex = startIndex + 3
        if endIndex >= m.top.stations.Count()
            endIndex = m.top.stations.Count() - 1
        end if
        for j = startIndex to endIndex
            station = m.top.stations[j]
            child = row.CreateChild("ContentNode")
            child.title = station.title
            child.url = station.url
            child.HDPosterUrl = station.poster
            child.SDPosterUrl = station.poster
            child.streamFormat = station.format
            child.xmlUrl = station.xmlUrl
            print "ListenLiveView: Added station to grid: "; station.title
        end for
    end for
    m.stationGrid.content = content
    if m.top.ComponentController <> invalid
        m.top.ComponentController.CallFunc("show", { view: m.stationGrid })
    else
        print "WARNING: ComponentController not available, GridView may not display"
        m.stationGrid.SetFocus(true)
    end if
    print "ListenLiveView: stationGrid content loaded, row count: "; content.GetChildCount(); ", item count: "; content.GetChild(0).GetChildCount()
    print "ListenLiveView: stationGrid boundingRect: "; m.stationGrid.boundingRect()
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
        m.isPlaybackUILoaded = false
        return
    end if
    m.toggleButton.ObserveField("buttonSelected", "OnToggleButtonSelected")
    m.isPlaybackUILoaded = true
    print "ListenLiveView: playbackUI loaded"
End Sub

Sub OnStationGridItemSelected()
    selectedIndex = m.stationGrid.rowItemSelected[1]
    print "ListenLiveView: stationGrid rowItemSelected: "; selectedIndex; ", Focused: "; m.stationGrid.rowItemFocused[1]; ", Grid hasFocus: "; m.stationGrid.hasFocus()
    if selectedIndex >= 0 and selectedIndex < m.top.stations.Count()
        print "ListenLiveView: Setting selectedStationIndex to: "; selectedIndex
        m.top.selectedStationIndex = selectedIndex
    else
        print "ListenLiveView: Invalid station index: "; selectedIndex
    end if
End Sub

Sub OnToggleButtonSelected()
    print "ListenLiveView: toggleButton selected, notifying MainScene"
    m.top.toggleButtonPressed = true
End Sub

Sub onStationSelected()
    selectedIndex = m.top.selectedStationIndex
    print "ListenLiveView: onStationSelected triggered, selectedStationIndex: "; selectedIndex
>>>>>>> Stashed changes

sub onItemFocused()
    print "ListenLiveView: stationGrid itemFocused: "; m.stationGrid.itemFocused
end sub

sub onStationSelected()
    print "ListenLiveView: onStationSelected triggered, selectedStationIndex: "; m.top.selectedStationIndex
    index = m.top.selectedStationIndex
    if index >= 0 and index < m.stations.Count()
        m.playbackUI.visible = false
        m.playbackUI.visible = true
        m.stationGrid.visible = false
        m.stationLabel.text = m.stations[index].title
        m.stationLabel.visible = true
        print "ListenLiveView: Setting stationLabel text to: "; m.stationLabel.text
        m.songLabel.text = "Loading..."
        m.songLabel.visible = true
        print "ListenLiveView: Setting songLabel text to: "; m.songLabel.text
        m.artistLabel.text = "Loading..."
        m.artistLabel.visible = true
        print "ListenLiveView: Setting artistLabel text to: "; m.artistLabel.text
        m.albumCoverPoster.uri = m.stations[index].poster
        m.albumCoverPoster.visible = true
        print "ListenLiveView: Set albumCoverPoster uri to fallback: "; m.albumCoverPoster.uri
        m.toggleButton.visible = true

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

        m.playbackUI.callFunc("updateLayout", invalid)

<<<<<<< Updated upstream
        m.toggleButton.setFocus(true)

        scene = m.top.getScene()
        if scene <> invalid
            print "ListenLiveView: Hiding MainScene UI elements using FindNode (excluding appLogo)"
            appLogo = scene.FindNode("appLogo")
            tabGroup = scene.FindNode("tabGroup")
            tabContainer = scene.FindNode("tabContainer")
            contentStack = scene.FindNode("contentStack")
            if appLogo <> invalid
                appLogo.visible = true
                print "ListenLiveView: appLogo visible: "; appLogo.visible
            else
                print "ListenLiveView: appLogo not found"
            end if
            if tabGroup <> invalid
                tabGroup.visible = false
                print "ListenLiveView: tabGroup visible: "; tabGroup.visible
            else
                print "ListenLiveView: tabGroup not found"
=======
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
        print "ListenLiveView: Keeping dizzying background visible"
        background.visible = true
    end if

    print "ListenLiveView: Set albumCoverPoster uri to: "; m.top.stations[selectedIndex].poster
    print "ListenLiveView: playbackUI visible: "; m.playbackUI.visible
    m.top.getScene().CallFunc("ShowPlaybackUI", {})
    m.toggleButton.SetFocus(true)
    print "ListenLiveView: Scene visibility: "; m.top.getScene().visible
    print "ListenLiveView: Scene focus: "; m.top.getScene().hasFocus()
    print "ListenLiveView: toggleButton focus: "; m.toggleButton.hasFocus()

    m.metaTask = CreateObject("roSGNode", "FetchMetaTask")
    m.metaTask.xmlUrl = m.top.stations[selectedIndex].xmlUrl
    m.metaTask.ObserveField("artist", "OnArtistFetched")
    m.metaTask.ObserveField("songTitle", "OnSongTitleFetched")
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
                tabGroup.SetFocus(true)
                listenLiveTab = tabGroup.FindNode("listenLiveTab")
                if listenLiveTab <> invalid
                    listenLiveTab.SetFocus(true)
                end if
>>>>>>> Stashed changes
            end if
            if tabContainer <> invalid
                tabContainer.visible = false
                print "ListenLiveView: tabContainer visible: "; tabContainer.visible
            else
                print "ListenLiveView: tabContainer not found"
            end if
            if contentStack <> invalid
                contentStack.visible = true
                print "ListenLiveView: contentStack visible: "; contentStack.visible
            end if
            print "ListenLiveView: Keeping background visible"
            print "ListenLiveView: Scene visibility: "; scene.visible
            print "ListenLiveView: Scene focus: "; scene.hasFocus()
            print "ListenLiveView: toggleButton focus: "; m.toggleButton.hasFocus()
        else
            print "ListenLiveView: Scene reference invalid, cannot hide MainScene UI elements"
        end if

        if m.fetchMetaTask <> invalid
            m.fetchMetaTask.control = "STOP"
            m.fetchMetaTask.unobserveField("artist")
            m.fetchMetaTask = invalid
        end if
        m.fetchMetaTask = CreateObject("roSGNode", "FetchMetaTask")
        m.fetchMetaTask.xmlUrl = m.stations[index].xmlUrl
        m.fetchMetaTask.observeField("artist", "onMetaFetched")
        m.fetchMetaTask.control = "RUN"
        print "ListenLiveView: FetchMetaTask started for URL: "; m.fetchMetaTask.xmlUrl

        m.currentStationIndex = index
    else
        print "ListenLiveView: Invalid station index: "; index
    end if
end sub

sub onMetaFetched()
    if m.fetchMetaTask = invalid
        print "ListenLiveView: FetchMetaTask invalid, skipping metadata update"
        return
    end if
    artist = m.fetchMetaTask.artist
    songTitle = m.fetchMetaTask.songTitle
    if artist <> invalid and artist <> ""
        m.artistLabel.text = artist
        print "ListenLiveView: Artist fetched: "; artist
        print "ListenLiveView: Updated artistLabel text to: "; m.artistLabel.text
    end if
    if songTitle <> invalid and songTitle <> ""
        m.songLabel.text = songTitle
        print "ListenLiveView: Song title fetched: "; songTitle
        print "ListenLiveView: Updated songLabel text to: "; m.songLabel.text
    end if
    m.fetchMetaTask.unobserveField("artist")
    m.fetchMetaTask = invalid
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    print "ListenLiveView: Key event - Key: "; key; ", Press: "; press
    if not press
        return false
    end if
    if key = "OK" and m.stationGrid.hasFocus() and m.stationGrid.isInFocusChain()
        focusedIndex = m.stationGrid.itemFocused
        print "ListenLiveView: OK key pressed, selecting station at index: "; focusedIndex
        if focusedIndex >= 0 and focusedIndex < m.stations.Count()
            print "ListenLiveView: Setting selectedStationIndex to: "; focusedIndex
            m.top.selectedStationIndex = focusedIndex
            return true
        else
            print "ListenLiveView: Invalid itemFocused, ignoring OK"
            return true
        end if
    else if key = "OK"
        print "ListenLiveView: OK pressed but stationGrid not focused, restoring focus"
        m.top.callFunc("forceGridFocus", invalid)
        return true
    else if key = "right" or key = "up" or key = "down"
        focusedIndex = m.stationGrid.itemFocused
        print "ListenLiveView: Navigation in stationGrid, key: "; key; ", current index: "; focusedIndex
        return false
    else if key = "back" and m.playbackUI.visible
        print "ListenLiveView: Back key pressed in playbackUI, returning to tabGroup"
        m.playbackUI.visible = false
        m.stationGrid.visible = true
        m.stationLabel.visible = false
        m.songLabel.visible = false
        m.artistLabel.visible = false
        m.albumCoverPoster.visible = false
        m.toggleButton.visible = false
        m.currentStationIndex = -1
        m.stationGrid.itemFocused = 0
        scene = m.top.getScene()
        if scene <> invalid
            tabGroup = scene.FindNode("tabGroup")
            tabContainer = scene.FindNode("tabContainer")
            contentStack = scene.FindNode("contentStack")
            background = scene.FindNode("background")
            appLogo = scene.FindNode("appLogo")
            listenLiveTab = scene.FindNode("listenLiveTab")
            if tabGroup <> invalid
                tabGroup.visible = true
                tabGroup.setFocus(true)
                print "ListenLiveView: tabGroup visible: "; tabGroup.visible
            end if
            if tabContainer <> invalid
                tabContainer.visible = true
                print "ListenLiveView: tabContainer visible: "; tabContainer.visible
            end if
            if contentStack <> invalid
                contentStack.visible = true
                print "ListenLiveView: contentStack visible: "; contentStack.visible
            end if
            if background <> invalid
                background.visible = true
                print "ListenLiveView: background visible: "; background.visible
            end if
<<<<<<< Updated upstream
<<<<<<< Updated upstream
            if appLogo <> invalid
                appLogo.visible = true
                print "ListenLiveView: appLogo visible: "; appLogo.visible
            end if
            if listenLiveTab <> invalid
                listenLiveTab.setFocus(true)
                print "ListenLiveView: listenLiveTab focus: "; listenLiveTab.hasFocus()
            end if
            print "ListenLiveView: tabGroup focus: "; tabGroup.hasFocus()
=======
=======
>>>>>>> Stashed changes
            return true
        end if
    else if m.stationGrid.visible and m.stationGrid.hasFocus()
        if key = "left"
            focusedIndex = m.stationGrid.rowItemFocused[1]
            print "ListenLiveView: Left key pressed in stationGrid, focused index: "; focusedIndex
            if focusedIndex = 0
                print "ListenLiveView: In leftmost column, moving focus to tabGroup"
                tabGroup = m.top.getScene().FindNode("tabGroup")
                if tabGroup <> invalid
                    tabGroup.SetFocus(true)
                    listenLiveTab = tabGroup.FindNode("listenLiveTab")
                    if listenLiveTab <> invalid
                        listenLiveTab.SetFocus(true)
                    end if
                end if
                return true
            end if
        else if key = "OK"
            focusedIndex = m.stationGrid.rowItemFocused[1]
            print "ListenLiveView: OK key pressed in stationGrid, index: "; focusedIndex
            if m.stationGrid.hasFocus()
                m.stationGrid.rowItemSelected = [0, focusedIndex]
                return true
            end if
>>>>>>> Stashed changes
        end if
        return true
    end if
    return false
end function