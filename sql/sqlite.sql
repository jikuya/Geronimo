CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
);
CREATE TABLE IF NOT EXISTS likes (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    from_id      INTEGER,
    to_id        INTEGER,
    to_name      TEXT,
    to_explain   TEXT,
    like_status  INTEGER
);
CREATE TABLE IF NOT EXISTS like_status_mst (
    id           INTEGER PRIMARY KEY,
    text         TEXT
);
INSERT OR IGNORE INTO like_status_mst ('id', 'text') VALUES
    (1, 'が好き'),
    (2, 'とデートしたい'),
    (3, 'とランチしたい'),
    (4, 'が何か気になる');
