view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: returned {
    type: yesno
    sql: ${returned_date} is not null ;;

  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

# Test MTD from Zach's discourse post

  dimension: is_before_mtd {
    type: yesno
    sql:
      (EXTRACT(DAY FROM ${returned_time}) < EXTRACT(DAY FROM CURRENT_TIMESTAMP)
          OR
          (
            EXTRACT(DAY FROM ${returned_time}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${returned_time}) < EXTRACT(HOUR FROM CURRENT_TIMESTAMP)
          )
          OR
          (
            EXTRACT(DAY FROM ${returned_time}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${returned_time}) <= EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AND
            EXTRACT(MINUTE FROM ${returned_time}) < EXTRACT(MINUTE FROM CURRENT_TIMESTAMP)
          )
        )
      ;;
  }



  dimension: is_before_ytd {
    type: yesno
    sql:
      (EXTRACT(DAY FROM ${returned_time}) < EXTRACT(DAY FROM CURRENT_TIMESTAMP)
          OR
          (
            EXTRACT(DAY FROM ${returned_time}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${returned_time}) < EXTRACT(HOUR FROM CURRENT_TIMESTAMP)
          )
          OR
          (
            EXTRACT(DAY FROM ${returned_time}) = EXTRACT(DAY FROM CURRENT_TIMESTAMP) AND
            EXTRACT(HOUR FROM ${returned_time}) <= EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AND
            EXTRACT(MINUTE FROM ${returned_time}) < EXTRACT(MINUTE FROM CURRENT_TIMESTAMP)
          )
        )
      ;;
  }

# Sum after a date test

  dimension_group: test {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: DATE_ADD("2017-03-01", INTERVAL 2 MONTH) ;;
  }

  dimension: within_range {
    type: yesno
    sql: ${returned_date} > ${test_date}
      AND ${returned_date} < CURDATE();;
  }

  measure: sum_price {
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [details*]
    value_format: "0.##"
  }

  measure: test_sum_price {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: within_range
      value: "yes"
    }
    drill_fields: [details*]
    value_format: "0.##"
  }

  set: details {
    fields: [
      id,
      test_date,
      returned_date,
      sale_price,
      within_range
    ]
  }
#   End of sum test
}
