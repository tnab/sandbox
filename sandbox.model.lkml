connection: "thelook"

# include all the views
include: "*.view"
include: "test.lkml"
# include all the dashboards
include: "*.dashboard.lookml"

datagroup: the_looker_etl {
  sql_trigger: SELECT MAX(users.created_at) FROM demo_db.users;;
  max_cache_age: "48 hour"
}

# week_start_day: sunday

persist_with: the_looker_etl

explore: derived_test_base {}

# explore: users_extended {}

explore: oi_test {
  from: order_items
}

explore: user_facts {}

# explore: users {}


# explore: test {
#   from: users
#
#   join: user_data {
#     sql_on: ${user_data.user_id} = ${test.id} ;;
#     relationship: one_to_one
#   }
#
# }

explore: users {}

# explore: order_items {
#
#   join: orders {
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#   join: users {
#     sql_on: {% if _user_attributes['limit_view'] == 'test_liq' %}
#       ${users.id} = ${orders.user_id}
#       {% else %}
#        1 = 4
#     {% endif %};;
#   }
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
    view_label: "test"
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
    fields: []
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  # join: users {
  #   type: left_outer
  #   sql_on: ${orders.user_id} = ${users.id} AND ${users.id}  ;;
  #   relationship: many_to_one
  # }

}

explore: orders {
  # access_filter: {
  #   field: orders.id
  #   user_attribute: clear
  # }
#   join: others {
#     from: users
#     type: left_outer
#     sql_on: ${orders.user_id} = ${others.id} ;;
#     relationship: many_to_one
#   }
#
  join: order_items {
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: one_to_many
  }
  join: users {
    relationship: many_to_one
    sql_on: orders.user_id ;;
  }

#   join: 7days {
#     from: orders
#     sql_on: date_sub(${7days.created_date}, interval 7 day) = ${orders.created_date} ;;
#     relationship: many_to_many
#   }
}

explore: products {}

explore: schema_migrations {}

explore: user_data {
  join: users {
    type: left_outer
    sql_on: ${user_data.user_id_to_change} = ${users.id} ;;
    relationship: many_to_one
  }
}


explore: bucket_size {}

explore: users_a {
  view_name: users

  join: user_age_quartile {
    sql_on: ${users.id} = ${user_age_quartile.user_id} ;;
    relationship: one_to_one
  }
  join: bucket_size {
    sql_on: ${bucket_size.age} = ${users.age} ;;
    relationship: many_to_many
  }
  join: user_facts {
    sql_on: ${user_facts.user_id} = ${users.id} ;;
    relationship: one_to_one
    # fields: []
  }
}

explore: user_age_quartile {}

explore: users_nn {}
