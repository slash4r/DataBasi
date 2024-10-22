USE `task_03`;

-- Table: Genres
ALTER TABLE Genres
COMMENT = 'Table to store music genres';

ALTER TABLE Genres
MODIFY COLUMN genre_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each genre',
MODIFY COLUMN name VARCHAR(255) NOT NULL COMMENT 'Name of the genre';

-- Table: Users
ALTER TABLE Users
COMMENT = 'Table to store user information, including email and artist association';

ALTER TABLE Users
MODIFY COLUMN user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each user',
MODIFY COLUMN email VARCHAR(255) NOT NULL COMMENT 'Email address of the user, must be unique',
MODIFY COLUMN artist_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the associated artist, if applicable';

-- Table: Artists
ALTER TABLE Artists
COMMENT = 'Table to store artist information, including biography and associated user';

ALTER TABLE Artists
MODIFY COLUMN artist_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each artist',
MODIFY COLUMN name VARCHAR(255) NOT NULL COMMENT 'Name of the artist',
MODIFY COLUMN bio TEXT NOT NULL COMMENT 'Biography of the artist',
MODIFY COLUMN country VARCHAR(255) NOT NULL COMMENT 'Country of origin for the artist',
MODIFY COLUMN profile_picture BLOB NOT NULL COMMENT 'Profile picture of the artist',
MODIFY COLUMN user_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the associated user';

-- Table: Albums
ALTER TABLE Albums
COMMENT = 'Table to store album information';

ALTER TABLE Albums
MODIFY COLUMN album_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each album',
MODIFY COLUMN title VARCHAR(255) NOT NULL COMMENT 'Title of the album',
MODIFY COLUMN release_date DATE NOT NULL COMMENT 'Release date of the album',
MODIFY COLUMN artist_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the artist who created the album';

-- Table: Tracks
ALTER TABLE Tracks
COMMENT = 'Table to store information about individual tracks';

ALTER TABLE Tracks
MODIFY COLUMN track_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each track',
MODIFY COLUMN title VARCHAR(255) NOT NULL COMMENT 'Title of the track',
MODIFY COLUMN duration_sec INT NOT NULL COMMENT 'Duration of the track in seconds',
MODIFY COLUMN lyrics TEXT NOT NULL COMMENT 'Lyrics of the track',
MODIFY COLUMN album_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the album this track belongs to',
MODIFY COLUMN genre_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the genre of this track',
MODIFY COLUMN status ENUM('pending', 'active', 'inactive') NOT NULL COMMENT 'Status of the track: pending, active, or inactive';

-- Table: DistributionChannels
ALTER TABLE DistributionChannels
COMMENT = 'Table to store information about distribution channels';

ALTER TABLE DistributionChannels
MODIFY COLUMN channel_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each distribution channel',
MODIFY COLUMN name VARCHAR(255) NOT NULL COMMENT 'Name of the distribution channel',
MODIFY COLUMN website VARCHAR(255) NOT NULL COMMENT 'Website of the distribution channel';

-- Table: Agreements
ALTER TABLE Agreements
COMMENT = 'Table to store agreements between artists and distribution channels';

ALTER TABLE Agreements
MODIFY COLUMN agreement_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each agreement',
MODIFY COLUMN artist_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the artist involved in the agreement',
MODIFY COLUMN channel_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the distribution channel involved in the agreement',
MODIFY COLUMN agreement_date DATE NOT NULL COMMENT 'Date the agreement was made',
MODIFY COLUMN terms BLOB NOT NULL COMMENT 'Terms of the agreement';

-- Table: Tracks_Channels (Many-to-Many)
ALTER TABLE Tracks_Channels
COMMENT = 'Link table to represent the many-to-many relationship between tracks and distribution channels';

ALTER TABLE Tracks_Channels
MODIFY COLUMN track_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the track',
MODIFY COLUMN channel_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the distribution channel';

-- Table: Tracks_Artists (Many-to-Many)
ALTER TABLE Tracks_Artists
COMMENT = 'Link table to represent the many-to-many relationship between tracks and artists';

ALTER TABLE Tracks_Artists
MODIFY COLUMN track_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the track',
MODIFY COLUMN artist_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the artist';

-- Table: Royalties
ALTER TABLE Royalties
COMMENT = 'Table to store information about royalty payments to artists';

ALTER TABLE Royalties
MODIFY COLUMN payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each royalty payment',
MODIFY COLUMN amount BIGINT NOT NULL COMMENT 'Amount of the royalty payment',
MODIFY COLUMN payment_date DATE NOT NULL COMMENT 'Date the royalty payment was made',
MODIFY COLUMN artist_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the artist receiving the royalty payment',
MODIFY COLUMN track_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the track generating the royalty payment',
MODIFY COLUMN channel_id BIGINT UNSIGNED NOT NULL COMMENT 'Identifier of the distribution channel involved in the royalty payment';

-- with the assist of ChatGPT
