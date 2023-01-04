with prod as (
    select       ct.category_name
                ,sp.company_name  as suppliers
                ,pd.product_name
                ,pd.unit_price
                ,pd.product_id
    from         {{source('sources','products')}}      as pd
    left join    {{source('sources','suppliers')}}     as sp
    on           pd.supplier_id = sp.supplier_id
    left join    {{source('sources','categories')}}    as ct
    on           pd.category_id = ct.category_id
    ),
    orddetai as (
        select   pd.*
                ,od.order_id
                ,od.quantity
                ,od.discount
        from     {{ref('order_details')}} as od
        left join prod                    as pd
        on       od.product_id = pd.product_id
    )
    select * from orddetai