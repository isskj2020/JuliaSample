using Parameters, DataFrames, Random, TimeZones

@with_kw mutable struct User
    id::String = randstring(32)
    hmac::String
    name::String
    age::Int64
    updated_at::String = string(now(localzone()))
end

function User(row::DataFrameRow)
    return User(
        id = row.id,
        hmac = row.hmac,
        name = row.name,
        age = row.age,
        updated_at = row.updated_at
    )
end

create(conn, obj::User) = db_insert(conn, DataFrame([ obj ]), "users")
delete(conn, obj::User) = db_delete(conn, "users", obj.id)

