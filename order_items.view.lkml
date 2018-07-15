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

  dimension: within_range {
    type: yesno
    sql: ${returned_date} > ${test_date}
      AND ${returned_date} < CURDATE();;
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

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
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
}
