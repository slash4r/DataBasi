SELECT
    track_id,
    artist_id
FROM {{ ref('raw_tracks_artists') }}