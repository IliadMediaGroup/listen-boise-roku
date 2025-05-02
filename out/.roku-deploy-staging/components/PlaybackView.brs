Sub Init()
    print "PlaybackView: Entering init"
    m.albumCoverPoster = m.top.FindNode("albumCoverPoster")
    m.stationLabel = m.top.FindNode("stationLabel")
    m.songLabel = m.top.FindNode("songLabel")
    m.artistLabel = m.top.FindNode("artistLabel")
    m.playButton = m.top.FindNode("playButton")

    m.top.observeField("station", "onStationUpdated")
    m.playButton.observeField("buttonSelected", "onPlayPressed")
    print "PlaybackView: Init complete"
End Sub

Sub onStationUpdated()
    print "PlaybackView: Station updated: "; m.top.station.title
    m.albumCoverPoster.uri = m.top.station.poster
    m.stationLabel.text = m.top.station.title
    m.songLabel.text = "Loading..."
    m.artistLabel.text = "Loading..."

    m.metaTask = CreateObject("roSGNode", "FetchMetaTask")
    m.metaTask.xmlUrl = m.top.station.xmlUrl
    m.metaTask.observeField("artist", "onArtistFetched")
    m.metaTask.observeField("songTitle", "onSongTitleFetched")
    m.metaTask.control = "RUN"
    print "PlaybackView: FetchMetaTask started for URL: "; m.top.station.xmlUrl

    m.audioPlayer = m.top.getScene().FindNode("audioPlayer")
    if m.audioPlayer <> invalid
        content = CreateObject("roSGNode", "ContentNode")
        timestamp = (CreateObject("roDateTime")).AsSeconds().ToStr()
        content.url = m.top.station.url + "?t=" + timestamp
        content.streamFormat = m.top.station.format
        content.streamQualities = ["SD"]
        content.streamBitrates = [128]
        content.addHeader("User-Agent", "Roku")
        content.addHeader("Accept", "audio/aac")
        content.addHeader("Connection", "keep-alive")
        m.audioPlayer.content = content
        m.audioPlayer.control = "prebuffer"
        sleep(500)
        m.audioPlayer.control = "play"
        print "PlaybackView: Playing station: "; m.top.station.title
    end if

    m.playButton.setFocus(true)
End Sub

Sub onArtistFetched()
    artist = m.metaTask.artist
    if artist = "" or artist = invalid
        artist = "Unknown Artist"
    end if
    print "PlaybackView: Artist fetched: "; artist
    m.artistLabel.text = artist
End Sub

Sub onSongTitleFetched()
    songTitle = m.metaTask.songTitle
    if songTitle = "" or songTitle = invalid
        songTitle = "Unknown Song"
    end if
    print "PlaybackView: Song title fetched: "; songTitle
    m.songLabel.text = songTitle
End Sub

Sub onPlayPressed()
    print "PlaybackView: Play button pressed"
    m.top.playPressed = true
End Sub