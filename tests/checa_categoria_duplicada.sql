
select       count(1)
            ,category_name
from         {{ref('cat_report')}}
group by     category_name
having       count(1) > 1

