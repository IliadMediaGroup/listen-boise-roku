Sub Init()
    print "PodcastsView: Entering init"
    m.podcastGrid = m.top.FindNode("podcastGrid")
    m.top.selectedPodcast = invalid

    if m.podcastGrid = invalid
        print "ERROR: PodcastsView - podcastGrid not found"
        return
    end if

    m.podcastGrid.visible = true
    m.podcastGrid.numColumns = 2
    m.podcastGrid.itemSize = "[300, 150]"
    m.podcastGrid.itemSpacing = "[20, 20]"
    m.podcastGrid.translation = "[60, 50]"

    print "PodcastsView: Loading podcast content"
    LoadPodcastContent()
    print "PodcastsView: podcastGrid content loaded"

    print "PodcastsView: Setting observers"
    m.podcastGrid.observeField("itemSelected", "OnPodcastGridItemSelected")
    m.top.observeField("keyEvent", "onKeyEvent")

    m.podcastGrid.setFocus(true)
    m.podcastGrid.itemFocused = 0
    print "PodcastsView: podcastGrid initial state - focused item: "; m.podcastGrid.itemFocused; ", hasFocus: "; m.podcastGrid.hasFocus()
    print "PodcastsView: Init complete"
End Sub

Sub LoadPodcastContent()
    print "PodcastsView: Loading podcast content"
    m.podcasts = [
        {title: "Diabetes Oasis", rssUrl: "https://feeds.acast.com/public/shows/675236792dd88df1321d6b28"},
        {title: "Up Next", rssUrl: "https://feeds.acast.com/public/shows/675237e3d40c6cb2e0112347"},
        {title: "The Marketing Expedition", rssUrl: "https://static.adorilabs.com/feed/marketing-expedition-podcast-with-rhea-allen-peppershock-media-7682.xml"},
        {title: "Brain Over Belly", rssUrl: "https://feeds.acast.com/public/shows/6750f308f318f34867692de2"},
        {title: "BoiseDev Podcast", rssUrl: "https://feeds.acast.com/public/shows/6750d305aeaa2d78dfb137bf"},
        {title: "Hey Morton On Demand", rssUrl: "https://feeds.acast.com/public/shows/674e35774cf32e7b944eccd3"},
        {title: "Rick and Carly On Demand", rssUrl: "https://feeds.acast.com/public/shows/675237266af55bd515d4d2d7"},
        {title: "Joey and Lauren On Demand", rssUrl: "https://feeds.acast.com/public/shows/6750bbfe0ee2b79e33134fad"}
    ]

    content = CreateObject("roSGNode", "ContentNode")
    for each podcast in m.podcasts
        child = content.CreateChild("ContentNode")
        child.title = podcast.title
        child.url = podcast.rssUrl
        child.HDPosterUrl = "pkg:/images/podcast_default.png"
        child.SDPosterUrl = "pkg:/images/podcast_default.png"
        print "PodcastsView: Added podcast to grid: "; podcast.title
    end for
    m.podcastGrid.content = content
    print "PodcastsView: podcastGrid content loaded, item count: "; m.podcastGrid.content.GetChildCount()
End Sub

Sub OnPodcastGridItemSelected()
    selectedIndex = m.podcastGrid.itemSelected
    print "PodcastsView: podcastGrid itemSelected: "; selectedIndex; ", Focused: "; m.podcastGrid.itemFocused; ", Grid hasFocus: "; m.podcastGrid.hasFocus()
    if selectedIndex >= 0 and selectedIndex < m.podcasts.Count()
        print "PodcastsView: Fetching episodes for podcast: "; m.podcasts[selectedIndex].title
        m.fetchTask = CreateObject("roSGNode", "FetchPodcastTask")
        m.fetchTask.rssUrl = m.podcasts[selectedIndex].rssUrl
        m.fetchTask.observeField("episodes", "OnEpisodesFetched")
        m.fetchTask.control = "RUN"
    else
        print "PodcastsView: Invalid podcast index: "; selectedIndex
    end if
End Sub

Sub OnEpisodesFetched()
    episodes = m.fetchTask.episodes
    if episodes = invalid or episodes.Count() = 0
        print "PodcastsView: No episodes fetched"
        return
    end if
    print "PodcastsView: Episodes fetched, count: "; episodes.Count()
    m.top.selectedPodcast = episodes[0] ' Select the first episode for simplicity
End Sub

Function onKeyEvent(key as String, press as Boolean) As Boolean
    print "PodcastsView: Key event - Key: "; key; ", Press: "; press; ", podcastGrid hasFocus: "; m.podcastGrid.hasFocus()
    if not press
        return false
    end if

    if m.podcastGrid.visible and m.podcastGrid.hasFocus()
        if key = "left"
            focusedIndex = m.podcastGrid.itemFocused
            print "PodcastsView: Left key pressed in podcastGrid, focused index: "; focusedIndex
            if focusedIndex = 0 or focusedIndex = 2
                print "PodcastsView: In leftmost column, moving focus to tabGroup"
                tabGroup = m.top.getScene().FindNode("tabGroup")
                if tabGroup <> invalid
                    tabGroup.setFocus(true)
                    podcastsTab = tabGroup.FindNode("podcastsTab")
                    if podcastsTab <> invalid
                        podcastsTab.setFocus(true)
                    end if
                end if
                return true
            end if
        else if key = "OK"
            focusedIndex = m.podcastGrid.itemFocused
            print "PodcastsView: OK key pressed in podcastGrid, index: "; focusedIndex
            if m.podcastGrid.hasFocus()
                print "PodcastsView: Triggering podcast selection"
                OnPodcastGridItemSelected()
                return true
            end if
        end if
    end if
    return false
End Function