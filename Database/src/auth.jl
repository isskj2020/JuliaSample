using DataFrames


function auth_register(conn; user::User)
    create(conn, user)
end

function auth_login(conn; id, hmac::String)
    sql = """
    SELECT
        *
    FROM users
    WHERE id = ? AND hmac = ?
    """
    df = DataFrame(db_fetch(conn, sql, [ id, hmac ]))
    return User(first(df))
end

function fetch_hmac_key(conn; algorithm::String)
    sql = """
    SELECT
        *
    FROM hmac_keys
    WHERE algorithm = ?
    """
    df = DataFrame(db_fetch(conn, sql, [ algorithm ]))
    return HmacKey(first(df))
end
