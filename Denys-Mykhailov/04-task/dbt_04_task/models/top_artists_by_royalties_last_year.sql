WITH ArtistRoyalties AS (
    SELECT
        a.artist_id,
        ANY_VALUE(a.artist_name) AS artist_name,
        SUM(r.amount) AS total_royalties
    FROM
        {{ ref('stg_artists') }} a
        JOIN {{ ref('stg_royalties') }} r ON a.artist_id = r.artist_id
    WHERE
        r.payment_date >= CURRENT_DATE - INTERVAL '1 YEAR'
    GROUP BY
        a.artist_id
)
SELECT
    artist_name,
    total_royalties
FROM
    ArtistRoyalties
ORDER BY
    total_royalties DESC
