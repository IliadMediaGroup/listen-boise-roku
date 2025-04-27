sub init()
    m.top.functionName = "fetchMeta"
end sub

sub fetchMeta()
    print "FetchMetaTask: Starting fetch for URL: "; m.top.xmlUrl

    ' Create roUrlTransfer for fetching XML
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.InitClientCertificates()
    urlTransfer.SetUrl(m.top.xmlUrl)

    ' Fetch the XML
    xmlData = urlTransfer.GetToString()
    if xmlData <> invalid and xmlData <> ""
        print "FetchMetaTask: XML fetched successfully"
        xml = CreateObject("roXMLElement")
        if xml.Parse(xmlData)
            ' Log the root element to confirm structure
            print "FetchMetaTask: Root element: "; xml.GetName()

            ' Try to extract the artist and song title directly under <playlist>
            if xml.GetName() = "playlist"
                ' Get all child nodes of the root element
                childNodes = xml.GetChildNodes()
                artistFound = false
                songTitleFound = false
                for each node in childNodes
                    if node.GetName() = "artist"
                        artistText = node.GetText()
                        if artistText <> invalid and artistText <> ""
                            print "FetchMetaTask: Artist found: "; artistText
                            m.top.artist = artistText
                            artistFound = true
                        else
                            print "FetchMetaTask: Artist tag found but empty"
                            m.top.artist = "Unknown"
                            artistFound = true
                        end if
                    else if node.GetName() = "title"
                        songTitleText = node.GetText()
                        if songTitleText <> invalid and songTitleText <> ""
                            print "FetchMetaTask: Song title found: "; songTitleText
                            m.top.songTitle = songTitleText
                            songTitleFound = true
                        else
                            print "FetchMetaTask: Song title tag found but empty"
                            m.top.songTitle = "Unknown"
                            songTitleFound = true
                        end if
                    end if
                    ' Exit loop if both artist and song title are found
                    if artistFound and songTitleFound
                        exit for
                    end if
                end for
                if not artistFound
                    print "FetchMetaTask: Artist tag not found under playlist"
                    m.top.artist = "Unknown"
                end if
                if not songTitleFound
                    print "FetchMetaTask: Song title tag not found under playlist"
                    m.top.songTitle = "Unknown"
                end if
            else
                print "FetchMetaTask: Root element is not 'playlist'"
                m.top.artist = "Unknown"
                m.top.songTitle = "Unknown"
            end if
        else
            print "FetchMetaTask: Failed to parse XML"
            m.top.artist = "Error parsing XML"
            m.top.songTitle = "Error parsing XML"
        end if
    else
        print "FetchMetaTask: Failed to fetch XML"
        m.top.artist = "Error fetching data"
        m.top.songTitle = "Error fetching data"
    end if
end sub