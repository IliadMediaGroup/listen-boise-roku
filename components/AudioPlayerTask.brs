Sub Init()
       m.audioPlayer = CreateObject("roAudioPlayer")
       if m.audioPlayer = invalid
           print "AudioPlayerTask: ERROR: Failed to create roAudioPlayer"
           return
       end if
       m.top.observeField("playContent", "OnPlayContent")
       m.top.observeField("stop", "OnStop")
       print "AudioPlayerTask: Initialized"
   End Sub

   Sub OnPlayContent()
       print "AudioPlayerTask: Playing content: "; m.top.playContent.url; " format: "; m.top.playContent.streamFormat
       m.audioPlayer.setContentList([m.top.playContent])
       result = m.audioPlayer.play()
       if result = false
           print "AudioPlayerTask: ERROR: Failed to play stream"
           m.top.playError = true
       else
           print "AudioPlayerTask: Play initiated"
           m.top.playError = false
       end if
   End Sub

   Sub OnStop()
       print "AudioPlayerTask: Stopping"
       m.audioPlayer.stop()
       m.top.playError = false
   End Sub