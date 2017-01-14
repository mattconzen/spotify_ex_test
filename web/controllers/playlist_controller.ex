defmodule SpotifyExTest.PlaylistController do
  use SpotifyExTest.Web, :controller
  plug SpotifyExTest.Plugs.Auth

  def index(conn, _params) do
    #GET collection
    {:ok, %{ items: playlists }} = Spotify.Playlist.featured(conn)

    #POST
    body = Poison.encode! %{name: "foo", public: true}

    {:ok, playlist} = Spotify.Playlist.create_playlist(conn, "mconz", body)

    #GET playlist
    {:ok, playlist} = Spotify.Playlist.get_playlist(conn, "mconz", playlist.id)

    #PUT
    :ok = Spotify.Playlist.follow_playlist(conn, "spotify", "103Zi2NG06F9qimASDrszv")

    #DELETE
    :ok = Spotify.Playlist.unfollow_playlist(conn, "spotify", "103Zi2NG06F9qimASDrszv")

    body =  Poison.encode!(%{ uris: [ "spotify:track:755MBpLqJqCO87PkoyBBQC", "spotify:track:1hsWu8gT2We6OzjhYGAged" ]})

    {:ok, %{snapshot_id: snapshot}} = Spotify.Playlist.add_tracks(conn, "mconz",playlist.id, body, [])


    render conn, "index.html", playlists: playlists, playlist: playlist, snapshot: snapshot
  end

end
