Sub init()
    print "PlaybackView: Entering init"
    m.audio = m.top.findNode("audioPlayer")
    m.poster = m.top.findNode("stationPoster")
    m.audio.observeField("state", "onAudioStateChange")
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "PlaybackView: Playing stream - Title: " + content.title + ", URL: " + content.streamUrl
        m.poster.uri = content.HDPosterUrl
        audioContent = CreateObject("roSGNode", "ContentNode")
        audioContent.url = content.streamUrl
        audioContent.streamFormat = "mp3" ' Adjust to "aac" if needed
        m.audio.content = audioContent
        m.audio.control = "play"
    else
        print "PlaybackView: Invalid content"
    end if
End Sub

Sub onVisibleChange()
    if m.top.visible = false
        print "PlaybackView: Stopping audio"
        m.audio.control = "stop"
    end if
End Sub

Sub onAudioStateChange()
    state = m.audio.state
    print "PlaybackView: Audio state changed to: " + state
    if state = "error"
        print "PlaybackView: Audio error - Error code: " + m.audio.errorCode.ToStr() + ", Message: " + m.audio.errorMsg
    end if
End Sub