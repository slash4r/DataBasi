CREATE SCHEMA IF NOT EXISTS task_03;
USE `task_03`;

CREATE TABLE Genres (
    genre_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Users (
    user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    artist_id BIGINT UNSIGNED NOT NULL
);

CREATE TABLE Artists (
    artist_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT NOT NULL,
    country VARCHAR(255) NOT NULL,
    profile_picture BLOB NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (user_id)
);

CREATE TABLE Albums (
    album_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    artist_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES Artists (artist_id)
);

CREATE TABLE Tracks (
    track_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration_sec INT NOT NULL,
    lyrics TEXT NOT NULL,
    album_id BIGINT UNSIGNED NOT NULL,
    genre_id BIGINT UNSIGNED NOT NULL,
    status ENUM('pending', 'active', 'inactive') NOT NULL,
    FOREIGN KEY (album_id) REFERENCES Albums (album_id),
    FOREIGN KEY (genre_id) REFERENCES Genres (genre_id)
);

CREATE TABLE DistributionChannels (
    channel_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    website VARCHAR(255) NOT NULL
);

CREATE TABLE Agreements (
    agreement_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    artist_id BIGINT UNSIGNED NOT NULL,
    channel_id BIGINT UNSIGNED NOT NULL,
    agreement_date DATE NOT NULL,
    terms BLOB NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES Artists (artist_id),
    FOREIGN KEY (channel_id) REFERENCES DistributionChannels (channel_id)
);

-- many-to-many relationship
CREATE TABLE Tracks_Channels (
    track_id BIGINT UNSIGNED NOT NULL,
    channel_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (track_id, channel_id),
    FOREIGN KEY (track_id) REFERENCES Tracks (track_id) ON DELETE CASCADE, -- Ensure integrity
    FOREIGN KEY (channel_id) REFERENCES DistributionChannels (channel_id) ON DELETE CASCADE
);

-- many-to-many relationship
CREATE TABLE Tracks_Artists (
    track_id BIGINT UNSIGNED NOT NULL,
    artist_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (track_id, artist_id),
    FOREIGN KEY (track_id) REFERENCES Tracks (track_id) ON DELETE CASCADE, -- Ensure integrity
    FOREIGN KEY (artist_id) REFERENCES Artists (artist_id) ON DELETE CASCADE
);

CREATE TABLE Royalties (
    payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    amount BIGINT NOT NULL,
    payment_date DATE NOT NULL,
    artist_id BIGINT UNSIGNED NOT NULL,
    track_id BIGINT UNSIGNED NOT NULL,
    channel_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES Artists (artist_id),
    FOREIGN KEY (track_id) REFERENCES Tracks (track_id),
    FOREIGN KEY (channel_id) REFERENCES DistributionChannels (channel_id)
);
