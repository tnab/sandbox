view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      week_of_year,
      hour_of_day,
      minute,
      day_of_week,
      day_of_week_index,
      day_of_month,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: is_before_ytd {
    type: yesno
    sql:
      (EXTRACT(DAY FROM ${created_time}) < EXTRACT(DAY FROM CURRENT_TIMESTAMP)
          OR
          (
            EXTRACT(DAY FROM ${created_time}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${created_time}) < EXTRACT(HOUR FROM CURRENT_TIMESTAMP)
          )
          OR
          (
            EXTRACT(DAY FROM ${created_time}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${created_time}) <= EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AND
            EXTRACT(MINUTE FROM ${created_time}) < EXTRACT(MINUTE FROM CURRENT_TIMESTAMP)
          )
        )
      ;;
  }

  dimension: yoy {
    type: yesno
    sql:
    (
    (${created_month} < month(current_timestamp))
    OR
    ${created_month} =  month(CURRENT_TIMESTAMP)
    AND
    ${created_day_of_month} <=  DAYOFMONTH (CURRENT_TIMESTAMP)
    );;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: age_groups {
    type: tier
    tiers: [0, 18, 30, 60]
    style: integer
    sql: ${age} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
