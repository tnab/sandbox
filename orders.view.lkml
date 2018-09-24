view: orders {
  sql_table_name: demo_db.orders;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      quarter_of_year,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: meta__form_id {
    type: string
    sql: ${TABLE}.status ;;
    description: "meta formid from commcare"
    label: "1. Form ID"

#     link: {
#       label: "See in Commcare"
#       url: "https://ec2-18-232-113-228.compute-1.amazonaws.com:9999/looks/2"
#       icon_url: "https://dnwn0mt1jqwp0.cloudfront.net/static/hqwebapp/images/favicon.png?version=bd1fede"
#     }

    link: {
      label: "{{ orders.status._value }}"
      url:"
      {% if orders.status._value == 'pending' %}
      https://ec2-18-232-113-228.compute-1.amazonaws.com:9999/looks/10
      {% else %}
      No valid link
      {% endif %}"
    }
  }

  dimension: status_fomratted_ticket {
    sql: ${TABLE}.status ;;
    html:
    {% if value == 'Paid' %}
      <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value == 'Shipped' %}
      <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
;;
  }

  dimension: status_fomratted {
    sql: ${TABLE}.status ;;
    html:
    {% if value == 'Paid' %}
      <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value == 'Shipped' %}
      <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
;;
  }

  measure: count_formatted {
    type: count
    html:
    {% if orders.status._value == 'pending' %}
      <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif orders.status._value == 'complete' %}
      <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
;;
  }



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
