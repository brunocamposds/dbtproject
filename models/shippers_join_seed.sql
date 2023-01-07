
select       sh.company_name
            ,sh.phone
            ,se.*
from         {{source('sources', 'shippers')}} as sh
left join    {{ref('shippers_email')}}         as se
on           sh.shipper_id = se.shipper_id