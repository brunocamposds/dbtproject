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
                ,od.discounts
        from     {{ref('order_details')}} as od
        left join prod                    as pd
        on       od.product_id = pd.product_id
    ),
    ordrs as (
        select       ord.order_date
                    ,ord.order_id
                    ,cs.company_name      as customer
                    ,emp.name             as employee
                    ,emp.age
                    ,emp.length_of_service
        from         {{source('sources', 'orders')}}    as ord
        left join    {{ref('customers')}}               as cs
        on           ord.customer_id = cs.customer_id
        left join    {{ref('employees')}}               as emp
        on           ord.employee_id = emp.employee_id
        left join    {{source('sources','shippers')}}     as sh
        on           ord.ship_via = sh.shipper_id
    ),
    final_join as (
        select       od.*
                    ,ord.order_date
                    ,ord.customer
                    ,ord.employee
                    ,ord.age
                    ,ord.length_of_service
        from         ordrs      as ord
        inner join   orddetai   as od
        on           ord.order_id = od.order_id
    )

    select * from final_join limit 3000