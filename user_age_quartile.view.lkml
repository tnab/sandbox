view: user_age_quartile{

  sql_table_name:
    (SELECT id AS user_id,
    NTILE(4) OVER (ORDER BY age) as quartile
    FROM demo_db.users)
    ;;


  dimension: user_id {}
  dimension: quartile {type: number}


#   parameter: bucket_size {
#     default_value: "10"
#     type: number
#   }

}
