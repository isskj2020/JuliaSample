module Users

using MySQL, DataFrames, Random, TimeZones, Nettle

const tableName = "users"

function loadSample(conn, hmac)
    DBInterface.execute(conn, "drop table if exists $tableName")
    try
        MySQL.load(createSample(hmac), conn, tableName)
    catch
    end
end

function register(conn; id, hmac, name, age)
    stmt = DBInterface.prepare(conn, "insert into $tableName values(?, ?, ?, ?, ?)")
    DBInterface.execute(stmt, [ id, hmac, name, age, string(now(localzone())) ])
end

function login(conn; id, hmac)
    stmt = DBInterface.prepare(conn, "select * from users where id = ? and hmac = ?")
    try 
        return DataFrame(DBInterface.execute(stmt, [ id, hmac ]))
    catch e
        @warn "record not found", e
        return Nothing
    end
end


function createSample(hmac)
    users = map(x -> "User #$x", 1:10)
    ids = map(x -> randstring(32), users)
    df = DataFrame(
        id = ids,
        hmac = map(x -> hexdigest(hmac.algorithm, hmac.key, x), ids),
        name = map(x -> x, users),
        age = map(x -> rand(18:65), users),
        created_at = map(x -> string(now(localzone())), users)
    )
    return df
end



end # module root
