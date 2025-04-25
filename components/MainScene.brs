' MainScene.brs
Sub Init()
    print "MainScene: Entering Init"
    m.audioPlayer = m.top.FindNode("audioPlayer")
    m.tabGroup = m.top.FindNode("tabGroup")
    m.listenLiveTab = m.top.FindNode("listenLiveTab")
    m.newsTab = m.top.FindNode("newsTab")
    m.podcastsTab = m.top.FindNode("podcastsTab")
    m.toggleButton = m.top.FindNode("toggleButton")
    m.contentStack = m.top.FindNode("contentStack")
    m.listenLiveView = m.top.FindNode("listenLiveView")
    m.newsView = m.top.FindNode("newsView")
    m.podcastsView = m.top.FindNode("podcastsView")

    if m.audioPlayer = invalid or m.tabGroup = invalid or m.listenLiveTab = invalid or m.newsTab = invalid or m.podcastsTab = invalid or m.toggleButton = invalid or m.contentStack = invalid or m.listenLiveView = invalid or m.newsView = invalid or m.podcastsView = invalid
        print "ERROR: Node not found"
        return
    end if

    print "MainScene: Setting observers"
    m.listenLiveTab.observeFieldScoped("buttonSelected", "OnTabSelected")
    m.newsTab.observeFieldScoped("buttonSelected", "OnTabSelected")
    m.podcastsTab.observeFieldScoped("buttonSelected", "OnTabSelected")
    m.toggleButton.observeFieldScoped("buttonSelected", "OnToggleButton")
    m.audioPlayer.observeFieldScoped("state", "OnAudioStateChange")
    m.top.observeFieldScoped("keyEvent", "OnKeyEvent")
    m.listenLiveView.observeFieldScoped("selectedStationIndex", "OnStationSelected")

    m.stations = [
        {url: "https://ice64.securenetsystems.net/KQBL", name: "101.9 The Bull", format: "aac"},
        {url: "https://ice9.securenetsystems.net/KZMG", name: "My 102.7", format: "aac"},
        {url: "https://ice64.securenetsystems.net/KSRV", name: "Bob FM 96.1", format: "aac"},
        {url: "https://ice9.securenetsystems.net/KWYD", name: "Wild 101.1", format: "aac"},
        {url: "https://ice64.securenetsystems.net/KQBLHD2", name: "I-Rock 99.1 FM", format: "aac"},
        {url: "https://ice64.securenetsystems.net/KSRVHD2", name: "Fox Sports 99.9", format: "aac"},
        {url: "https://ice5.securenetsystems.net/KKOO", name: "101.5 Kool FM", format: "aac"},
        {url: "https://ice9.securenetsystems.net/KQBLHD3", name: "96.5 The Alternative", format: "aac"}
    ]

    m.registry = CreateObject("roRegistrySection", "ListenBoisePrefs")
    lastPlayedIndex = m.registry.Read("lastPlayedStationIndex")
    if lastPlayedIndex = invalid or lastPlayedIndex = ""
        m.currentStationIndex = -1
    else
        m.currentStationIndex = lastPlayedIndex.ToInt()
        if m.currentStationIndex < 0 or m.currentStationIndex >= m.stations.Count()
            m.currentStationIndex = -1
        end if
    end if
    m.isPlaying = false
    m.justEnteredStationGrid = false

    print "MainScene: Initial view set to listenLiveView"
    
    m.tabGroup.setFocus(true)
    print "MainScene: Initial focus set to tabGroup"
    print "MainScene: scene focus: "; m.top.hasFocus()
    focusedChildId = "none"
    if m.tabGroup.focusedChild <> invalid
        focusedChildId = m.tabGroup.focusedChild.id
    end if
    print "MainScene: tabGroup focus: "; m.tabGroup.hasFocus(); ", focused button: "; focusedChildId
    print "MainScene: listenLiveTab focus: "; m.listenLiveTab.hasFocus()
    print "MainScene: newsTab focus: "; m.newsTab.hasFocus()
    print "MainScene: podcastsTab focus: "; m.podcastsTab.hasFocus()
    print "MainScene: Init complete"
End Sub

Sub OnTabSelected()
    print "MainScene: Tab selected"
    print "MainScene: listenLiveTab focus: "; m.listenLiveTab.hasFocus()
    print "MainScene: newsTab focus: "; m.newsTab.hasFocus()
    print "MainScene: podcastsTab focus: "; m.podcastsTab.hasFocus()
    if m.listenLiveTab.hasFocus()
        print "MainScene: Switching to listenLiveView"
        m.listenLiveView.visible = true
        m.newsView.visible = false
        m.podcastsView.visible = false
        m.top.FindNode("listenLiveView").FindNode("stationGrid").setFocus(true)
        m.justEnteredStationGrid = false
    else if m.newsTab.hasFocus()
        print "MainScene: Switching to newsView"
        m.listenLiveView.visible = false
        m.newsView.visible = true
        m.podcastsView.visible = false
        m.top.FindNode("newsView").setFocus(true)
    else if m.podcastsTab.hasFocus()
        print "MainScene: Switching to podcastsView"
        m.listenLiveView.visible = false
        m.newsView.visible = false
        m.podcastsView.visible = true
        m.top.FindNode("podcastsView").setFocus(true)
    end if
    print "MainScene: Current view visibility - listenLiveView: "; m.listenLiveView.visible; ", newsView: "; m.newsView.visible; ", podcastsView: "; m.podcastsView.visible
    focusedChildId = "none"
    if m.tabGroup.focusedChild <> invalid
        focusedChildId = m.tabGroup.focusedChild.id
    end if
    print "MainScene: Post-tab-switch focus - tabGroup: "; m.tabGroup.hasFocus(); ", focused button: "; focusedChildId
    if m.listenLiveView.visible
        print "MainScene: stationGrid focus: "; m.top.FindNode("listenLiveView").FindNode("stationGrid").hasFocus()
    else
        print "MainScene: stationGrid focus: N/A"
    end if
End Sub

Sub OnStationSelected()
    selectedIndex = m.listenLiveView.selectedStationIndex
    print "MainScene: Station selected at index: "; selectedIndex
    if m.isPlaying and selectedIndex = m.currentStationIndex
        print "MainScene: Station already playing, stopping playback"
        m.audioPlayer.control = "stop"
        m.audioPlayer.content = invalid
        m.isPlaying = false
        return
    end if
    m.currentStationIndex = selectedIndex
    m.registry.Write("lastPlayedStationIndex", m.currentStationIndex.ToStr())
    m.registry.Flush()
    station = m.stations[selectedIndex]
    content = CreateObject("roSGNode", "ContentNode")
    content.url = station.url
    content.streamFormat = station.format
    content.streamQualities = ["SD"]
    content.streamBitrates = [128]
    content.addHeader("User-Agent", "Roku")
    content.addHeader("Accept", "audio/aac")
    content.addHeader("Connection", "keep-alive")
    if m.audioPlayer.state = "playing" or m.audioPlayer.state = "buffering"
        m.audioPlayer.control = "stop"
        m.audioPlayer.content = invalid
    end if
    m.audioPlayer.content = content
    m.audioPlayer.control = "play"
    m.isPlaying = true
End Sub

Sub OnToggleButton()
    print "MainScene: Toggle button pressed"
    print "MainScene: Current station index: "; m.currentStationIndex
    print "MainScene: Is playing: "; m.isPlaying
    if m.currentStationIndex = -1
        print "MainScene: No station selected, defaulting to My 102.7 (index 1)"
        m.currentStationIndex = 1
        m.registry.Write("lastPlayedStationIndex", m.currentStationIndex.ToStr())
        m.registry.Flush()
        station = m.stations[m.currentStationIndex]
        content = CreateObject("roSGNode", "ContentNode")
        content.url = station.url
        content.streamFormat = station.format
        content.streamQualities = ["SD"]
        content.streamBitrates = [128]
        content.addHeader("User-Agent", "Roku")
        content.addHeader("Accept", "audio/aac")
        content.addHeader("Connection", "keep-alive")
        if m.audioPlayer.state = "playing" or m.audioPlayer.state = "buffering"
            m.audioPlayer.control = "stop"
            m.audioPlayer.content = invalid
        end if
        m.audioPlayer.content = content
        m.audioPlayer.control = "play"
        m.isPlaying = true
        return
    end if
    if m.isPlaying
        print "MainScene: Stopping playback"
        m.audioPlayer.control = "stop"
        m.audioPlayer.content = invalid
        m.isPlaying = false
    else
        print "MainScene: Resuming playback for station index: "; m.currentStationIndex
        station = m.stations[m.currentStationIndex]
        content = CreateObject("roSGNode", "ContentNode")
        content.url = station.url
        content.streamFormat = station.format
        content.streamQualities = ["SD"]
        content.streamBitrates = [128]
        content.addHeader("User-Agent", "Roku")
        content.addHeader("Accept", "audio/aac")
        content.addHeader("Connection", "keep-alive")
        if m.audioPlayer.state = "playing" or m.audioPlayer.state = "buffering"
            m.audioPlayer.control = "stop"
            m.audioPlayer.content = invalid
        end if
        m.audioPlayer.content = content
        m.audioPlayer.control = "play"
        m.isPlaying = true
    end if
End Sub

Sub OnAudioStateChange()
    print "MainScene: Audio state changed to: "; m.audioPlayer.state
    if m.audioPlayer.state = "error"
        errorCode = m.audioPlayer.errorCode
        errorMsg = m.audioPlayer.errorMsg
        print "MainScene: Audio error - Code: "; errorCode; ", Message: "; errorMsg
        m.isPlaying = false
    else if m.audioPlayer.state = "playing"
        m.isPlaying = true
    else if m.audioPlayer.state = "stopped"
        m.isPlaying = false
    end if
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    print "MainScene: Key event - Key: "; key; ", Press: "; press

    ' Handle play/pause globally at the top
    if press and key = "play"
        print "MainScene: Remote Play/Pause key pressed (global)"
        OnToggleButton()
        return true
    end if

    if not press
        return false
    end if

    focusedChildId = "none"
    if m.tabGroup.focusedChild <> invalid
        focusedChildId = m.tabGroup.focusedChild.id
    end if
    print "MainScene: Current focus - scene: "; m.top.hasFocus(); ", tabGroup: "; m.tabGroup.hasFocus(); ", focused button: "; focusedChildId
    print "MainScene: Current view visibility - listenLiveView: "; m.listenLiveView.visible; ", newsView: "; m.newsView.visible; ", podcastsView: "; m.podcastsView.visible
    if m.listenLiveView.visible
        print "MainScene: stationGrid focus: "; m.top.FindNode("listenLiveView").FindNode("stationGrid").hasFocus()
    else
        print "MainScene: stationGrid focus: N/A"
    end if

    ' Check if tabGroup or one of its children has focus
    isTabGroupFocused = m.tabGroup.hasFocus() or m.tabGroup.focusedChild <> invalid
    isStationGridFocused = m.listenLiveView.visible and m.top.FindNode("listenLiveView").FindNode("stationGrid").hasFocus()

    if not isTabGroupFocused and not isStationGridFocused
        print "MainScene: No component has focus, forcing focus to tabGroup"
        m.tabGroup.setFocus(true)
        ' Ensure the child button gets focus
        if m.tabGroup.focusedChild = invalid
            m.listenLiveTab.setFocus(true)
        end if
        m.justEnteredStationGrid = false
        return true
    end if

    if key = "back"
        print "MainScene: Back key pressed, returning to main menu"
        m.listenLiveView.visible = true
        m.newsView.visible = false
        m.podcastsView.visible = false
        m.tabGroup.setFocus(true)
        ' Ensure the child button gets focus
        if m.tabGroup.focusedChild = invalid
            m.listenLiveTab.setFocus(true)
        end if
        m.justEnteredStationGrid = false
        return true
    end if

    if isTabGroupFocused
        if key = "up" or key = "down"
            print "MainScene: Up/Down key pressed on tabGroup, handled by ButtonGroup"
            return false
        else if key = "right"
            print "MainScene: Right key pressed on tabGroup, moving focus to media pane"
            if m.listenLiveView.visible
                print "MainScene: Moving focus to stationGrid in listenLiveView"
                stationGrid = m.top.FindNode("listenLiveView").FindNode("stationGrid")
                stationGrid.setFocus(true)
                ' Move focus to the next item in the grid
                currentIndex = stationGrid.itemFocused
                nextIndex = currentIndex + 1
                if nextIndex < stationGrid.content.getChildCount()
                    print "MainScene: Advancing focus in stationGrid from index "; currentIndex; " to "; nextIndex
                    stationGrid.itemFocused = nextIndex
                end if
                m.justEnteredStationGrid = true
            else if m.newsView.visible
                print "MainScene: Moving focus to newsView"
                m.top.FindNode("newsView").setFocus(true)
            else if m.podcastsView.visible
                print "MainScene: Moving focus to podcastsView"
                m.top.FindNode("podcastsView").setFocus(true)
            end if
            return true
        else if key = "left"
            print "MainScene: Left key pressed on tabGroup, no action (leftmost component)"
            return true
        else if key = "OK" and m.toggleButton.hasFocus()
            print "MainScene: OK key pressed on toggleButton"
            OnToggleButton()
            return true
        end if
    else if isStationGridFocused
        if key = "left"
            focusedIndex = m.top.FindNode("listenLiveView").FindNode("stationGrid").itemFocused
            print "MainScene: Left key pressed in stationGrid, focused index: "; focusedIndex
            if m.justEnteredStationGrid or focusedIndex = 0 or focusedIndex = 4
                print "MainScene: Just entered or in leftmost column, moving focus to tabGroup"
                m.tabGroup.setFocus(true)
                ' Ensure the child button gets focus
                if m.tabGroup.focusedChild = invalid
                    m.listenLiveTab.setFocus(true)
                end if
                m.justEnteredStationGrid = false
                return true
            else
                print "MainScene: Not in leftmost column, handled by PosterGrid"
                m.justEnteredStationGrid = false
                return false
            end if
        else if key = "right" or key = "up" or key = "down"
            print "MainScene: Navigation in stationGrid, handled by PosterGrid"
            m.currentStationIndex = m.top.FindNode("listenLiveView").FindNode("stationGrid").itemFocused
            m.justEnteredStationGrid = false
            return false
        else if key = "OK"
            print "MainScene: OK key pressed on stationGrid, selecting station"
            m.justEnteredStationGrid = false
            return false
        end if
    end if

    return false
End Function