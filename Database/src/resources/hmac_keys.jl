using Parameters, DataFrames, Random, TimeZones

@with_kw mutable struct HmacKey
    id::String = randstring(32)
    key::String
    algorithm::String
    updated_at::String = string(now(localzone()))
end

function HmacKey(row::DataFrameRow)
    return HmacKey(
        id = row.id,
        key = row.key,
        algorithm = row.algorithm,
        updated_at = row.updated_at
    )
end

create(conn, obj::HmacKey) = db_insert(conn, DataFrame([ obj ]), "hmac_keys")
delete(conn, obj::HmacKey) = db_delete(conn, "hmac_keys", obj.id)

