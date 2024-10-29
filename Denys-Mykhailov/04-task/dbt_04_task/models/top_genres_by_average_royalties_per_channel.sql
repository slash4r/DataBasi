WITH GenreChannelRoyalties AS (
    SELECT
        g.genre_id,
        ANY_VALUE(g.genre_name_lower) as genre_name,
        dc.channel_id,
        ANY_VALUE(dc.channel_name) AS channel_name,
        COUNT(t.track_id) AS total_tracks,
        SUM(r.amount) AS total_royalties
    FROM
        {{ ref('stg_genres') }} g
        JOIN {{ ref('stg_tracks') }} t ON g.genre_id = t.genre_id
        JOIN {{ ref('stg_royalties') }} r ON t.track_id = r.track_id
        JOIN {{ ref('stg_distributionchannels') }} dc ON r.channel_id = dc.channel_id
    WHERE
        r.payment_date >= CURRENT_DATE - INTERVAL '1 YEAR'
    GROUP BY
        g.genre_id, dc.channel_id
),
AvgRoyaltiesPerTrack AS (
    SELECT
        genre_name,
        channel_name,
        total_royalties / total_tracks AS avg_royalties_per_track,
        ROW_NUMBER() OVER (PARTITION BY channel_name ORDER BY total_royalties / total_tracks DESC) AS rating
    FROM
        GenreChannelRoyalties
)
SELECT
    channel_name,
    genre_name,
    avg_royalties_per_track
FROM
    AvgRoyaltiesPerTrack
WHERE
    rating = 1
ORDER BY
    avg_royalties_per_track DESC
