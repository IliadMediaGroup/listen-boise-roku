Sub Init()
       m.top.observeField("fetchMetadata", "OnFetchMetadata")
       print "MetadataTask: Initialized"
   End Sub

   Sub OnFetchMetadata()
       print "MetadataTask: Fetching metadata from "; m.top.fetchMetadata
       xfer = CreateObject("roURLTransfer")
       if xfer = invalid
           print "MetadataTask: ERROR: Failed to create roURLTransfer"
           m.top.metadataError = "Network Error"
           return
       end if
       xfer.setUrl(m.top.fetchMetadata)
       response = xfer.getToString()
       if response = ""
           print "MetadataTask: ERROR: No response from metadata URL"
           m.top.metadataError = "Network Error"
           return
       end if
       xml = CreateObject("roXMLElement")
       if not xml.parse(response)
           print "MetadataTask: ERROR: Failed to parse XML"
           m.top.metadataError = "Metadata Error"
           return
       end if
       title = xml.title.getText()
       artist = xml.artist.getText()
       if title <> "" and artist <> ""
           m.top.metadata = "Now Playing: " + title + " by " + artist
           print "MetadataTask: Metadata updated: "; m.top.metadata
       else
           m.top.metadata = "Now Playing: Unknown"
           print "MetadataTask: Metadata unknown"
       end if
       m.top.metadataError = ""
   End Sub