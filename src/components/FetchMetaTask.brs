sub init()
    m.top.functionName = "fetchMeta"
    m.top.artist = ""
    m.top.songTitle = ""
    m.top.songHistory = []
end sub

sub fetchMeta()
    print "FetchMetaTask: Starting fetch for URL: "; m.top.jsonUrl

    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.InitClientCertificates()
    urlTransfer.SetUrl(m.top.jsonUrl)

    jsonData = urlTransfer.GetToString()
    if jsonData <> invalid and jsonData <> ""
        print "FetchMetaTask: JSON fetched successfully"
        json = ParseJson(jsonData)
        if json <> invalid and json.playHistory <> invalid and json.playHistory.song <> invalid and json.playHistory.song.Count() > 0
            nowPlaying = json.playHistory.song[0]
            m.top.artist = nowPlaying.artist
            m.top.songTitle = nowPlaying.title
            m.top.songHistory = json.playHistory.song
            print "FetchMetaTask: Now playing - Artist: "; nowPlaying.artist; ", Title: "; nowPlaying.title
            print "FetchMetaTask: Song history fetched, count: "; json.playHistory.song.Count()
        else
            print "FetchMetaTask: Invalid JSON structure or no songs found"
            m.top.artist = "Unknown Artist"
            m.top.songTitle = "Unknown Song"
            m.top.songHistory = []
        end if
    else
        print "FetchMetaTask: Failed to fetch JSON data"
        m.top.artist = "Unknown Artist"
        m.top.songTitle = "Unknown Song"
        m.top.songHistory = []
    end if
end sub