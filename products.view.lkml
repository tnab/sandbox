view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

#   dimension: test_division {
#     type: number
#     sql: ${test_sum}/${test_running} ;;
#     value_format_name: usd
#   }

  measure: test_div_measure {
    type: number
    sql: ${test_sum}/${test_running} ;;
    value_format_name: usd
  }

  measure: test_running {
    type: running_total
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: test_sum {
    type: sum
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
}
