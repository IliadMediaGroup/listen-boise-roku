Sub Init()
    m.artistLabel = m.top.FindNode("artistLabel")
    m.songLabel = m.top.FindNode("songLabel")
    m.top.observeField("artist", "OnArtistChanged")
    m.top.observeField("songTitle", "OnSongTitleChanged")
End Sub

Sub OnArtistChanged()
    m.artistLabel.text = m.top.artist
End Sub

Sub OnSongTitleChanged()
    m.songLabel.text = m.top.songTitle
End Sub