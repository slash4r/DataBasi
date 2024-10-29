SELECT
    ANY_VALUE(t.track_title) AS track_title,
    ANY_VALUE(a.artist_name) AS artist_name,
    SUM(r.amount) AS total_royalties
FROM
    {{ ref('stg_tracks') }} t
    JOIN {{ ref('stg_royalties') }} r ON t.track_id = r.track_id
    JOIN {{ ref('stg_artists') }} a ON r.artist_id = a.artist_id
GROUP BY
    t.track_id, a.artist_id
ORDER BY
    total_royalties DESC
