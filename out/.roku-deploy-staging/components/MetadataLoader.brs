Sub Init()
    m.top.functionName = "fetchMetadata"
    m.http = CreateObject("roUrlTransfer")
    m.http.SetCertificatesFile("common:/certs/ca-bundle.crt")
    m.http.InitClientCertificates()
    m.http.AddHeader("User-Agent", "Roku")
    m.http.AddHeader("Accept", "application/json")
End Sub

Sub fetchMetadata()
    print "MetadataLoader: Starting fetch for URL: "; m.top.url
    m.http.SetUrl(m.top.url)
    response = m.http.GetToString()
    
    if response = "" or response = invalid
        print "MetadataLoader: Failed to fetch content"
        setDefaultContent()
        return
    end if
    print "MetadataLoader: Response received, length: "; response.Len()
    
    ' Check for HTML response
    if response.Instr(0, "<html") >= 0 or response.Instr(0, "<!DOCTYPE html") >= 0
        print "MetadataLoader: Response is HTML, not JSON"
        setDefaultContent()
        return
    end if
    
    ' Parse JSON
    json = ParseJson(response)
    if json = invalid or json.playHistory = invalid or json.playHistory.song = invalid or json.playHistory.song.Count() = 0
        print "MetadataLoader: Invalid JSON structure"
        setDefaultContent()
        return
    end if
    
    ' Extract current song (first entry)
    currentSong = json.playHistory.song[0]
    artist = "Unknown"
    title = "Unknown"
    if currentSong.artist <> invalid and currentSong.artist <> ""
        artist = currentSong.artist
    end if
    if currentSong.title <> invalid and currentSong.title <> ""
        title = currentSong.title
    end if
    
    ' Set ContentNode for PlaybackView
    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.AddFields({ artist: artist, songTitle: title })
    m.top.content = contentNode
    print "MetadataLoader: Parsed artist: "; artist; ", songTitle: "; title
End Sub

Sub setDefaultContent()
    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.AddFields({ artist: "Unknown", songTitle: "Unknown" })
    m.top.content = contentNode
    print "MetadataLoader: Set default artist and songTitle to Unknown"
End Sub