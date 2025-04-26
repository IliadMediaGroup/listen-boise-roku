sub init()
    print "ListenLiveView: Entering Init"
    print "ListenLiveView: Deployed version 9"

    m.stationGrid = m.top.FindNode("stationGrid")
    m.playbackUI = m.top.FindNode("playbackUI")
    m.stationLabel = m.top.FindNode("stationLabel")
    m.toggleButton = m.top.FindNode("toggleButton")
    m.artistLabel = m.top.FindNode("artistLabel")

    if m.stationGrid = invalid or m.playbackUI = invalid or m.stationLabel = invalid or m.toggleButton = invalid or m.artistLabel = invalid
        print "ERROR: ListenLiveView - Node not found"
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
    print "ListenLiveView: Init complete"
end sub

sub onStationSelected()
    print "ListenLiveView: onStationSelected triggered, selectedStationIndex: "; m.top.selectedStationIndex
    index = m.top.selectedStationIndex
    if index >= 0 and index < m.stations.Count()
        ' Show the playback UI
        m.playbackUI.visible = true
        m.stationGrid.visible = false
        m.stationLabel.text = m.stations[index].title
        print "ListenLiveView: Setting stationLabel text to: "; m.stationLabel.text
        m.artistLabel.text = "Artist: Loading..."
        print "ListenLiveView: Setting artistLabel text to: "; m.artistLabel.text

        ' Hide MainScene UI elements
        scene = m.top.getScene()
        if scene <> invalid
            appLogo = scene.FindNode("appLogo")
            tabGroup = scene.FindNode("tabGroup")
            contentStack = scene.FindNode("contentStack")
            if appLogo <> invalid and tabGroup <> invalid and contentStack <> invalid
                appLogo.visible = false
                tabGroup.visible = false
                contentStack.visible = false
            else
                print "ListenLiveView: Failed to hide MainScene UI elements"
            end if
        end if

        ' Start the task to fetch the metadata
        m.fetchMetaTask = CreateObject("roSGNode", "FetchMetaTask")
        m.fetchMetaTask.xmlUrl = m.stations[index].xmlUrl
        m.fetchMetaTask.observeField("artist", "onMetaFetched")
        m.fetchMetaTask.control = "RUN"
    end if
end sub

sub onMetaFetched()
    artist = m.fetchMetaTask.artist
    print "ListenLiveView: Artist fetched: "; artist
    m.artistLabel.text = "Artist: " + artist
    print "ListenLiveView: Updated artistLabel text to: "; m.artistLabel.text
    ' Clean up the task
    m.fetchMetaTask.unobserveField("artist")
    m.fetchMetaTask = invalid
end sub

sub onToggleButton()
    print "ListenLiveView: Toggle button pressed in playbackUI"
    ' Notify MainScene to toggle playback
    m.top.getScene().callFunc("togglePlayback", {})
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
            m.stationGrid.setFocus(true)
            ' Directly restore MainScene UI elements
            scene = m.top.getScene()
            if scene <> invalid
                appLogo = scene.FindNode("appLogo")
                tabGroup = scene.FindNode("tabGroup")
                contentStack = scene.FindNode("contentStack")
                listenLiveTab = scene.FindNode("listenLiveTab")
                if appLogo <> invalid and tabGroup <> invalid and contentStack <> invalid and listenLiveTab <> invalid
                    print "ListenLiveView: Restoring MainScene UI elements"
                    appLogo.visible = true
                    tabGroup.visible = true
                    contentStack.visible = true
                    tabGroup.setFocus(true)
                    if tabGroup.focusedChild = invalid
                        listenLiveTab.setFocus(true)
                    end if
                else
                    print "ListenLiveView: Failed to restore UI - one or more elements not found"
                end if
            else
                print "ListenLiveView: Scene reference invalid, cannot restore UI"
            end if
            return true
        else if key = "up" or key = "down" or key = "left" or key = "right"
            print "ListenLiveView: Directional key pressed in playbackUI, keeping focus on toggleButton"
            m.toggleButton.setFocus(true)
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