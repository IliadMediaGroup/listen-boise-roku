Sub Init()
    print "StreamScene: Entering Init"
    m.audio = CreateObject("roAudioPlayer")
    if m.audio = invalid
        print "ERROR: Failed to create roAudioPlayer"
        return
    end if
    
    m.metadataLabel = m.top.FindNode("metadataLabel")
    if m.metadataLabel = invalid
        print "ERROR: metadataLabel not found"
        return
    end if
    
    m.playButton = m.top.FindNode("playButton")
    if m.playButton = invalid
        print "ERROR: playButton not found"
        return
    end if
    
    m.stopButton = m.top.FindNode("stopButton")
    if m.stopButton = invalid
        print "ERROR: stopButton not found"
        return
    end if
    
    m.timer = m.top.FindNode("metadataTimer")
    if m.timer = invalid
        print "ERROR: metadataTimer not found"
        return
    end if
    
    print "StreamScene: Setting observers"
    m.playButton.ObserveField("buttonSelected", "OnPlayButton")
    m.stopButton.ObserveField("buttonSelected", "OnStopButton")
    m.timer.ObserveField("fire", "OnTimerFire")
    
    m.streamUrl = "https://streamdb6web.securenetsystems.net/cirrusencore/KQBLHD3"
    m.metadataUrl = "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3.xml"
    
    print "StreamScene: Updating metadata"
    UpdateMetadata()
    
    print "StreamScene: Starting timer"
    m.timer.control = "start"
    
    print "StreamScene: Init complete"
End Sub

Sub OnPlayButton()
    print "StreamScene: Play button pressed"
    content = CreateObject("roAssociativeArray")
    content.url = m.streamUrl
    content.streamFormat = "mp3" ' Test AAC or HLS if needed
    m.audio.SetContentList([content])
    m.audio.Play()
    print "StreamScene: Play initiated"
End Sub

Sub OnStopButton()
    print "StreamScene: Stop button pressed"
    m.audio.Stop()
    print "StreamScene: Stopped"
End Sub

Sub OnTimerFire()
    print "StreamScene: Timer fired"
    UpdateMetadata()
End Sub

Sub UpdateMetadata()
    print "StreamScene: Updating metadata from "; m.metadataUrl
    xfer = CreateObject("roURLTransfer")
    if xfer = invalid
        print "ERROR: Failed to create roURLTransfer"
        m.metadataLabel.text = "Now Playing: Network Error"
        return
    end if
    
    xfer.SetUrl(m.metadataUrl)
    response = xfer.GetToString()
    if response = ""
        print "ERROR: No response from metadata URL"
        m.metadataLabel.text = "Now Playing: Network Error"
        return
    end if
    
    xml = CreateObject("roXMLElement")
    if not xml.Parse(response)
        print "ERROR: Failed to parse XML"
        m.metadataLabel.text = "Now Playing: Metadata Error"
        return
    end if
    
    title = xml.title.GetText()
    artist = xml.artist.GetText()
    if title <> "" and artist <> ""
        m.metadataLabel.text = "Now Playing: " + title + " by " + artist
        print "StreamScene: Metadata updated: "; m.metadataLabel.text
    else
        m.metadataLabel.text = "Now Playing: Unknown"
        print "StreamScene: Metadata unknown"
    end if
End Sub