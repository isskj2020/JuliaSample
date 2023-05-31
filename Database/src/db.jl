using MySQL, DataFrames

db_connect() = DBInterface.connect(MySQL.Connection, "127.0.0.1", "root", "root"; db="testdb", port=9000, protocol=MySQL.API.MYSQL_PROTOCOL_TCP)
db_close(conn) = DBInterface.close!(conn)


function db_insert(conn, df::DataFrame, table::String)
    keys = join(map(x -> "?", names(df)), ",")
    for row in eachrow(df)
        sql = "INSERT INTO $table VALUES ( $keys )"
        db_exec(conn, sql, Vector(row))
    end
    return df
end

function db_delete(conn, table::String, id::String)
    sql = "DELETE FROM $table WHERE id = ?"
    return db_exec(conn, sql, [ id ])
end


function db_fetch(conn, sql::String, params::Vector)
    stmt = DBInterface.prepare(conn, sql)
    return DBInterface.execute(stmt, params)
end

function db_fetch(conn, sql::String)
    return DBInterface.execute(conn, sql)
end

function db_exec(conn, sql::String)
    return DBInterface.execute(conn, sql)
end

function db_exec(conn, sql::String, params::Vector)
    stmt = DBInterface.prepare(conn, sql)
    return DBInterface.execute(stmt, params)
end
