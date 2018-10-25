connection: "thelook"

# include all the views
include: "*.view"
include: "test.lkml"
# include: "datagroup_test.model"
# include all the dashboards
# include: "*.dashboard.lookml"

datagroup: sandbox_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: sandbox_default_datagroup

explore: derived_test_base {}

explore: users_extended {}

# explore: test {
#   from: users
#
#   join: user_data {
#     sql_on: ${user_data.user_id} = ${test.id} ;;
#     relationship: one_to_one
#   }
#
# }


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
  # access_filter: {
  #   field: orders.id
  #   user_attribute: clear
  # }
  join: others {
    from: users
    type: left_outer
    sql_on: ${orders.user_id} = ${others.id} ;;
    relationship: many_to_one
  }

  join: order_items {
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: one_to_many
  }

  join: 7days {
    from: orders
    sql_on: date_sub(${7days.created_date}, interval 7 day) = ${orders.created_date} ;;
    relationship: many_to_many
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

# explore: buckets {
#   join: bucket_size {
#     sql_on: ${buckets.id} =  ${bucket_size.id} ;;
#     relationship: one_to_one
#   }
# }

explore: bucket_size {}

explore: users {
  join: user_age_quartile {
    sql_on: ${users.id} = ${user_age_quartile.user_id} ;;
    relationship: one_to_one
  }
  join: bucket_size {
    sql_on: ${bucket_size.age} = ${users.age} ;;
    relationship: many_to_many
  }
}

explore: user_age_quartile {}

explore: users_nn {}
