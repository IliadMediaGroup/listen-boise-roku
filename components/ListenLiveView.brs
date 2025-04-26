sub init()
    m.stationGrid = m.top.FindNode("stationGrid")
    m.playbackUI = m.top.FindNode("playbackUI")
    m.albumCoverPoster = m.top.FindNode("albumCoverPoster")
    m.toggleButton = m.top.FindNode("toggleButton")
    m.artistLabel = m.top.FindNode("artistLabel")
    m.stationLabel = m.top.FindNode("stationLabel")

    if m.stationGrid = invalid
        print "ERROR: stationGrid not found"
    end if
    if m.playbackUI = invalid
        print "ERROR: playbackUI not found"
    end if
    if m.albumCoverPoster = invalid
        print "ERROR: albumCoverPoster not found"
    end if
    if m.toggleButton = invalid
        print "ERROR: toggleButton not found"
    end if
    if m.artistLabel = invalid
        print "ERROR: artistLabel not found"
    end if
    if m.stationLabel = invalid
        print "ERROR: stationLabel not found"
    end if

    if m.stationGrid = invalid or m.playbackUI = invalid or m.albumCoverPoster = invalid or m.toggleButton = invalid or m.artistLabel = invalid or m.stationLabel = invalid
        print "ERROR: ListenLiveView - Node not found, initialization aborted"
        return
    end if

    m.stations = [
        {poster: "pkg:/images/bull.png", title: "101.9 The Bull", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBL.xml"},
        {poster: "pkg:/images/my.png", title: "My 102.7", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KZMG.xml"},
        {poster: "pkg:/images/bob.png", title: "Bob FM 96.1", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KSRV.xml"},
        {poster: "pkg:/images/wild.jpg", title: "Wild 101.1", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KWYD.xml"},
        {poster: "pkg:/images/irock.png", title: "I-Rock 99.1 FM", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2.xml"},
        {poster: "pkg:/images/fox.png", title: "Fox Sports 99.9", xmlUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2.xml"},
        {poster: "pkg:/images/kool.png", title: "101.5 Kool FM", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KKOO.xml"},
        {poster: "pkg:/images/alt.png", title: "96.5 The Alternative", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3.xml"}
    ]

    content = CreateObject("roSGNode", "ContentNode")
    for each station in m.stations
        child = content.CreateChild("ContentNode")
        child.title = station.title
        child.HDPosterUrl = station.poster
        print "ListenLiveView: Added station "; content.GetChildCount() - 1; ": "; station.title; ", image path: "; station.poster
    end for

    m.stationGrid.content = content
    print "ListenLiveView: Total stations loaded: "; content.GetChildCount()

    m.toggleButton.observeFieldScoped("buttonSelected", "onToggleButton")

    print "ListenLiveView: stationGrid focus: "; m.stationGrid.hasFocus()
end sub

sub onStationSelected()
    print "ListenLiveView: onStationSelected triggered, selectedStationIndex: "; m.top.selectedStationIndex
    index = m.top.selectedStationIndex
    if index >= 0 and index < m.stations.Count()
        m.playbackUI.visible = false
        m.playbackUI.visible = true
        m.stationGrid.visible = false
        m.stationLabel.text = m.stations[index].title
        print "ListenLiveView: Setting stationLabel text to: "; m.stationLabel.text
        m.artistLabel.text = "Artist: Loading..."
        print "ListenLiveView: Setting artistLabel text to: "; m.artistLabel.text
        m.albumCoverPoster.uri = m.stations[index].poster
        print "ListenLiveView: Set albumCoverPoster uri to fallback: "; m.albumCoverPoster.uri

        print "ListenLiveView: playbackUI visible: "; m.playbackUI.visible
        print "ListenLiveView: albumCoverPoster visible: "; m.albumCoverPoster.visible
        print "ListenLiveView: toggleButton visible: "; m.toggleButton.visible
        print "ListenLiveView: artistLabel visible: "; m.artistLabel.visible
        print "ListenLiveView: stationLabel visible: "; m.stationLabel.visible

        print "ListenLiveView: top boundingRect: "; m.top.boundingRect()
        print "ListenLiveView: playbackUI boundingRect: "; m.playbackUI.boundingRect()
        print "ListenLiveView: albumCoverPoster boundingRect: "; m.albumCoverPoster.boundingRect()
        print "ListenLiveView: toggleButton boundingRect: "; m.toggleButton.boundingRect()
        print "ListenLiveView: artistLabel boundingRect: "; m.artistLabel.boundingRect()
        print "ListenLiveView: stationLabel boundingRect: "; m.stationLabel.boundingRect()

        m.toggleButton.setFocus(true)

        scene = m.top.getScene()
        if scene <> invalid
            print "ListenLiveView: Hiding MainScene UI elements using FindNode"
            appLogo = scene.FindNode("appLogo")
            tabGroup = scene.FindNode("tabGroup")
            tabContainer = scene.FindNode("tabContainer")
            contentStack = scene.FindNode("contentStack")
            background = scene.FindNode("background")
            if appLogo <> invalid
                appLogo.visible = false
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
                contentStack.visible = false
                print "ListenLiveView: contentStack visible: "; contentStack.visible
            end if
            if background <> invalid
                background.visible = false
                print "ListenLiveView: background visible: "; background.visible
            else
                print "ListenLiveView: background not found"
            end if
        else
            print "ListenLiveView: Scene reference invalid, cannot hide MainScene UI elements"
        end if

        m.fetchMetaTask = CreateObject("roSGNode", "FetchMetaTask")
        m.fetchMetaTask.xmlUrl = m.stations[index].xmlUrl
        m.fetchMetaTask.observeField("artist", "onMetaFetched")
        m.fetchMetaTask.observeField("cover", "onCoverFetched")
        m.fetchMetaTask.control = "RUN"
        print "ListenLiveView: FetchMetaTask started for URL: "; m.fetchMetaTask.xmlUrl

        m.currentStationIndex = index
    else
        print "ListenLiveView: Invalid station index: "; index
    end if
end sub

sub onMetaFetched()
    artist = m.fetchMetaTask.artist
    print "ListenLiveView: Artist fetched: "; artist
    m.artistLabel.text = "Artist: " + artist
    print "ListenLiveView: Updated artistLabel text to: "; m.artistLabel.text
end sub

sub onCoverFetched()
    cover = m.fetchMetaTask.cover
    print "ListenLiveView: Cover fetched: "; cover
    if cover <> "" and cover <> "invalid" and cover <> "none"
        m.albumCoverPoster.uri = cover
        print "ListenLiveView: Set albumCoverPoster uri to: "; cover
    else
        print "ListenLiveView: No valid cover URL found, keeping fallback image"
    end if
    m.fetchMetaTask.unobserveField("artist")
    m.fetchMetaTask.unobserveField("cover")
    m.fetchMetaTask = invalid
end sub

sub onToggleButton()
    print "ListenLiveView: Toggle button pressed"
    scene = m.top.getScene()
    if scene <> invalid and scene.isFuncDefined("togglePlayback")
        scene.callFunc("togglePlayback")
    else
        print "ListenLiveView: Cannot call togglePlayback - scene invalid or function not defined"
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    print "ListenLiveView: Key event - Key: "; key; ", Press: "; press
    if not press
        return false
    end if

    if m.playbackUI.visible
        if key = "back"
            print "ListenLiveView: Back key pressed in playbackUI, returning to stationGrid"
            m.playbackUI.visible = false
            m.stationGrid.visible = true
            scene = m.top.getScene()
            if scene <> invalid
                appLogo = scene.FindNode("appLogo")
                tabGroup = scene.FindNode("tabGroup")
                tabContainer = scene.FindNode("tabContainer")
                contentStack = scene.FindNode("contentStack")
                background = scene.FindNode("background")
                listenLiveTab = scene.FindNode("listenLiveTab")
                if appLogo <> invalid
                    appLogo.visible = true
                    print "ListenLiveView: appLogo visible: "; appLogo.visible
                end if
                if tabGroup <> invalid
                    tabGroup.visible = true
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
                if tabGroup <> invalid and listenLiveTab <> invalid
                    tabGroup.setFocus(true)
                    listenLiveTab.setFocus(true)
                    print "ListenLiveView: tabGroup focus: "; tabGroup.hasFocus()
                    print "ListenLiveView: listenLiveTab focus: "; listenLiveTab.hasFocus()
                else
                    print "ListenLiveView: Failed to set focus - tabGroup or listenLiveTab not found"
                end if
            else
                print "ListenLiveView: Scene reference invalid, cannot restore UI"
            end if
            m.stationGrid.setFocus(true)
            print "ListenLiveView: stationGrid focus: "; m.stationGrid.hasFocus()
            return true
        else if key = "left" or key = "right" or key = "up" or key = "down"
            print "ListenLiveView: Arrow key pressed in playbackUI, consuming event"
            return true
        end if
        return false
    end if

    if m.stationGrid.hasFocus() and key = "OK"
        print "ListenLiveView: OK key pressed, selecting station at index: "; m.stationGrid.itemFocused
        m.top.selectedStationIndex = m.stationGrid.itemFocused
        return true
    end if

    return false
end function