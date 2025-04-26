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

            ' Try to extract the artist directly under <playlist>
            if xml.GetName() = "playlist"
                ' Get all child nodes of the root element
                childNodes = xml.GetChildNodes()
                artistFound = false
                for each node in childNodes
                    if node.GetName() = "artist"
                        artistText = node.GetText()
                        if artistText <> invalid and artistText <> ""
                            print "FetchMetaTask: Artist found: "; artistText
                            m.top.artist = artistText
                            artistFound = true
                            exit for
                        else
                            print "FetchMetaTask: Artist tag found but empty"
                            m.top.artist = "Unknown"
                            artistFound = true
                            exit for
                        end if
                    end if
                end for
                if not artistFound
                    print "FetchMetaTask: Artist tag not found under playlist"
                    m.top.artist = "Unknown"
                end if
            else
                print "FetchMetaTask: Root element is not 'playlist'"
                m.top.artist = "Unknown"
            end if
        else
            print "FetchMetaTask: Failed to parse XML"
            m.top.artist = "Error parsing XML"
        end if
    else
        print "FetchMetaTask: Failed to fetch XML"
        m.top.artist = "Error fetching data"
    end if
end sub