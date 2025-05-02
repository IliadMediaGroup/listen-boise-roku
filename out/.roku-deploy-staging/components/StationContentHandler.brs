Function GetContent()
    content = CreateObject("roSGNode", "ContentNode")
    for each item in m.top.content.GetChildren(-1, 0)
        child = content.CreateChild("ContentNode")
        child.title = item.title
        child.HDPosterUrl = item.HDPosterUrl
        child.SDPosterUrl = item.SDPosterUrl
        child.url = item.url
        child.streamFormat = item.streamFormat
        child.xmlUrl = item.xmlUrl
    end for
    return content
End Function