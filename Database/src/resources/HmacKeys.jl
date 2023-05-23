module HmacKeys

using MySQL, DataFrames, Random, TimeZones, Nettle

const tableName = "hmac_keys"

function loadSample(conn)
    DBInterface.execute(conn, "drop table if exists $tableName")
    MySQL.load(createSample(), conn, tableName)
end


function createSample()
    df = DataFrame(
        id = [ randstring(32) ],
        key = [ randstring(32) ],
        algorithm = [ "sha256" ],
        created_at = [ string(now(localzone())) ],
    )
    return df
end

function fetchKey(conn, algorithm)
    stmt = DBInterface.prepare(conn, "select * from $tableName where algorithm = ?")
    key = DataFrame(DBInterface.execute(stmt, [ algorithm ]))
    return key
end

function hmacDigest(hmac, value)
    return hexdigest(hmac.algorithm, hmac.key, value)
end


end # module root
