USE task_04;

-- first mart select
-- Top Earning Tracks and Artists by Royalties

SELECT
    t.title AS track_title,
    a.name AS artist_name,
    SUM(r.amount) AS total_royalties
FROM
    Tracks t
    JOIN Royalties r ON t.track_id = r.track_id
    JOIN Artists a ON r.artist_id = a.artist_id
GROUP BY
    t.track_id, a.artist_id
ORDER BY
    total_royalties DESC
LIMIT 10;


-- second mart select
-- Top Active Tracks and Artists by Distribution Channels

WITH ActiveTracks AS (
    SELECT
        t.track_id,
        t.title,
        a.artist_id,
        a.name AS artist_name
    FROM
        Tracks t
        JOIN Tracks_Artists ta ON t.track_id = ta.track_id
        JOIN Artists a ON ta.artist_id = a.artist_id
    WHERE
        t.status = 'active'
),
TracksPerChannel AS (
    SELECT
        at.artist_id,
        at.artist_name,
        at.track_id,
        COUNT(tc.channel_id) AS channel_count
    FROM
        ActiveTracks at
        JOIN Tracks_Channels tc ON at.track_id = tc.track_id
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
LIMIT 5;

-- third mart select
-- Top Distribution Channels by Total Royalties

WITH ChannelRoyalties AS (
    SELECT
        dc.channel_id,
        dc.name AS channel_name,
        SUM(r.amount) AS total_royalties
    FROM
        DistributionChannels dc
        JOIN Royalties r ON dc.channel_id = r.channel_id
    WHERE
        r.payment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY
        dc.channel_id
)
SELECT
    channel_name,
    total_royalties
FROM
    ChannelRoyalties
ORDER BY
    total_royalties DESC;

-- fourth mart select
-- Top Artists by Total Royalties over the Last Year

WITH ArtistRoyalties AS (
    SELECT
        a.artist_id,
        a.name AS artist_name,
        SUM(r.amount) AS total_royalties
    FROM
        Artists a
        JOIN Royalties r ON a.artist_id = r.artist_id
    WHERE
        -- payment date is within the last year
        r.payment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY
        a.artist_id
)
SELECT
    artist_name,
    total_royalties
FROM
    ArtistRoyalties
ORDER BY
    total_royalties DESC;

-- fifth mart select
-- Top Genres by Average Royalties for each Distribution Channel

WITH GenreChannelRoyalties AS (
    SELECT
        g.genre_id,
        g.name AS genre_name,
        dc.channel_id,
        dc.name AS channel_name,
        COUNT(t.track_id) AS total_tracks,
        SUM(r.amount) AS total_royalties
    FROM
        Genres g
        JOIN Tracks t ON g.genre_id = t.genre_id
        JOIN Royalties r ON t.track_id = r.track_id
        JOIN DistributionChannels dc ON r.channel_id = dc.channel_id
    WHERE
        r.payment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
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
    avg_royalties_per_track DESC;
