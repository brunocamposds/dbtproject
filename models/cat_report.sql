{{
    config(
        materialized='incremental',
        unique_key='category_id'
    )
}}


select       *
from         {{source('sources','categories')}}
{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
    where        update_time > (select max(update_time) from {{ this }})  
{% endif %}
