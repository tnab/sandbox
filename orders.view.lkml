view: orders {
  sql_table_name: demo_db.orders;;

  dimension: id {
    primary_key: yes
#     label: "{% if _view._name == 'billing' %} Billing {% else %} Shipping {% endif %}"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      day_of_week_index,
      week,
      week_of_year,
      month,
      quarter,
      quarter_of_year,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: test_week {
    type: date_week_of_year
    sql: ${TABLE}.created_at ;;
  }

  dimension: week_of_year {
    type: date_week_of_year
    sql: now() ;;
  }

  dimension: comparison {
    type: yesno
    sql: ${created_week_of_year} = ${week_of_year} ;;
  }

  dimension: comparison2 {
    type: yesno
    sql: ${created_week_of_year} = ${test_week} ;;
  }

  dimension: testing_html {
    type: string
    html:
    <ul>
    <li> {{users.id._value}} </li>
    <li> {{users.state._value}} </li>

    </ul>;;
    sql: 1 ;;
  }

    # <li> {{places.address._value}} </li>
    # <li> {{places.city._value}}, {{places.state._value}} {{places.postal_code._value}} </li>

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: latest_date {
    type: date
    sql: max(${created_date}) ;;

  }

#   measure: count_distinct {
#     type: count_distinct
#     sql: ${status};;
#   }

######## Testing for Tom ###############

  filter: range {
    type: date
  }

  dimension: in_range{
    type: yesno
    sql: {% condition range %} ${created_date} {% endcondition %} ;;
  }

  measure: filtered_sum {
    type: sum
    sql: ${sale_price} ;;

    filters: {
      field: in_range
      value: "yes"
    }
}

measure: running_sum {
  type: running_total
  sql: ${sale_price} ;;
}

measure: plain_sum {
  type: sum
  sql: ${sale_price} ;;
}

########### End of testing ################
#
# dimension: test_view {
#   type: string
#   sql: 'test' ;;
#   html:
#       <!DOCTYPE html>
#     <html>
#     <head>
#     <meta name="viewport" content="width=device-width, initial-scale=1">
#     <style>
#     * {
#         box-sizing: border-box;
#     }
#
#     /* Create three equal columns that floats next to each other */
#     .column {
#         float: left;
#         width: 33.33%;
#         padding: 10px;
#         height: 300px; /* Should be removed. Only for demonstration */
#     }
#
#     /* Clear floats after the columns */
#     .row:after {
#         content: "";
#         display: table;
#         clear: both;
#     }
#     </style>
#     </head>
#     <body>
#
#     <h2>Three Equal Columns</h2>
#
#     <div class="row">
#       <div class="column" style="background-color:#aaa;">
#         <h2>Column 1</h2>
#         <p>test 1</p>
#       </div>
#       <div class="column" style="background-color:#bbb;">
#         <h2>Column 2</h2>
#         <p>test 2</p>
#       </div>
#       <div class="column" style="background-color:#ccc;">
#         <h2>Column 2</h2>
#         <p>test 3</p>
#       </div>
#     </div>
#
#     </body>
#     </html>
#       ;;
# }
#
# dimension: meta__form_id {
#   type: string
#   sql: ${TABLE}.status ;;
#   description: "meta formid from commcare"
#   label: "1. Form ID"
#
# #     link: {
# #       label: "See in Commcare"
# #       url: "https://ec2-18-232-113-228.compute-1.amazonaws.com:9999/looks/2"
# #       icon_url: "https://dnwn0mt1jqwp0.cloudfront.net/static/hqwebapp/images/favicon.png?version=bd1fede"
# #     }
#
#   link: {
#     label: "{{ orders.status._value }}"
#     url:"
#     {% if orders.status._value == 'pending' %}
#     https://ec2-18-232-113-228.compute-1.amazonaws.com:9999/looks/10
#     {% else %}
#     No valid link
#     {% endif %}"
#   }
# }
#
# dimension: status_fomratted_ticket {
#   sql: ${TABLE}.status ;;
#   html:
#     {% if value == 'Paid' %}
#       <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% elsif value == 'Shipped' %}
#       <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% else %}
#       <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% endif %}
# ;;
# }
#
# dimension: status_fomratted {
#   sql: ${TABLE}.status ;;
#   html:
#     {% if value == 'Paid' %}
#       <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% elsif value == 'Shipped' %}
#       <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% else %}
#       <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% endif %}
# ;;
# }
#
# measure: count_formatted {
#   type: count
#   html:
#     {% if orders.status._value == 'pending' %}
#       <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% elsif orders.status._value == 'complete' %}
#       <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% else %}
#       <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% endif %}
# ;;
# }
# ###################################################
# # Warby Parker test
#
# filter: date_filter {
#   type: date
# }
#
# dimension: test_date {
#   type: date
#   sql: date_sub(curdate(), interval 7 day) ;;
# }
#
dimension: sale_price {
  type: number
  sql: ${order_items.sale_price} ;;
}
#
# measure: max_sale_price {
#   type: max
#   sql: ${sale_price} ;;
# }
#
# dimension: size_date {
#   type: date
#   suggestions: ["7 days","30 days","90 days"]
#   sql: CASE WHEN {% condition %} "7 days" {% endcondition %} THEN date_sub(${created_date}, interval 7 day)
#           WHEN {% condition %} "30 days" {% endcondition %} THEN date_sub(${created_date}, interval 30 day)
#           WHEN {% condition %} "90 days" {% endcondition %} THEN date_sub(${created_date}, interval 90 day)
#           ;;
# }
#
# dimension: start_date_size {
#   type: number
#   sql: case when ${created_date} = {% date_start date_filter %} then ${order_items.sale_price} end ;;
# }
# dimension: end_date_size {
#   type: number
#   sql: case when ${created_date} = {% date_end date_filter %} then ${order_items.sale_price} end ;;
# }
#
# #   dimension: date_7_days_ago {
# #     type: date
# #     sql: date_sub(curdate(), interval 7 day) ;;
# #   }
# #
# dimension: size_7_days_ago {
#   type: number
#   sql: case when ${created_date} = date_sub(curdate(), interval 7 day) then ${order_items.sale_price} end;;
# }
#
# #   dimension: date_30_days_ago {
# #     type: date
# #     sql: date_sub(curdate(), interval 30 day) ;;
# #   }
#
# dimension: size_30_days_ago {
#   type: number
#   sql: case when ${created_date} = date_sub(curdate(), interval 30 day) then ${order_items.sale_price} end;;
# }
#
# #   dimension: date_90_days_ago {
# #     type: date
# #     sql: date_sub(curdate(), interval 90 day) ;;
# #   }
#
# dimension: size_90_days_ago {
#   type: number
#   sql: case when ${created_date} = date_sub(curdate(), interval 90 day) then ${order_items.sale_price} end;;
# }
#
#
#
#
# dimension: size_diff {
#   type: number
#   sql: ${start_date_size}  - ${end_date_size};;
# }
#
dimension: user_id {
  type: number
  # hidden: yes
  sql: ${TABLE}.user_id ;;
}

measure: count {
  type: count
  drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
}
}
