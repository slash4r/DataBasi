-- get the raw album data from .csv file

with raw_albums as (
    select * from read_csv_auto('models/raw/albums.csv')
)

-- Clean and transform album data
select
    album_id,
    -- Trim any whitespace from album titles
    trim(title) as title,
    -- cast release date to a date
    cast(release_date as date) as release_date,
    artist_id
from raw_albums
