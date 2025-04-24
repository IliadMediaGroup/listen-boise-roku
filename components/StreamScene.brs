Sub Init()
         m.audio = CreateObject("roAudioPlayer")
         m.metadataLabel = m.top.FindNode("metadataLabel")
         m.playButton = m.top.FindNode("playButton")
         m.stopButton = m.top.FindNode("stopButton")
         m.timer = m.top.FindNode("metadataTimer")
         
         m.playButton.ObserveField("buttonSelected", "OnPlayButton")
         m.stopButton.ObserveField("buttonSelected", "OnStopButton")
         m.timer.ObserveField("fire", "OnTimerFire")
         
         m.streamUrl = "https://ice9.securenetsystems.net/KQBLHD3"
         m.metadataUrl = "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3.xml"
         
         UpdateMetadata()
         m.timer.control = "start"
     End Sub
     
     Sub OnPlayButton()
         content = CreateObject("roAssociativeArray")
         content.url = m.streamUrl
         content.streamFormat = "mp3" ' Adjust if AAC or HLS
         m.audio.SetContentList([content])
         m.audio.Play()
     End Sub
     
     Sub OnStopButton()
         m.audio.Stop()
     End Sub
     
     Sub OnTimerFire()
         UpdateMetadata()
     End Sub
     
     Sub UpdateMetadata()
         xfer = CreateObject("roURLTransfer")
         xfer.SetUrl(m.metadataUrl)
         response = xfer.GetToString()
         
         xml = CreateObject("roXMLElement")
         if xml.Parse(response)
             title = xml.title.GetText()
             artist = xml.artist.GetText()
             if title <> "" and artist <> ""
                 m.metadataLabel.text = "Now Playing: " + title + " by " + artist
             else
                 m.metadataLabel.text = "Now Playing: Unknown"
             end if
         else
             m.metadataLabel.text = "Now Playing: Metadata Error"
         end if
     End Sub
    