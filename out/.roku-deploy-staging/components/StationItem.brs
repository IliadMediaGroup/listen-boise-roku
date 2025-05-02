Sub init()
    print "StationItem: Entering init"
    m.poster = m.top.FindNode("poster")
    m.title = m.top.FindNode("title")
    if m.poster = invalid or m.title = invalid
        print "StationItem: ERROR: Poster or title not found"
        return
    end if
    print "StationItem: Init complete"
End Sub

Sub onItemContentChanged()
    print "StationItem: Content changed"
    content = m.top.itemContent
    if content = invalid
        print "StationItem: ERROR: Content is invalid"
        m.poster.uri = ""
        m.title.text = "Unknown"
        return
    end if
    m.poster.uri = content.HDPosterUrl
    m.title.text = content.title
    if m.poster.uri = ""
        print "StationItem: WARNING: HDPosterUrl is empty"
        m.poster.uri = "pkg:/images/default.png" ' Fallback image
    end if
    if m.title.text = ""
        print "StationItem: WARNING: Title is empty"
        m.title.text = "Unknown Station"
    end if
    print "StationItem: Set poster: "; m.poster.uri; ", title: "; m.title.text
End Sub