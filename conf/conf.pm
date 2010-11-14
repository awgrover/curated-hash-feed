{
dbi => # dbi connect args
        [ "dbi:SQLite:dbname=db/db.sqlite","","" ],
            dbi_init => [ 'PRAGMA foreign_keys = ON;' ],
}
