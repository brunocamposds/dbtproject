{{
    config(
        materialized='table',
        pre_hook=["
            begin;
            select getdate();
            end;
        "],
        post_hook=["
            select getdate();
        "]
    )
}}

select * from {{ref('joins')}}