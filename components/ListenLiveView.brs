sub init()
    print "ListenLiveView: Entering init"
    m.stationGrid = m.top.FindNode("stationGrid")
    m.playbackUI = m.top.FindNode("playbackUI")
    m.toggleButton = m.top.FindNode("toggleButton")
    m.stationLabel = m.top.FindNode("stationLabel")
    m.songLabel = m.top.FindNode("songLabel")
    m.artistLabel = m.top.FindNode("artistLabel")
    m.albumCoverPoster = m.top.FindNode("albumCoverPoster")

    if m.stationGrid = invalid or m.playbackUI = invalid or m.toggleButton = invalid or m.stationLabel = invalid or m.songLabel = invalid or m.artistLabel = invalid or m.albumCoverPoster = invalid
        print "ERROR: ListenLiveView - Node not found"
        return
    end if

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

    m.registry = CreateObject("roRegistrySection", "ListenBoisePrefs")
    lastPlayedIndex = m.registry.Read("lastPlayedStationIndex")
    if lastPlayedIndex = invalid or lastPlayedIndex = "" or lastPlayedIndex = "-1"
        m.currentStationIndex = -1
        m.stationGrid.itemFocused = 0
    else
        m.currentStationIndex = lastPlayedIndex.ToInt()
        if m.currentStationIndex >= 0 and m.currentStationIndex < m.stations.Count()
            m.stationGrid.itemFocused = m.currentStationIndex
        else
            m.currentStationIndex = -1
            m.stationGrid.itemFocused = 0
        end if
    end if

    content = CreateObject("roSGNode", "ContentNode")
    for each station in m.stations
        child = content.CreateChild("ContentNode")
        child.title = station.title
        child.hdPosterUrl = station.poster
        child.url = station.url
    end for
    m.stationGrid.content = content

    m.top.observeFieldScoped("selectedStationIndex", "onStationSelected")
    m.stationGrid.observeFieldScoped("itemSelected", "onItemSelected")
    m.stationGrid.observeFieldScoped("itemFocused", "onItemFocused")
    m.top.observeFieldScoped("keyEvent", "onKeyEvent")

    m.playbackUI.visible = false
    m.stationGrid.visible = true
    m.stationLabel.visible = false
    m.songLabel.visible = false
    m.artistLabel.visible = false
    m.albumCoverPoster.visible = false
    m.toggleButton.visible = false
    print "ListenLiveView: Init complete"
end sub

sub onItemSelected()
    selectedIndex = m.stationGrid.itemSelected
    print "ListenLiveView: stationGrid itemSelected: "; selectedIndex
    if selectedIndex >= 0 and selectedIndex < m.stations.Count()
        m.top.selectedStationIndex = selectedIndex
    else
        print "ListenLiveView: Invalid itemSelected: "; selectedIndex
    end if
end sub

sub onItemFocused()
    print "ListenLiveView: stationGrid itemFocused: "; m.stationGrid.itemFocused
end sub

sub onStationSelected()
    index = m.top.selectedStationIndex
    print "ListenLiveView: onStationSelected triggered, selectedStationIndex: "; index
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
        m.registry.Write("lastPlayedStationIndex", index.ToStr())
        m.registry.Flush()
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
    if key = "play" and m.playbackUI.visible
        print "ListenLiveView: Play key pressed in playbackUI"
        m.top.getScene().callFunc("togglePlayback", {})
        return true
    else if key = "OK" and m.playbackUI.visible
        print "ListenLiveView: OK key pressed in playbackUI, no action"
        return true
    else if key = "right" or key = "up" or key = "down" or key = "left"
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
        m.registry.Write("lastPlayedStationIndex", "-1")
        m.registry.Flush()
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
            if appLogo <> invalid
                appLogo.visible = true
                print "ListenLiveView: appLogo visible: "; appLogo.visible
            end if
            if listenLiveTab <> invalid
                listenLiveTab.setFocus(true)
                print "ListenLiveView: listenLiveTab focus: "; listenLiveTab.hasFocus()
            end if
            print "ListenLiveView: tabGroup focus: "; tabGroup.hasFocus()
        end if
        return true
    end if
    return false
end function