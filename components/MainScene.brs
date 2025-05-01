Sub Init()
    print "MainScene: Entering Init"
    m.audioPlayer = m.top.FindNode("audioPlayer")
    m.tabGroup = m.top.FindNode("tabGroup")
    m.listenLiveTab = m.top.FindNode("listenLiveTab")
    m.podcastsTab = m.top.FindNode("podcastsTab")
    m.NowPlayingButton = m.top.FindNode("NowPlayingButton")
    m.contentStack = m.top.FindNode("contentStack")
    m.listenLiveView = m.top.FindNode("listenLiveView")
    m.appLogo = m.top.FindNode("appLogo")
    m.background = m.top.FindNode("background")
    m.podcastsView = invalid

    if m.audioPlayer = invalid or m.tabGroup = invalid or m.listenLiveTab = invalid or m.podcastsTab = invalid or m.NowPlayingButton = invalid or m.contentStack = invalid or m.listenLiveView = invalid or m.appLogo = invalid or m.background = invalid
        print "ERROR: Node not found"
        return
    end if

    print "MainScene: Setting observers"
    m.tabGroup.observeFieldScoped("buttonSelected", "onButtonSelected")
    m.audioPlayer.observeFieldScoped("state", "OnAudioStateChange")
    m.top.observeFieldScoped("keyEvent", "OnKeyEvent")
    m.listenLiveView.observeFieldScoped("selectedStationIndex", "OnStationSelected")

    m.stations = [
        {url: "https://ice64.securenetsystems.net/KQBL", name: "101.9 The Bull", format: "aac", title: "101.9 The Bull", poster: "pkg:/images/bull.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBL.xml"},
        {url: "https://ice9.securenetsystems.net/KZMG", name: "My 102.7", format: "aac", title: "My 102.7", poster: "pkg:/images/my.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KZMG.xml"},
        {url: "https://ice64.securenetsystems.net/KSRV", name: "Bob FM 96.1", format: "aac", title: "Bob FM 96.1", poster: "pkg:/images/bob.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KSRV.xml"},
        {url: "https://ice9.securenetsystems.net/KWYD", name: "Wild 101.1", format: "aac", title: "Wild 101.1", poster: "pkg:/images/wild.png", xmlUrl: "https://streamdb7web.securenetsystems.net/player_status_update/KWYD.xml"},
        {url: "https://ice64.securenetsystems.net/KQBLHD2", name: "IRock 99.1 FM", format: "aac", title: "IRock 99.1 FM", poster: "pkg:/images/irock.png", xmlUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2.xml"},
        {url: "https://ice64.securenetsystems.net/KSRVHD2", name: "Fox Sports 99.9", format: "aac", title: "Fox Sports 99.9", poster: "pkg:/images/fox.png", xmlUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2.xml"},
        {url: "https://ice5.securenetsystems.net/KKOO", name: "101.5 Kool FM", format: "aac", title: "101.5 Kool FM", poster: "pkg:/images/kool.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KKOO.xml"},
        {url: "https://ice9.securenetsystems.net/KQBLHD3", name: "96.5 The Alternative", format: "aac", title: "96.5 The Alternative", poster: "pkg:/images/alt.png", xmlUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3.xml"}
    ]

    print "MainScene: Setting stations for ListenLiveView, count: "; m.stations.Count()
    m.listenLiveView.stations = m.stations

    m.registry = CreateObject("roRegistrySection", "ListenBoisePrefs")
    lastPlayedIndex = m.registry.Read("lastPlayedStationIndex")
    isPlaying = m.registry.Read("isPlaying")
    m.currentStationIndex = -1
    m.isPlaying = (isPlaying = "true")

    if lastPlayedIndex <> invalid and lastPlayedIndex <> "" and lastPlayedIndex.ToInt() >= 0 and lastPlayedIndex.ToInt() < m.stations.Count()
        m.currentStationIndex = lastPlayedIndex.ToInt()
        print "MainScene: Restoring last played station index: "; m.currentStationIndex
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        if stationGrid <> invalid
            stationGrid.jumpToItem = m.currentStationIndex
            print "MainScene: Set stationGrid to focus item: "; m.currentStationIndex
        end if
    end if

    print "MainScene: Initial view set to listenLiveView"
    m.listenLiveView.visible = true
    m.appLogo.visible = true
    m.tabGroup.visible = true
    m.contentStack.visible = true
    m.listenLiveView.FindNode("stationGrid").visible = true
    m.background.visible = true
    m.background.uri = "pkg:/images/background.png"

    print "MainScene: Setting initial focus to tabGroup"
    m.tabGroup.focusable = true
    m.tabGroup.setFocus(true)
    print "MainScene: tabGroup focus: "; m.tabGroup.hasFocus(); ", listenLiveTab focus: "; m.listenLiveTab.hasFocus()
    print "MainScene: Init complete"
End Sub

sub onButtonSelected()
    selectedIndex = m.tabGroup.buttonSelected
    print "MainScene: Button selected at index: "; selectedIndex

    if selectedIndex = 0
        print "MainScene: Switching to listenLiveView"
        m.listenLiveView.visible = true
        if m.podcastsView <> invalid
            m.podcastsView.visible = false
        end if
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        if stationGrid <> invalid
            stationGrid.visible = true
            stationGrid.setFocus(true)
            print "MainScene: stationGrid focus set, itemFocused: "; stationGrid.itemFocused
        end if
        m.tabGroup.setFocus(true)
        m.listenLiveTab.setFocus(true)
        m.background.visible = true
    else if selectedIndex = 1
        print "MainScene: Switching to podcastsView"
        if m.podcastsView = invalid
            print "MainScene: Creating podcastsView dynamically"
            m.podcastsView = m.top.CreateChild("PodcastsView")
            m.podcastsView.id = "podcastsView"
            m.podcastsView.translation = "[270, 250]"
            m.podcastsView.visible = true
            if m.podcastsView = invalid
                print "ERROR: Failed to create podcastsView"
                m.listenLiveView.visible = true
                m.tabGroup.setFocus(true)
                return
            end if
        end if
        m.listenLiveView.visible = false
        m.podcastsView.visible = true
        m.podcastsView.setFocus(true)
        m.background.visible = true
    else if selectedIndex = 2
        print "MainScene: Showing NowPlaying UI in listenLiveView"
        playbackUI = m.listenLiveView.FindNode("playbackUI")
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        stationLabel = m.listenLiveView.FindNode("stationLabel")
        toggleButton = m.listenLiveView.FindNode("toggleButton")
        if playbackUI = invalid or stationGrid = invalid or stationLabel = invalid or toggleButton = invalid
            print "MainScene: Playback UI not loaded or nodes not found, showing station grid"
            stationGrid.visible = true
            if playbackUI <> invalid
                playbackUI.visible = false
            end if
            if stationLabel <> invalid
                stationLabel.text = "Please select a station"
            end if
            m.tabGroup.visible = true
            m.appLogo.visible = true
            m.contentStack.visible = true
            m.background.visible = true
            m.tabGroup.setFocus(true)
            m.listenLiveTab.setFocus(true)
            return
        end if
        if m.currentStationIndex = -1
            print "MainScene: No station selected, showing station grid"
            stationGrid.visible = true
            playbackUI.visible = false
            stationLabel.text = "Please select a station"
            m.tabGroup.visible = true
            m.appLogo.visible = true
            m.contentStack.visible = true
            m.background.visible = true
            m.tabGroup.setFocus(true)
            m.listenLiveTab.setFocus(true)
            return
        end if
        stationGrid.visible = false
        playbackUI.visible = true
        stationLabel.text = m.stations[m.currentStationIndex].name
        m.appLogo.visible = true
        m.tabGroup.visible = false
        if m.podcastsView <> invalid
            m.podcastsView.visible = false
        end if
        m.contentStack.visible = true
        m.background.visible = true
        toggleButton.setFocus(true)
    end if

    focusedChildId = "none"
    if m.tabGroup.focusedChild <> invalid
        focusedChildId = m.tabGroup.focusedChild.id
    end if
    print "MainScene: Post-button-switch focus - tabGroup: "; m.tabGroup.hasFocus(); ", focused button: "; focusedChildId
    if m.listenLiveView.visible
        print "MainScene: stationGrid focus: "; m.listenLiveView.FindNode("stationGrid").hasFocus()
    else
        print "MainScene: stationGrid focus: N/A"
    end if
end sub

Sub OnStationSelected()
    selectedIndex = m.listenLiveView.selectedStationIndex
    print "MainScene: Station selected at index: "; selectedIndex; ", Name: "; m.stations[selectedIndex].name

    if selectedIndex < 0 or selectedIndex >= m.stations.Count()
        print "MainScene: Invalid station index: "; selectedIndex; ", aborting playback"
        return
    end if

    print "MainScene: Preparing audio player for station: "; m.stations[selectedIndex].name
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
    m.registry.Write("lastPlayedStationIndex", selectedIndex.ToStr())
    m.registry.Write("isPlaying", m.isPlaying.ToStr())
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
    m.registry.Write("isPlaying", "true")
    m.registry.Flush()
    print "MainScene: Playing station - "; m.stations[m.currentStationIndex].name
    toggleButton.setFocus(true)
    print "MainScene: toggleButton focus: "; toggleButton.hasFocus()
End Sub

Sub OnToggleButton()
    print "MainScene: Toggle button pressed"
    print "MainScene: Current station index: "; m.currentStationIndex
    print "MainScene: Is playing: "; m.isPlaying
    if m.currentStationIndex = -1
        print "MainScene: No station selected, showing station grid"
        playbackUI = m.listenLiveView.FindNode("playbackUI")
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        stationLabel = m.listenLiveView.FindNode("stationLabel")
        if stationGrid = invalid
            print "ERROR: MainScene - stationGrideful not found"
            return
        end if
        stationGrid.visible = true
        if playbackUI <> invalid
            playbackUI.visible = false
        end if
        if stationLabel <> invalid
            stationLabel.text = "Please select a station"
        end if
        m.tabGroup.visible = true
        m.appLogo.visible = true
        m.contentStack.visible = true
        m.background.visible = true
        m.tabGroup.setFocus(true)
        m.listenLiveTab.setFocus(true)
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
        m.registry.Write("isPlaying", "false")
        m.registry.Flush()
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
        m.registry.Write("isPlaying", "true")
        m.registry.Flush()
        print "MainScene: Playback resumed - "; m.stations[m.currentStationIndex].name
    end if
End Sub

Sub OnAudioStateChange()
    print "MainScene: Audio state changed to: "; m.audioPlayer.state
    if m.audioPlayer.state = "error"
        errorCode = m.audioPlayer.errorCode
        errorMsg = m.audioPlayer.errorMsg
        print "MainScene: Audio error - Code: "; errorCode; ", Message: "; errorMsg
        m.isPlaying = false
        m.registry.Write("isPlaying", "false")
        m.registry.Flush()
    else if m.audioPlayer.state = "playing"
        m.isPlaying = true
        m.registry.Write("isPlaying", "true")
        m.registry.Flush()
    else if m.audioPlayer.state = "stopped"
        m.isPlaying = false
        m.registry.Write("isPlaying", "false")
        m.registry.Flush()
    end if
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    print "MainScene: Key event - Key: "; key; ", Press: "; press

    playbackUI = m.listenLiveView.FindNode("playbackUI")
    isPlaybackUIVisible = playbackUI <> invalid and playbackUI.visible
    isTabGroupHidden = m.tabGroup.visible = false

    if isPlaybackUIVisible and isTabGroupHidden
        print "MainScene: PlaybackUI visible and tabGroup hidden, only blocking navigation keys"
        if key = "up" or key = "down" or key = "left" or key = "right"
            print "MainScene: Blocking navigation key: "; key
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
    podcastsViewVisibility = "invalid"
    if m.podcastsView <> invalid
        podcastsViewVisibility = m.podcastsView.visible
    end if
    print "MainScene: Current view visibility - listenLiveView: "; m.listenLiveView.visible; ", podcastsView: "; podcastsViewVisibility
    if m.listenLiveView.visible
        print "MainScene: stationGrid focus: "; m.listenLiveView.FindNode("stationGrid").hasFocus()
    else
        print "MainScene: stationGrid focus: N/A"
    end if

    isTabGroupFocused = m.tabGroup.hasFocus() or m.tabGroup.focusedChild <> invalid

    if not isTabGroupFocused
        print "MainScene: No component has focus, forcing focus to tabGroup"
        m.tabGroup.setFocus(true)
        m.listenLiveTab.setFocus(true)
        return true
    end if

    if key = "back"
        print "MainScene: Back key pressed, returning to main menu"
        m.listenLiveView.visible = true
        if m.podcastsView <> invalid
            m.podcastsView.visible = false
        end if
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        if stationGrid <> invalid
            stationGrid.visible = true
            m.tabGroup.setFocus(true)
            m.listenLiveTab.setFocus(true)
        end if
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
            print "MainScene: Right key pressed on tabGroup, focusing stationGrid"
            if m.listenLiveView.visible
                stationGrid = m.listenLiveView.FindNode("stationGrid")
                if stationGrid <> invalid and stationGrid.visible
                    stationGrid.setFocus(true)
                    if not stationGrid.hasFocus()
                        print "MainScene: Retrying stationGrid focus"
                        stationGrid.setFocus(true)
                    end if
                    print "MainScene: stationGrid focused_rectangle: "; stationGrid.boundingRect()
                    print "MainScene: stationGrid focused item: "; stationGrid.itemFocused; ", hasFocus: "; stationGrid.hasFocus()
                    return true
                else
                    print "ERROR: MainScene - stationGrid not found or not visible"
                    return false
                end if
            else if m.podcastsView <> invalid and m.podcastsView.visible
                print "MainScene: Moving focus to podcastsView"
                m.podcastsView.setFocus(true)
                return true
            end if
        else if key = "left"
            print "MainScene: Left key pressed on tabGroup, no action (leftmost component)"
            return true
        end if
    end if
    return false
End Function