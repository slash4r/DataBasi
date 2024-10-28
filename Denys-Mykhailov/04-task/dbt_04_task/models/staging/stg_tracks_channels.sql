SELECT
    track_id,
    channel_id
FROM {{ ref('raw_tracks_channels') }}