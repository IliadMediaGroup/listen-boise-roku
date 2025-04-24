Sub Init()
       print "StreamScene: Entering Init"
       m.audioTask = m.top.FindNode("audioTask")
       if m.audioTask = invalid
           print "ERROR: audioTask not found"
           return
       end if
       m.metadataTask = m.top.FindNode("metadataTask")
       if m.metadataTask = invalid
           print "ERROR: metadataTask not found"
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
       m.playButton.observeFieldScoped("buttonSelected", "OnPlayButton")
       m.stopButton.observeFieldScoped("buttonSelected", "OnStopButton")
       m.timer.observeFieldScoped("fire", "OnTimerFire")
       m.audioTask.observeFieldScoped("playError", "OnPlayError")
       m.metadataTask.observeFieldScoped("metadata", "OnMetadataUpdate")
       m.metadataTask.observeFieldScoped("metadataError", "OnMetadataError")
       m.streamUrl = "https://ice9.securenetsystems.net/KQBLHD3"
       m.metadataUrl = "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3.xml"
       m.streamFormat = "aac"
       print "StreamScene: Updating metadata"
       m.metadataTask.fetchMetadata = m.metadataUrl
       print "StreamScene: Starting timer"
       m.timer.control = "start"
       m.playButton.setFocus(true)
       print "StreamScene: Init complete"
   End Sub

   Sub OnPlayButton()
       print "StreamScene: Play button pressed"
       content = CreateObject("roAssociativeArray")
       content.url = m.streamUrl
       content.streamFormat = m.streamFormat
       m.audioTask.playContent = content
   End Sub

   Sub OnStopButton()
       print "StreamScene: Stop button pressed"
       m.audioTask.stop = true
       m.metadataLabel.text = "Now Playing: Stopped"
   End Sub

   Sub OnPlayError()
       if m.audioTask.playError
           print "StreamScene: Playback error reported"
           m.metadataLabel.text = "Now Playing: Playback Error"
       end if
   End Sub

   Sub OnTimerFire()
       print "StreamScene: Timer fired"
       m.metadataTask.fetchMetadata = m.metadataUrl
   End Sub

   Sub OnMetadataUpdate()
       print "StreamScene: Metadata received: "; m.metadataTask.metadata
       m.metadataLabel.text = m.metadataTask.metadata
   End Sub

   Sub OnMetadataError()
       if m.metadataTask.metadataError <> ""
           print "StreamScene: Metadata error: "; m.metadataTask.metadataError
           m.metadataLabel.text = "Now Playing: " + m.metadataTask.metadataError
       end if
   End Sub