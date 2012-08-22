CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
);
CREATE TABLE IF NOT EXISTS users (
    id           INTEGER PRIMARY KEY,
    name         TEXT,
    token        TEXT
);
CREATE TABLE IF NOT EXISTS likes (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    from_id      INTEGER,
    from_name    TEXT,
    to_id        INTEGER,
    to_name      TEXT
);
