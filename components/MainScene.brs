Sub Init()
    print "MainScene: Entering Init"
    m.audioPlayer = m.top.FindNode("audioPlayer")
    m.tabGroup = m.top.FindNode("tabGroup")
    m.listenLiveTab = m.top.FindNode("listenLiveTab")
    m.newsTab = m.top.FindNode("newsTab")
    m.podcastsTab = m.top.FindNode("podcastsTab")
    m.NowPlayingButton = m.top.FindNode("NowPlayingButton")
    m.toggleButton = m.top.FindNode("toggleButton")
    m.contentStack = m.top.FindNode("contentStack")
    m.listenLiveView = m.top.FindNode("listenLiveView")
    m.newsView = m.top.FindNode("newsView")
    m.podcastsView = m.top.FindNode("podcastsView")
    m.appLogo = m.top.FindNode("appLogo")
    m.background = m.top.FindNode("background")

    if m.audioPlayer = invalid or m.tabGroup = invalid or m.listenLiveTab = invalid or m.newsTab = invalid or m.podcastsTab = invalid or m.NowPlayingButton = invalid or m.toggleButton = invalid or m.contentStack = invalid or m.listenLiveView = invalid or m.newsView = invalid or m.podcastsView = invalid or m.appLogo = invalid or m.background = invalid
        print "ERROR: Node not found"
        return
    end if

    print "MainScene: Setting observers"
    m.tabGroup.observeFieldScoped("buttonSelected", "onButtonSelected")
    m.toggleButton.observeFieldScoped("keyEvent", "OnToggleButtonKeyEvent")
    m.audioPlayer.observeFieldScoped("state", "OnAudioStateChange")
    m.top.observeFieldScoped("keyEvent", "OnKeyEvent")
    m.listenLiveView.observeFieldScoped("selectedStationIndex", "OnStationSelected")

    m.stations = [
        {url: "https://ice64.securenetsystems.net/KQBL", name: "101.9 The Bull", format: "aac"},
        {url: "https://ice9.securenetsystems.net/KZMG", name: "My 102.7", format: "aac"},
        {url: "https://ice64.securenetsystems.net/KSRV", name: "Bob FM 96.1", format: "aac"},
        {url: "https://ice9.securenetsystems.net/KWYD", name: "Wild 101.1", format: "aac"},
        {url: "https://ice64.securenetsystems.net/KQBLHD2", name: "IRock 99.1 FM", format: "aac"},
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
    m.listenLiveView.visible = true
    m.newsView.visible = false
    m.podcastsView.visible = false

    m.appLogo.visible = true
    m.tabGroup.visible = true
    m.contentStack.visible = true
    m.listenLiveView.FindNode("stationGrid").visible = true
    m.background.visible = true
    m.background.uri = "pkg:/images/background.png"

    print "MainScene: Setting initial focus to tabGroup"
    m.focusTimer = CreateObject("roSGNode", "Timer")
    m.focusTimer.duration = 0.1
    m.focusTimer.observeField("fire", "setInitialFocus")
    m.focusTimer.control = "start"
End Sub

Sub setInitialFocus()
    print "MainScene: Setting initial focus in timer callback"
    m.tabGroup.setFocus(true)
    m.listenLiveTab.setFocus(true)
    m.top.setFocus(true)
    m.top.observeFieldScoped("focusedChild", "onFocusChange")
    print "MainScene: scene focus: "; m.top.hasFocus()
    focusedChildId = "none"
    if m.tabGroup.focusedChild <> invalid
        focusedChildId = m.tabGroup.focusedChild.id
    end if
    print "MainScene: tabGroup focus: "; m.tabGroup.hasFocus(); ", focused button: "; focusedChildId
    print "MainScene: listenLiveTab focus: "; m.listenLiveTab.hasFocus()
    print "MainScene: newsTab focus: "; m.newsTab.hasFocus()
    print "MainScene: podcastsTab focus: "; m.podcastsTab.hasFocus()
    print "MainScene: NowPlayingButton focus: "; m.NowPlayingButton.hasFocus()
    print "MainScene: stationGrid focus: "; m.listenLiveView.FindNode("stationGrid").hasFocus()
    print "MainScene: Init complete"
    m.focusTimer.control = "stop"
    m.focusTimer = invalid
End Sub

Sub onFocusChange()
    if m.top.focusedChild = invalid and m.tabGroup.hasFocus() = false
        print "MainScene: Focus lost unexpectedly, restoring to tabGroup"
        m.tabGroup.setFocus(true)
        m.listenLiveTab.setFocus(true)
    end if
End Sub

sub onButtonSelected()
    selectedIndex = m.tabGroup.buttonSelected
    print "MainScene: Button selected at index: "; selectedIndex

    if selectedIndex = 0
        print "MainScene: Switching to listenLiveView"
        m.listenLiveView.visible = true
        m.newsView.visible = false
        m.podcastsView.visible = false
        m.top.FindNode("listenLiveView").FindNode("stationGrid").visible = true
        m.tabGroup.setFocus(true)
        m.listenLiveTab.setFocus(true)
        m.justEnteredStationGrid = false
        m.background.visible = true
    else if selectedIndex = 1
        print "MainScene: Switching to newsView"
        m.listenLiveView.visible = false
        m.newsView.visible = true
        m.podcastsView.visible = false
        m.top.FindNode("newsView").setFocus(true)
        m.background.visible = true
    else if selectedIndex = 2
        print "MainScene: Switching to podcastsView"
        m.listenLiveView.visible = false
        m.newsView.visible = false
        m.podcastsView.visible = true
        m.top.FindNode("podcastsView").setFocus(true)
        m.background.visible = true
    else if selectedIndex = 3
        print "MainScene: Showing NowPlaying UI in listenLiveView"
        if m.currentStationIndex = -1
            print "MainScene: No station selected, cannot show Now Playing"
            return
        end if
        playbackUI = m.listenLiveView.FindNode("playbackUI")
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        stationLabel = m.listenLiveView.FindNode("stationLabel")
        if playbackUI = invalid or stationGrid = invalid or stationLabel = invalid
            print "ERROR: MainScene - Playback UI nodes not found"
            return
        end if
        stationGrid.visible = false
        playbackUI.visible = true
        stationLabel.text = m.stations[m.currentStationIndex].name
        m.appLogo.visible = true
        m.tabGroup.visible = false
        m.newsView.visible = false
        m.podcastsView.visible = false
        m.contentStack.visible = true
        m.background.visible = true
        m.listenLiveView.FindNode("toggleButton").setFocus(true)
        m.top.setFocus(true)
    end if

    focusedChildId = "none"
    if m.tabGroup.focusedChild <> invalid
        focusedChildId = m.tabGroup.focusedChild.id
    end if
    print "MainScene: Post-button-switch focus - tabGroup: "; m.tabGroup.hasFocus(); ", focused button: "; focusedChildId
    if m.listenLiveView.visible
        print "MainScene: stationGrid focus: "; m.top.FindNode("listenLiveView").FindNode("stationGrid").hasFocus()
    else
        print "MainScene: stationGrid focus: N/A"
    end if
end sub

Sub OnStationSelected()
    selectedIndex = m.listenLiveView.selectedStationIndex
    print "MainScene: Station selected at index: "; selectedIndex

    if selectedIndex < 0 or selectedIndex >= m.stations.Count()
        print "MainScene: Invalid station index: "; selectedIndex; ", aborting playback"
        return
    end if

    if m.audioPlayer <> invalid
        m.audioPlayer.control = "stop"
        m.audioPlayer.content = invalid
        m.audioPlayer.unobserveFieldScoped("state")
        m.audioPlayer = invalid
    end if
    m.audioPlayer = m.top.FindNode("audioPlayer")
    if m.audioPlayer = invalid
        print "ERROR: MainScene - audioPlayer not found after recreation"
        return
    end if
    m.audioPlayer.observeFieldScoped("state", "OnAudioStateChange")

    m.currentStationIndex = selectedIndex
    m.registry.Write("lastPlayedStationIndex", m.currentStationIndex.ToStr())
    m.registry.Flush()

    playbackUI = m.listenLiveView.FindNode("playbackUI")
    stationGrid = m.listenLiveView.FindNode("stationGrid")
    stationLabel = m.listenLiveView.FindNode("stationLabel")
    toggleButton = m.listenLiveView.FindNode("toggleButton")
    if playbackUI = invalid or stationGrid = invalid or stationLabel = invalid or toggleButton = invalid
        print "ERROR: MainScene - Playback UI nodes not found"
        return
    end if
    stationGrid.visible = false
    playbackUI.visible = true
    stationLabel.text = m.stations[m.currentStationIndex].name
    content = CreateObject("roSGNode", "ContentNode")
    timestamp = (CreateObject("roDateTime")).AsSeconds().ToStr()
    content.url = m.stations[m.currentStationIndex].url + "?t=" + timestamp
    content.streamFormat = m.stations[m.currentStationIndex].format
    content.streamQualities = ["SD"]
    content.streamBitrates = [128]
    content.addHeader("User-Agent", "Roku")
    content.addHeader("Accept", "audio/aac")
    content.addHeader("Connection", "keep-alive")
    m.audioPlayer.content = content
    m.audioPlayer.control = "prebuffer"
    m.audioPlayer.control = "play"
    m.isPlaying = true
    print "MainScene: Playing station - "; m.stations[m.currentStationIndex].name
    m.appLogo.visible = true
    m.tabGroup.visible = false
    m.newsView.visible = false
    m.podcastsView.visible = false
    m.contentStack.visible = true
    m.background.visible = true
    m.listenLiveView.FindNode("toggleButton").setFocus(true)
    m.top.setFocus(true)
    print "MainScene: Scene focus after station selection: "; m.top.hasFocus()
End Sub

function OnToggleButtonKeyEvent() as Boolean
    key = m.toggleButton.keyEvent.key
    press = m.toggleButton.keyEvent.press
    print "MainScene: Toggle button key event - Key: "; key; ", Press: "; press
    if press and key = "OK"
        print "MainScene: OK key pressed on toggleButton"
        OnToggleButton()
        return true
    end if
    return false
end function

Sub OnToggleButton()
    print "MainScene: Toggle button pressed"
    print "MainScene: Current station index: "; m.currentStationIndex
    print "MainScene: Is playing: "; m.isPlaying
    if m.currentStationIndex = -1
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        if stationGrid <> invalid
            m.currentStationIndex = 0 ' Default to 101.9 The Bull
            print "MainScene: No station selected, defaulting to 101.9 The Bull (index 0)"
        else
            print "ERROR: MainScene - stationGrid not found"
            return
        end if
        m.registry.Write("lastPlayedStationIndex", m.currentStationIndex.ToStr())
        m.registry.Flush()
        playbackUI = m.listenLiveView.FindNode("playbackUI")
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        stationLabel = m.listenLiveView.FindNode("stationLabel")
        toggleButton = m.listenLiveView.FindNode("toggleButton")
        if playbackUI = invalid or stationGrid = invalid or stationLabel = invalid or toggleButton = invalid
            print "ERROR: MainScene - Playback UI nodes not found"
            return
        end if
        stationGrid.visible = false
        playbackUI.visible = true
        stationLabel.text = m.stations[m.currentStationIndex].name
        content = CreateObject("roSGNode", "ContentNode")
        timestamp = (CreateObject("roDateTime")).AsSeconds().ToStr()
        content.url = m.stations[m.currentStationIndex].url + "?t=" + timestamp
        content.streamFormat = m.stations[m.currentStationIndex].format
        content.streamQualities = ["SD"]
        content.streamBitrates = [128]
        content.addHeader("User-Agent", "Roku")
        content.addHeader("Accept", "audio/aac")
        content.addHeader("Connection", "keep-alive")
        m.audioPlayer.content = content
        m.audioPlayer.control = "prebuffer"
        m.audioPlayer.control = "play"
        m.isPlaying = true
        print "MainScene: Playing station - "; m.stations[m.currentStationIndex].name
        m.appLogo.visible = true
        m.tabGroup.visible = false
        m.newsView.visible = false
        m.podcastsView.visible = false
        m.contentStack.visible = true
        m.background.visible = true
        m.listenLiveView.FindNode("toggleButton").setFocus(true)
        m.top.setFocus(true)
        return
    end if
    togglePlayback({})
End Sub

Sub togglePlayback(data as Object)
    if data = invalid then data = {}
    print "MainScene: togglePlayback called, isPlaying: "; m.isPlaying
    toggleButton = m.listenLiveView.FindNode("toggleButton")
    if toggleButton = invalid
        print "ERROR: MainScene - toggleButton not found"
        return
    end if
    if m.isPlaying
        m.audioPlayer.control = "stop"
        m.audioPlayer.content = invalid
        m.isPlaying = false
        print "MainScene: Playback stopped"
    else
        if m.currentStationIndex = -1
            print "MainScene: No station selected to resume"
            return
        end if
        if m.audioPlayer <> invalid
            m.audioPlayer.control = "stop"
            m.audioPlayer.content = invalid
            m.audioPlayer.unobserveFieldScoped("state")
            m.audioPlayer = invalid
        end if
        m.audioPlayer = m.top.FindNode("audioPlayer")
        if m.audioPlayer = invalid
            print "ERROR: MainScene - audioPlayer not found after recreation"
            return
        end if
        m.audioPlayer.observeFieldScoped("state", "OnAudioStateChange")
        content = CreateObject("roSGNode", "ContentNode")
        timestamp = (CreateObject("roDateTime")).AsSeconds().ToStr()
        content.url = m.stations[m.currentStationIndex].url + "?t=" + timestamp
        content.streamFormat = m.stations[m.currentStationIndex].format
        content.streamQualities = ["SD"]
        content.streamBitrates = [128]
        content.addHeader("User-Agent", "Roku")
        content.addHeader("Accept", "audio/aac")
        content.addHeader("Connection", "keep-alive")
        m.audioPlayer.content = content
        m.audioPlayer.control = "prebuffer"
        m.audioPlayer.control = "play"
        m.isPlaying = true
        print "MainScene: Playback resumed - "; m.stations[m.currentStationIndex].name
        m.top.setFocus(true)
    end if
End Sub

Sub restoreMainUI(data as Object)
    if data = invalid then data = {}
    print "MainScene: restoreMainUI called"
    m.appLogo.visible = true
    m.tabGroup.visible = true
    m.contentStack.visible = true
    m.listenLiveView.visible = true
    m.newsView.visible = false
    m.podcastsView.visible = false
    m.background.visible = true
    m.tabGroup.setFocus(true)
    if m.tabGroup.focusedChild = invalid
        m.listenLiveTab.setFocus(true)
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

    playbackUI = m.listenLiveView.FindNode("playbackUI")
    isPlaybackUIVisible = playbackUI <> invalid and playbackUI.visible
    isTabGroupHidden = m.tabGroup.visible = false

    if isPlaybackUIVisible and isTabGroupHidden
        print "MainScene: PlaybackUI visible and tabGroup hidden, ignoring main menu key events"
        if key = "up" or key = "down" or key = "left" or key = "right" or key = "OK"
            print "MainScene: Blocking menu navigation key: "; key
            return true
        end if
    end if

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

    isTabGroupFocused = m.tabGroup.hasFocus() or m.tabGroup.focusedChild <> invalid
    isStationGridFocused = m.listenLiveView.visible and m.top.FindNode("listenLiveView").FindNode("stationGrid").hasFocus()

    if not isTabGroupFocused and not isStationGridFocused
        print "MainScene: No component has focus, forcing focus to tabGroup"
        m.tabGroup.setFocus(true)
        m.listenLiveTab.setFocus(true)
        m.justEnteredStationGrid = false
        m.tabGroup.visible = true
        m.appLogo.visible = true
        m.contentStack.visible = true
        m.background.visible = true
        return true
    end if

    if key = "back"
        print "MainScene: Back key pressed, returning to main menu"
        m.listenLiveView.visible = true
        m.newsView.visible = false
        m.podcastsView.visible = false
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        if stationGrid <> invalid
            stationGrid.visible = true
            stationGrid.itemFocused = 0 ' Reset to Bull
            m.tabGroup.setFocus(true)
            m.listenLiveTab.setFocus(true)
        end if
        m.justEnteredStationGrid = false
        m.tabGroup.visible = true
        m.appLogo.visible = true
        m.contentStack.visible = true
        m.background.visible = true
        playbackUI = m.listenLiveView.FindNode("playbackUI")
        if playbackUI <> invalid and playbackUI.visible
            playbackUI.visible = false
            stationGrid.visible = true
        end if
        m.registry.Write("lastPlayedStationIndex", "-1")
        m.registry.Flush()
        m.currentStationIndex = -1
        return true
    end if

    if isTabGroupFocused
        if key = "up" or key = "down"
            print "MainScene: Up/Down key pressed on tabGroup, handled by ButtonGroup"
            return false
        else if key = "right"
            print "MainScene: Right key pressed on tabGroup, moving focus to stationGrid"
            if m.listenLiveView.visible
                stationGrid = m.top.FindNode("listenLiveView").FindNode("stationGrid")
                stationGrid.itemFocused = 0 ' Always start at Bull
                stationGrid.setFocus(true)
                print "MainScene: stationGrid focused item: "; stationGrid.itemFocused
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
        end if
    else if isStationGridFocused
        if key = "left"
            focusedIndex = m.top.FindNode("listenLiveView").FindNode("stationGrid").itemFocused
            print "MainScene: Left key pressed in stationGrid, focused index: "; focusedIndex
            if m.justEnteredStationGrid or focusedIndex = 0 or focusedIndex = 4
                print "MainScene: Just entered or in leftmost column, moving focus to tabGroup"
                m.tabGroup.setFocus(true)
                m.listenLiveTab.setFocus(true)
                m.justEnteredStationGrid = false
                return true
            else
                print "MainScene: Not in leftmost column, handled by PosterGrid"
                m.justEnteredStationGrid = false
                return false
            end if
        else if key = "right" or key = "up" or key = "down"
            focusedIndex = m.top.FindNode("listenLiveView").FindNode("stationGrid").itemFocused
            print "MainScene: Navigation in stationGrid, key: "; key; ", current index: "; focusedIndex
            m.justEnteredStationGrid = false
            return false
        else if key = "OK"
            focusedIndex = m.top.FindNode("listenLiveView").FindNode("stationGrid").itemFocused
            print "MainScene: OK key pressed on stationGrid, index: "; focusedIndex
            m.justEnteredStationGrid = false
            return false
        end if
    end if

    return false
End Function