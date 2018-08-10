connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: sandbox_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: sandbox_default_datagroup

explore: derived_test_base {
#   join: derived_test_self {
#     from: derived_test_base
#     sql_on: ${derived_test_base.city} = ${derived_test_self.city} ;;
#     relationship: many_to_many
#   }
}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} AND ${events.user_id} < 6 ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}


explore: order_items_test {
  from: order_items
  view_name: order_items
  sql_always_where:
  CASE
  WHEN {% parameter order_items.period %} = 'mtd'
  THEN ${is_before_mtd} else ${is_before_ytd} end
  ;;
}

explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} AND ${users.id}  ;;
    relationship: many_to_one
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: users_nn {}
