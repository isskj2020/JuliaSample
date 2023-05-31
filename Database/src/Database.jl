module Database

using JSON3, JSONTables, Tables, Nettle

include("deps.jl")


function test_hmac_auth()
    conn = db_connect()

    db_exec(conn, "DELETE FROM hmac_keys")
    db_exec(conn, "DELETE FROM users")

    hmac = HmacKey(
        key = randstring(32),
        algorithm = "sha256"
    )
    create(conn, hmac)

    hmac = fetch_hmac_key(conn, algorithm = "sha256")
    @show hmac

    auth_register(conn,
        user = User(
            id = "test_id",
            hmac = hexdigest(hmac.algorithm, hmac.key, "test"),
            name = "test user",
            age = 70
        )
    )

    user = auth_login(conn,
        id = "test_id",
        hmac = hexdigest(hmac.algorithm, hmac.key, "test")
    )
    @show user

    json = JSON3.write(user)

end

end # module root
