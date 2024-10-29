WITH ActiveTracks AS (
    SELECT
        t.track_id,
        t.track_title,
        a.artist_id,
        a.artist_name
    FROM
        {{ ref('stg_tracks') }} t
        JOIN {{ ref('stg_tracks_artists') }} ta ON t.track_id = ta.track_id
        JOIN {{ ref('stg_artists') }} a ON ta.artist_id = a.artist_id
    WHERE
        t.track_status = 'Active'
),
TracksPerChannel AS (
    SELECT
        at.artist_id,
        ANY_VALUE(at.artist_name) AS artist_name,
        at.track_id,
        COUNT(tc.channel_id) AS channel_count
    FROM
        ActiveTracks at
        JOIN {{ ref('stg_tracks_channels') }} tc ON at.track_id = tc.track_id
    GROUP BY
        at.artist_id, at.track_id
)
SELECT
    artist_name,
    COUNT(track_id) AS active_tracks_count,
    SUM(channel_count) AS total_channels
FROM
    TracksPerChannel
GROUP BY
    artist_id, artist_name
ORDER BY
    active_tracks_count DESC