module Database

using MySQL, JSON3, JSONTables, Tables

include("resources/Users.jl")
include("resources/HmacKeys.jl")

function createSample()
    conn = DBInterface.connect(MySQL.Connection, "127.0.0.1", "root", "root"; db="testdb", port=9000, protocol=MySQL.API.MYSQL_PROTOCOL_TCP)


    HmacKeys.loadSample(conn)
    hmac = first(HmacKeys.fetchKey(conn, "sha256"))

    Users.loadSample(conn, hmac)

    user = Users.register(
        conn, 
        id = "test id",
        hmac = HmacKeys.hmacDigest(hmac, "test"),
        name = "test user",
        age = 70
    )

    user = Users.login(conn,
         id = "test id",
         hmac = HmacKeys.hmacDigest(hmac, "test")
    )

    # dataframe first row to json
    json = user |> rowtable |> x -> JSON3.write(first(x))
    @show json

end

end # module Database
