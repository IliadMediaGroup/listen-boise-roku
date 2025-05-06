sub Init()
    ? "StationGridScene Init"

    ' Bind the selection handler so it doesn't crash when an item is selected
    m.top.ObserveField("itemSelected", "OnItemSelected")

    ' Create a ContentNode container for items
    contentNode = CreateObject("roSGNode", "ContentNode")

    ' Sample station items with local images
    stations = [
        {
            Title: "Alt 105.5"
            ShortDescriptionLine1: "Boise's Alternative"
            HDPosterUrl: "pkg:/images/alt.png"
            StreamUrl: "https://stream-url-1"
        },
        {
            Title: "Kool 101.5"
            ShortDescriptionLine1: "Classic Hits"
            HDPosterUrl: "pkg:/images/kool.png"
            StreamUrl: "https://stream-url-2"
        }
    ]

    for each station in stations
        item = CreateObject("roSGNode", "ContentNode")
        item.Title = station.Title
        item.ShortDescriptionLine1 = station.ShortDescriptionLine1
        item.HDPosterUrl = station.HDPosterUrl
        item.StreamUrl = station.StreamUrl
        contentNode.appendChild(item)
    end for

    ' Assign to GridView's content field
    m.top.content = contentNode
end sub

sub OnItemSelected(event as Object)
    index = event.GetData()
    selectedItem = m.top.content.getChild(index)
    ? "Selected station: " + selectedItem.Title
    ? "Stream URL: " + selectedItem.StreamUrl

    ' TODO: launch playback screen using selectedItem.StreamUrl
end sub
