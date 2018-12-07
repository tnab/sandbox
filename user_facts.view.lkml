view: user_facts{
  derived_table: {
    sql:  SELECT
            user_id as user_id
            , COUNT(o.id) as user_lifetime_orders
            , COUNT(oi.id) as user_lifetime_items
            , MAX(o.created_at) as most_recent_purchase_at
            , SUM(oi.sale_price) as user_lifetime_spent
            , COUNT(DISTINCT city) as city_count
            , COUNT(DISTINCT zip) as zip_count
            , COUNT(DISTINCT state) as state_count
            , SUM(CASE WHEN o.status = "complete" THEN 1 ELSE 0 END) as count_complete_orders
            , SUM(CASE WHEN o.status = "pending" THEN 1 ELSE 0 END) as count_pending_orders
            , SUM(CASE WHEN oi.returned_at IS NOT NULL THEN 1 ELSE 0 END) as count_returned_orders


          FROM demo_db.users u
          JOIN demo_db.orders o
          ON u.id = o.user_id
          JOIN demo_db.order_items oi
          ON oi.order_id = o.id
          GROUP BY 1  ;;
  }


# Define your dimensions and measures here, like this:
  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: most_recent_purchase {
    description: "The date when each user last ordered"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.most_recent_purchase_at ;;
  }

  dimension: city_count {
    type: number
    sql: ${TABLE}.city_count ;;
    hidden: yes
  }

  dimension: zip_count {
    type: number
    sql: ${TABLE}.zip_count ;;
    hidden: yes
  }

  dimension: state_count {
    type: number
    sql: ${TABLE}.state_count ;;
    hidden: yes
  }

  # A yesno reflecting if they’ve moved (have multiple addresses on file)
  dimension: moved {
    type: yesno
    sql: ${city_count} > 1 OR ${state_count} > 1 OR ${zip_count} > 1  ;;
  }

#   The total amount they’ve spent
  dimension: user_lifetime_spent {
    type: number
    sql: ${TABLE}.user_lifetime_spent ;;
    value_format: "0.00$"
  }

#   The number of orders they’ve placed
  dimension: user_lifetime_orders {
    description: "The total number of orders for each user"
    type: number
    sql: ${TABLE}.user_lifetime_orders ;;
  }

  dimension: user_lifetime_items{
    type: number
    sql: ${TABLE}.user_lifetime_items ;;
  }

#   The average number of items per order
  dimension: avg_items_per_order{
    type: number
    sql: ${user_lifetime_items}/${user_lifetime_orders} ;;
    value_format: "0.0"
  }

#   The average Price of items ordered
  dimension: avg_price_per_item{
    type: number
    sql: ${user_lifetime_spent}/${user_lifetime_items} ;;
  }

#   Completed orders
  dimension: count_complete_orders {
    type: number
    sql: ${TABLE}.count_complete_orders ;;
  }

# Pending orders
  dimension: count_pending_orders {
    type: number
    sql: ${TABLE}.count_pending_orders ;;
  }

#   Returned orders
  dimension: count_returned_orders {
    type: number
    sql: ${TABLE}.count_returned_orders ;;
  }

  measure: lifetime_order_count {
    description: "Use this for counting lifetime orders across many users"
    type: sum
    sql: ${user_lifetime_orders} ;;
  }

  measure: lifetime_spent_total {
    type: sum
    sql: ${user_lifetime_spent} ;;
    value_format: "0.00$"
  }



}
