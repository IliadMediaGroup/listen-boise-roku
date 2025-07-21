sub init()
    m.top.functionName = "fetchPodcast"
    m.top.episodes = []
end sub

sub fetchPodcast()
    print "FetchPodcastTask: Starting fetch for RSS URL: "; m.top.rssUrl

    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.InitClientCertificates()
    urlTransfer.SetUrl(m.top.rssUrl)

    xmlData = urlTransfer.GetToString()
    if xmlData <> invalid and xmlData <> ""
        print "FetchPodcastTask: RSS fetched successfully"
        xml = CreateObject("roXMLElement")
        if xml.Parse(xmlData)
            episodes = []
            for each item in xml.channel.item
                episode = {}
                episode.title = item.title.GetText()
                episode.url = item.enclosure@url
                episodes.Push(episode)
                print "FetchPodcastTask: Added episode: "; episode.title
            end for
            m.top.episodes = episodes
            print "FetchPodcastTask: Episodes fetched, count: "; episodes.Count()
        else
            print "FetchPodcastTask: Failed to parse RSS XML"
            m.top.episodes = []
        end if
    else
        print "FetchPodcastTask: Failed to fetch RSS data"
        m.top.episodes = []
    end if
end sub