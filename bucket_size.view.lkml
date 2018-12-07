view: bucket_size {

  derived_table: {
    sql: SELECT
      age AS age,
      max(age) AS max,
      min(age) AS min
      FROM demo_db.users
  ;;
    persist_for: "10 hours"
    indexes: ["id"]
  }

  dimension: max {
    type: number
    sql: ${TABLE}.max ;;
  }


  dimension: min {
    type: number
    sql: ${TABLE}.min ;;
  }

#   dimension: id {
#     type: number
#     primary_key: yes
#     sql: ${TABLE}.id ;;
#   }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: range {
    type: number
    sql: ${max}-${min} ;;
  }

}
