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
    m.listenLiveView.observeFieldScoped("toggleButtonPressed", "OnToggleButtonPressed")
    m.listenLiveView.observeField("artist", "UpdatePlaybackCardArtist")
    m.listenLiveView.observeField("songTitle", "UpdatePlaybackCardSongTitle")

    m.stations = [
        {url: "https://ice64.securenetsystems.net/KQBL", name: "101.9 The Bull", format: "aac", title: "101.9 The Bull", poster: "pkg:/images/bull.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBL_history.txt"},
        {url: "https://ice9.securenetsystems.net/KZMG", name: "My 102.7", format: "aac", title: "My 102.7", poster: "pkg:/images/my.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KZMG_history.txt"},
        {url: "https://ice64.securenetsystems.net/KSRV", name: "Bob FM 96.1", format: "aac", title: "Bob FM 96.1", poster: "pkg:/images/bob.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KSRV_history.txt"},
        {url: "https://ice9.securenetsystems.net/KWYD", name: "Wild 101.1", format: "aac", title: "Wild 101.1", poster: "pkg:/images/wild.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KWYD_history.txt"},
        {url: "https://ice64.securenetsystems.net/KQBLHD2", name: "IRock 99.1 FM", format: "aac", title: "IRock 99.1 FM", poster: "pkg:/images/irock.png", jsonUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2_history.txt"},
        {url: "https://ice64.securenetsystems.net/KSRVHD2", name: "Fox Sports 99.9", format: "aac", title: "Fox Sports 99.9", poster: "pkg:/images/fox.png", jsonUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2_history.txt"},
        {url: "https://ice5.securenetsystems.net/KKOO", name: "101.5 Kool FM", format: "aac", title: "101.5 Kool FM", poster: "pkg:/images/kool.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KKOO_history.txt"},
        {url: "https://ice9.securenetsystems.net/KQBLHD3", name: "96.5 The Alternative", format: "aac", title: "96.5 The Alternative", poster: "pkg:/images/alt.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3_history.txt"}
    ]

    print "MainScene: Setting stations for ListenLiveView, count: "; m.stations.Count()
    m.listenLiveView.stations = m.stations

    m.registry = CreateObject("roRegistrySection", "ListenBoisePrefs")
    print "MainScene: Clearing registry on launch"
    m.registry.Delete("lastPlayedStationIndex")
    m.registry.Delete("isPlaying")
    m.registry.Flush()
    m.currentStationIndex = -1
    m.isPlaying = false

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

    m.playbackCard = m.top.CreateChild("PlaybackCard")
    m.playbackCard.translation = "[100, 100]"
    m.playbackCard.visible = false

    ' Ensure stationGrid is focused after init
    stationGrid = m.listenLiveView.FindNode("stationGrid")
    if stationGrid <> invalid and stationGrid.content <> invalid and stationGrid.content.GetChildCount() > 0
        stationGrid.setFocus(true)
        stationGrid.itemFocused = 0
        print "MainScene: stationGrid focused after init, itemFocused: "; stationGrid.itemFocused
    else
        print "ERROR: MainScene - stationGrid not ready or no content"
    end if
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
        if stationGrid <> invalid and stationGrid.content <> invalid and stationGrid.content.GetChildCount() > 0
            stationGrid.visible = true
            stationGrid.setFocus(true)
            stationGrid.itemFocused = 0
            print "MainScene: stationGrid focus set, itemFocused: "; stationGrid.itemFocused; ", hasFocus: "; stationGrid.hasFocus()
        else
            print "ERROR: MainScene - stationGrid not found or no content"
            m.tabGroup.setFocus(true)
            m.listenLiveTab.setFocus(true)
            return
        end if
        m.background.visible = true
        m.playbackCard.visible = m.isPlaying
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
            m.podcastsView.observeField("selectedPodcast", "OnPodcastSelected")
        end if
        m.listenLiveView.visible = false
        m.podcastsView.visible = true
        podcastGrid = m.podcastsView.FindNode("podcastGrid")
        if podcastGrid <> invalid and podcastGrid.content <> invalid and podcastGrid.content.GetChildCount() > 0
            podcastGrid.setFocus(true)
            podcastGrid.itemFocused = 0
            print "MainScene: podcastGrid focus set, itemFocused: "; podcastGrid.itemFocused; ", hasFocus: "; podcastGrid.hasFocus()
        else
            print "ERROR: MainScene - podcastGrid not found or no content"
            m.tabGroup.setFocus(true)
            return
        end if
        m.background.visible = true
        m.playbackCard.visible = m.isPlaying
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
        m.playbackCard.visible = m.isPlaying
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

Sub ShowPlaybackUI()
    print "MainScene: ShowPlaybackUI called"
End Sub

Sub OnToggleButtonPressed()
    print "MainScene: toggleButtonPressed observed from ListenLiveView"
    OnToggleButton()
End Sub

Sub OnStationSelected()
    selectedIndex = m.listenLiveView.selectedStationIndex
    print "MainScene: Station selected at index: "; selectedIndex; ", Name: "; m.stations[selectedIndex].name
    print "MainScene: Audio player state before playback: "; m.audioPlayer.state

    if selectedIndex < 0 or selectedIndex >= m.stations.Count()
        print "MainScene: Invalid station index: "; selectedIndex; ", aborting playback"
        return
    end if

    print "MainScene: Preparing audio player for station: "; m.stations[selectedIndex].name
    if m.audioPlayer <> invalid
        m.audioPlayer.control = "stop"
        m.audioPlayer.content = invalid
    end if

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
    content.url = m.stations[selectedIndex].url + "?t=" + timestamp
    content.streamFormat = m.stations[selectedIndex].format
    content.streamQualities = ["SD"]
    content.streamBitrates = [128]
    content.addHeader("User-Agent", "Roku")
    content.addHeader("Accept", "audio/aac")
    content.addHeader("Connection", "keep-alive")
    m.audioPlayer.content = content
    m.audioPlayer.control = "prebuffer"
    sleep(500)
    m.audioPlayer.control = "play"
    m.isPlaying = true
    m.registry.Write("isPlaying", "true")
    m.registry.Flush()
    print "MainScene: Playing station - "; m.stations[m.currentStationIndex].name
    toggleButton.setFocus(true)
    print "MainScene: toggleButton focus: "; toggleButton.hasFocus()

    m.playbackCard.artist = "Loading..."
    m.playbackCard.songTitle = "Loading..."
    m.playbackCard.visible = true
End Sub

Sub OnPodcastSelected()
    episode = m.podcastsView.selectedPodcast
    if episode = invalid
        print "MainScene: Invalid podcast episode selected"
        return
    end if
    PlayPodcast(episode)
End Sub

Sub OnToggleButton()
    print "MainScene: Toggle button pressed (called from ListenLiveView)"
    print "MainScene: Current station index: "; m.currentStationIndex
    print "MainScene: Is playing: "; m.isPlaying
    if m.currentStationIndex = -1
        print "MainScene: No station selected, showing station grid"
        playbackUI = m.listenLiveView.FindNode("playbackUI")
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        stationLabel = m.listenLiveView.FindNode("stationLabel")
        if stationGrid = invalid
            print "ERROR: MainScene - stationGrid not found"
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
        m.playbackCard.visible = false
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
        m.playbackCard.visible = false
    else
        if m.currentStationIndex = -1
            print "MainScene: No station selected to resume"
            return
        end if
        if m.audioPlayer <> invalid
            m.audioPlayer.control = "stop"
            m.audioPlayer.content = invalid
        end if
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
        sleep(500)
        m.audioPlayer.control = "play"
        m.isPlaying = true
        m.registry.Write("isPlaying", "true")
        m.registry.Flush()
        print "MainScene: Playback resumed - "; m.stations[m.currentStationIndex].name
        m.playbackCard.visible = true
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
        m.playbackCard.visible = false
    else if m.audioPlayer.state = "playing"
        m.isPlaying = true
        m.registry.Write("isPlaying", "true")
        m.registry.Flush()
        m.playbackCard.visible = true
    else if m.audioPlayer.state = "stopped"
        m.isPlaying = false
        m.registry.Write("isPlaying", "false")
        m.registry.Flush()
        m.playbackCard.visible = false
    end if
End Sub

Sub UpdatePlaybackCardArtist()
    m.playbackCard.artist = m.listenLiveView.artist
End Sub

Sub UpdatePlaybackCardSongTitle()
    m.playbackCard.songTitle = m.listenLiveView.songTitle
End Sub

Sub PlayPodcast(episode as Object)
    m.audioPlayer.control = "stop"
    content = CreateObject("roSGNode", "ContentNode")
    content.url = episode.url
    content.streamFormat = "mp3"
    m.audioPlayer.content = content
    m.audioPlayer.control = "play"
    m.isPlaying = true
    m.playbackCard.artist = episode.title
    m.playbackCard.songTitle = "Podcast Episode"
    m.playbackCard.visible = true
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

    if key = "back"
        print "MainScene: Back key pressed, returning to main menu"
        m.listenLiveView.visible = true
        if m.podcastsView <> invalid
            m.podcastsView.visible = false
        end if
        stationGrid = m.listenLiveView.FindNode("stationGrid")
        if stationGrid <> invalid and stationGrid.content <> invalid and stationGrid.content.GetChildCount() > 0
            stationGrid.visible = true
            m.tabGroup.setFocus(true)
            m.listenLiveTab.setFocus(true)
            stationGrid.setFocus(true)
            stationGrid.itemFocused = 0
            print "MainScene: stationGrid focused on back, itemFocused: "; stationGrid.itemFocused
        else
            print "ERROR: MainScene - stationGrid not found or no content on back"
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
        m.playbackCard.visible = m.isPlaying
        return true
    end if

    if m.tabGroup.hasFocus() or m.tabGroup.focusedChild <> invalid
        if key = "right"
            print "MainScene: Right key pressed on tabGroup, focusing appropriate grid"
            if m.listenLiveView.visible
                stationGrid = m.listenLiveView.FindNode("stationGrid")
                if stationGrid <> invalid and stationGrid.content <> invalid and stationGrid.content.GetChildCount() > 0
                    stationGrid.setFocus(true)
                    stationGrid.itemFocused = 0
                    print "MainScene: stationGrid focused_rectangle: "; stationGrid.boundingRect()
                    print "MainScene: stationGrid focused item: "; stationGrid.itemFocused; ", hasFocus: "; stationGrid.hasFocus()
                    return true
                else
                    print "ERROR: MainScene - stationGrid not found or no content"
                    return false
                end if
            else if m.podcastsView <> invalid and m.podcastsView.visible
                podcastGrid = m.podcastsView.FindNode("podcastGrid")
                if podcastGrid <> invalid and podcastGrid.content <> invalid and podcastGrid.content.GetChildCount() > 0
                    podcastGrid.setFocus(true)
                    podcastGrid.itemFocused = 0
                    print "MainScene: podcastGrid focused, itemFocused: "; podcastGrid.itemFocused; ", hasFocus: "; podcastGrid.hasFocus()
                    return true
                else
                    print "ERROR: MainScene - podcastGrid not found or no content"
                    return false
                end if
            end if
        else if key = "left"
            print "MainScene: Left key pressed on tabGroup, no action (leftmost component)"
            return true
        end if
    end if
    return false
End Function